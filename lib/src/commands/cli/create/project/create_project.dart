import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:recase/recase.dart';
import 'package:vega_cli/src/commands/cli/init/init.dart';
import 'package:vega_cli/src/commands/interfaces/command_interface.dart';
import 'package:dcli/dcli.dart';
import 'package:vega_cli/src/core/structure.dart';
import 'package:vega_cli/src/template/default_files/analysis_options.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';
import 'package:vega_cli/src/utils/shell/shell_utils.dart';
import 'package:path/path.dart' as p;

class CreateProjectCommand extends Command {
  @override
  String get commandName => 'project';

  @override
  String? get hint => 'Create new project';

  @override
  bool validate() {
    return true;
  }

  @override
  Future<void> execute() async {
    String? nameProject = name;
    if (name == '.') {
      nameProject = Logger().prompt(
        'Please enter a project name : ',
        defaultValue: 'vega-app',
      );
    }

    var path = Structure.replaceAsExpected(
        path: Directory.current.path + p.separator + nameProject.snakeCase);
    await Directory(path).create(recursive: true);

    Directory.current = path;

    var org = 'com.$nameProject}';

    var iosLanguage = 'swift';

    var androidLanguage = 'kotlin';

    var nullSafe = true;

    var linter = true;

    await ShellUtils.flutterCreate(path, org, iosLanguage, androidLanguage);

    await PubspecUtils.addDependencies('flutter_lints',
        isDev: true, runPubGet: false);

    await AnalysisOptionsSample(
            include: 'include: package:flutter_lints/flutter.yaml')
        .create();
    // var pubGetProgress = Logger().progress('Running flutter pub get ..');
    // try {
    //   await ShellUtils.pubGet();
    //   pubGetProgress.complete();
    // } catch (e) {
    //   pubGetProgress.fail();
    //   return;
    // }

    await InitCommand().execute();
  }

  @override
  String get codeSample => 'create project';

  @override
  int get maxParameters => 0;
}
