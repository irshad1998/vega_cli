import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart';
import 'package:vega_cli/src/core/structure.dart';
import 'package:vega_cli/src/functions/sort/sort_imports.dart';
import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/log/logger.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

File handleFileCreate(String name, String command, String on, bool extraFolder,
    Template template, String folderName,
    [String sep = '_']) {
  folderName = folderName;
  /* if (folderName.isNotEmpty) {
    extraFolder = PubspecUtils.extraFolder ?? extraFolder;
  } */
  final fileModel = Structure.model(name, command, extraFolder,
      on: on, folderName: folderName);
  var path = '${fileModel.path}$sep${fileModel.commandName}.dart';
  template.path = path;
  return template.create();
}

/// Create or edit the contents of a file
File writeFile(String path, String content,
    {bool overwrite = false,
    bool skipFormatter = false,
    bool logger = true,
    bool skipRename = false,
    bool useRelativeImport = false}) {
  var newFile = File(Structure.replaceAsExpected(path: path));

  if (!newFile.existsSync() || overwrite) {
    if (!skipFormatter) {
      if (path.endsWith('.dart')) {
        try {
          content = sortImports(
            content,
            renameImport: !skipRename,
            filePath: path,
            useRelative: useRelativeImport,
          );
        } on Exception catch (_) {
          if (newFile.existsSync()) {
            Logger2.info("The ${newFile.path} is not a valid dart file");
          }
          rethrow;
        }
      }
    }
    if (!skipRename && newFile.path != 'pubspec.yaml') {
      var separatorFileType = PubspecUtils.separatorFileType!;
      if (separatorFileType.isNotEmpty) {
        newFile = newFile.existsSync()
            ? newFile = newFile
                .renameSync(replacePathTypeSeparator(path, separatorFileType))
            : File(replacePathTypeSeparator(path, separatorFileType));
      }
    }
    newFile.createSync(recursive: true);
    newFile.writeAsStringSync(content);
  }

  return newFile;
}



/// Replace the file name separator
String replacePathTypeSeparator(String path, String separator) {
  if (separator.isNotEmpty) {
    var index = path.indexOf(RegExp(r'controller.dart|model.dart|provider.dart|'
        'binding.dart|view.dart|screen.dart|widget.dart|repository.dart'));
    if (index != -1) {
      var chars = path.split('');
      index--;
      chars.removeAt(index);
      if (separator.length > 1) {
        chars.insert(index, separator[0]);
      } else {
        chars.insert(index, separator);
      }
      return chars.join();
    }
  }

  return path;
}
