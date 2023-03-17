import 'dart:io';

import 'package:path/path.dart';
import 'package:vega_cli/src/functions/version/check_dev_version.dart';
import 'package:vega_cli/src/utils/log/logger.dart';
import 'package:yaml/yaml.dart';

class PubspecLock {
  static Future<String?> getVersionCli({bool disableLog = false}) async {
    try {
      var scriptFile = Platform.script.toFilePath();
      var pathToPubLock = join(dirname(scriptFile), '../pubspec.lock');
      final file = File(pathToPubLock);
      var text = loadYaml(await file.readAsString());
      if (text['packages']['get_cli'] == null) {
        if (isDevVersion()) {
          if (!disableLog) {
            Logger2.info('Development version');
          }
        }
        return null;
      }
      var version = text['packages']['get_cli']['version'].toString();
      return version;
    } on Exception catch (_) {
      if (!disableLog) {
        Logger2.error('Cli version not found');
      }
      return null;
    }
  }
}
