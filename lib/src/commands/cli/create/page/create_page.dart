import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';
import 'package:vega_cli/src/commands/interfaces/command_interface.dart';
import 'package:vega_cli/src/common/menu.dart';
import 'package:vega_cli/src/core/structure.dart';
import 'package:vega_cli/src/core/vega_gen.dart';
import 'package:vega_cli/src/functions/create/create_single_file.dart';
import 'package:vega_cli/src/functions/write/add_route.dart';
import 'package:vega_cli/src/template/provider/provider.dart';
import 'package:vega_cli/src/template/provider/view.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class CreatePageCommand extends Command {
  @override
  String get commandName => 'page';

  @override
  List<String> get alias => ['page', '-p'];

  @override
  String? get hint => 'Create new page in lib/app/modules';

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
        _writeFiles(path, name!, overwrite: true);
      } else if (result.index == 2) {
        var name = ask('what new name for the page?');
        checkForAlreadyExists(name.trim().snakeCase);
      }
    } else {
      Directory(path).createSync(recursive: true);
      _writeFiles(path, name!, overwrite: false);
    }
  }

  /// WRITE NEW FILES
  void _writeFiles(String path, String name, {bool overwrite = false}) {
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
    }
  }

  @override
  String get codeSample => 'get create page:product';

  @override
  int get maxParameters => 0;
}
