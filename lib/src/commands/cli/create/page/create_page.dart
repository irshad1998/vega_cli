import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:recase/recase.dart';
import 'package:vega_cli/src/commands/interfaces/command_interface.dart';
import 'package:vega_cli/src/common/menu.dart';
import 'package:vega_cli/src/core/structure.dart';
import 'package:vega_cli/src/core/vega_gen.dart';
import 'package:vega_cli/src/functions/create/create_single_file.dart';
import 'package:vega_cli/src/functions/write/add_multi_bloc.dart';
import 'package:vega_cli/src/functions/write/add_multi_provider.dart';
import 'package:vega_cli/src/functions/write/add_route.dart';
import 'package:vega_cli/src/template/bloc/bloc.dart';
import 'package:vega_cli/src/template/bloc/event.dart';
import 'package:vega_cli/src/template/bloc/state.dart';
import 'package:vega_cli/src/template/provider/provider.dart';
import 'package:vega_cli/src/template/provider/view.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';
import 'package:vega_cli/src/utils/shell/shell_utils.dart';

class CreatePageCommand extends Command {
  String? package;

  CreatePageCommand({this.package});

  @override
  String get commandName => 'page';

  @override
  List<String> get alias => ['page', '-p'];

  @override
  String? get hint => 'Create new page in lib/app/modules';

  @override
  List<String> get acceptedFlags => ['--provider', '--bloc'];

  @override
  Future<void> execute() async {
    var isProject = false;
    if (VegaCli.arguments[0] == 'create' || VegaCli.arguments[0] == '-c') {
      isProject = VegaCli.arguments[1].split(':').first == 'project';
    }
    var name = this.name;
    if (name.isEmpty || isProject) {
      name = 'home';
    }
    checkForAlreadyExists(name);
  }

  void checkForAlreadyExists(String? name) {
    var newFileModel =
        Structure.model(name, 'page', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(newFileModel.path!);

    pathSplit.removeLast();
    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      final menu = Menu(
        [
          'Yes',
          'No',
          'I want to rename',
        ],
        title: 'The page [$name] already exists, do you want to overwrite it?',
      );
      final result = menu.choose();
      if (result.index == 0) {
        if (containsArg('--bloc')) {
          _writeBlocPageFile(path, name!, overwrite: true);
        } else if (containsArg('--provider')) {
          _writeProviderPageFiles(path, name!, overwrite: true);
        } else {
          if (package == 'provider' && name == 'home') {
            _writeProviderPageFiles(path, name!, overwrite: true);
          } else if (package == 'bloc' && name == 'home') {
            _writeBlocPageFile(path, name!, overwrite: true);
          }
        }
      } else if (result.index == 2) {
        var name = ask('what new name for the page?');
        checkForAlreadyExists(name.trim().snakeCase);
      }
    } else {
      Directory(path).createSync(recursive: true);
      if (containsArg('--bloc')) {
        _writeBlocPageFile(path, name!, overwrite: false);
      } else if (containsArg('--provider')) {
        _writeProviderPageFiles(path, name!, overwrite: false);
      } else {
        if (package == 'provider' && name == 'home') {
          _writeProviderPageFiles(path, name!, overwrite: false);
        } else if (package == 'bloc' && name == 'home') {
          _writeBlocPageFile(path, name!, overwrite: false);
        }
      }
    }
  }

  void _writeBlocPageFile(String path, String name,
      {bool overwrite = false}) async {
    var extraFolder = PubspecUtils.extraFolder ?? true;

    /// view file
    var viewFile = handleFileCreate(
      name,
      'view',
      path,
      extraFolder,
      ProviderViewTemplate(
        '',
        '${name.pascalCase}View',
        overwrite: overwrite,
      ),
      'views',
    );

    var blocFile = handleFileCreate(
      name,
      'bloc',
      path,
      extraFolder,
      BlocTemplate(name),
      'bloc',
    );

    var eventFile = handleFileCreate(
      name,
      'event',
      path,
      extraFolder,
      BlocEventTemplate(name),
      'bloc',
    );

    var stateFile = handleFileCreate(
      name,
      'state',
      path,
      extraFolder,
      BlocStateTemplate(name),
      'bloc',
    );

    if (name != 'home') {
      addAppPages(name);
      addAppRoutes(name);
      addBloc(name);
    }

    if (name != 'home') {
      var buildRunnerProgress = Logger().progress('Running build runner ..');
      try {
        await ShellUtils.runBuildRunner();
        buildRunnerProgress.complete();
      } catch (e) {
        buildRunnerProgress.fail();
      }
    }
  }

  /// WRITE NEW FILES
  void _writeProviderPageFiles(String path, String name,
      {bool overwrite = false}) {
    var extraFolder = PubspecUtils.extraFolder ?? true;
    var providerFile = handleFileCreate(
      name,
      'provider',
      path,
      extraFolder,
      ProviderTemplate(
        '',
        name,
        overwrite: overwrite,
      ),
      'providers',
    );
    var viewFile = handleFileCreate(
      name,
      'view',
      path,
      extraFolder,
      ProviderViewTemplate(
        '',
        '${name.pascalCase}View',
        overwrite: overwrite,
      ),
      'views',
    );

    if (name != 'home') {
      addAppPages(name);
      addAppRoutes(name);
      addProvider(name);
    }
  }

  @override
  String get codeSample => 'vega create page product [flags]';

  @override
  int get maxParameters => 0;
}
