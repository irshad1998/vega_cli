import 'dart:io';

import 'package:recase/recase.dart';
import 'package:vega_cli/src/exceptions/exception.dart';
import 'package:vega_cli/src/models/file_model.dart';
import 'package:path/path.dart' as p;

class Structure {
  static final Map<String, String> _paths = {
    'page': Directory(replaceAsExpected(
                path: '${Directory.current.path} /lib/app/pages/'))
            .existsSync()
        ? replaceAsExpected(path: 'lib/app/pages')
        : replaceAsExpected(path: 'lib/app/modules/'),
    'common': replaceAsExpected(path: 'lib/app/common/'),
    'data': replaceAsExpected(path: 'lib/app/data/'),
    'routes': replaceAsExpected(path: 'lib/app/routes/'),
    'services': replaceAsExpected(path: 'lib/app/services/'),
    'utils': replaceAsExpected(path: 'lib/app/utils/'),
    'widgets': replaceAsExpected(path: 'lib/app/widgets/'),
    'configs': replaceAsExpected(path: 'lib/app/common/configs/'),
    'palette': replaceAsExpected(path: 'lib/app/common/palette/'),
    'init': replaceAsExpected(path: 'lib/'),
  };

  static FileModel model(String? name, String command, bool wrapperFolder,
      {String? on, String? folderName}) {
    if (on != null && on != '') {
      on = replaceAsExpected(path: on).replaceAll('\\\\', '\\');
      var current = Directory('lib');
      final list = current.listSync(recursive: true, followLinks: false);
      final contains = list.firstWhere((element) {
        if (element is File) {
          return false;
        }

        return '${element.path}${p.separator}'.contains('$on${p.separator}');
      }, orElse: () {
        return list.firstWhere((element) {
          //Fix erro ao encontrar arquivo com nome
          if (element is File) {
            return false;
          }
          return element.path.contains(on!);
        }, orElse: () {
          throw CommandLineException('Folder $on is not found');
        });
      });

      return FileModel(
        name: name,
        path: Structure.getPathWithName(
          contains.path,
          ReCase(name!).snakeCase,
          createWithWrappedFolder: wrapperFolder,
          folderName: folderName,
        ),
        commandName: command,
      );
    }

    return FileModel(
      name: name,
      path: Structure.getPathWithName(
        _paths[command],
        ReCase(name!).snakeCase,
        createWithWrappedFolder: wrapperFolder,
        folderName: folderName,
      ),
      commandName: command,
    );
  }

  static String replaceAsExpected({required String path, String? replaceChar}) {
    if (path.contains('\\')) {
      if (Platform.isLinux || Platform.isMacOS) {
        return path.replaceAll('\\', '/');
      } else {
        return path;
      }
    } else if (path.contains('/')) {
      if (Platform.isWindows) {
        return path.replaceAll('/', '\\\\');
      } else {
        return path;
      }
    } else {
      return path;
    }
  }

  static String? getPathWithName(String? firstPath, String secondPath,
      {bool createWithWrappedFolder = false, required String? folderName}) {
    late String betweenPaths;
    if (Platform.isWindows) {
      betweenPaths = '\\\\';
    } else if (Platform.isMacOS || Platform.isLinux) {
      betweenPaths = '/';
    }
    if (betweenPaths.isNotEmpty) {
      if (createWithWrappedFolder) {
        return firstPath! +
            betweenPaths +
            folderName! +
            betweenPaths +
            secondPath;
      } else {
        return firstPath! + betweenPaths + secondPath;
      }
    }
    return null;
  }

  static List<String> safeSplitPath(String path) {
    return path.replaceAll('\\', '/').split('/')
      ..removeWhere((element) => element.isEmpty);
  }

  static String pathToDirImport(String path) {
    var pathSplit = safeSplitPath(path)
      ..removeWhere((element) => element == '.' || element == 'lib');
    return pathSplit.join('/');
  }
}
