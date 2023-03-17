import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:pubspec/pubspec.dart';
import 'package:vega_cli/src/common/menu.dart';
import 'package:vega_cli/src/utils/log/logger.dart';
import 'package:vega_cli/src/utils/pubdev/pub_dev_api.dart';
import 'package:vega_cli/src/utils/pubspec/yaml_to_string.dart';
import 'package:vega_cli/src/utils/shell/shell_utils.dart';

class PubspecUtils {
  static final _pubspecFile = File('pubspec.yaml');

  static PubSpec get pubSpec =>
      PubSpec.fromYamlString(_pubspecFile.readAsStringSync());

  /// separtor
  static final _mapSep = _PubValue<String>(() {
    var yaml = pubSpec.unParsedYaml!;
    if (yaml.containsKey('get_cli')) {
      if ((yaml['get_cli'] as Map).containsKey('separator')) {
        return (yaml['get_cli']['separator'] as String?) ?? '';
      }
    }

    return '';
  });

  static String? get separatorFileType => _mapSep.value;

  static final _mapName = _PubValue<String>(() => pubSpec.name?.trim() ?? '');

  static String? get projectName => _mapName.value;

  static final _extraFolder = _PubValue<bool?>(
    () {
      try {
        var yaml = pubSpec.unParsedYaml!;
        if (yaml.containsKey('fcli')) {
          if ((yaml['fcli'] as Map).containsKey('sub_folder')) {
            return (yaml['fcli']['sub_folder'] as bool?);
          }
        }
      } on Exception catch (_) {}
      // retorno nulo está sendo tratado
      // ignore: avoid_returning_null
      return null;
    },
  );

  static bool? get extraFolder => _extraFolder.value;

  static Future<bool> addDependencies(String package,
      {String? version, bool isDev = false, bool runPubGet = true}) async {
    Logger logger = Logger();
    // var installPackageProgress = logger.progress('Installing package $package');
    var pubSpec = PubSpec.fromYamlString(_pubspecFile.readAsStringSync());
    if (containsPackage(package)) {
      Logger2.info(
          'package: $package already installed, do you want to update?',
          false,
          false);
      final menu = Menu(
        [
          'Yes',
          'No',
        ],
      );
      final result = menu.choose();
      if (result.index != 0) {
        return false;
      }
    }
    version = version == null || version.isEmpty
        ? await PubDevApi.getLatestVersionFromPackage(package)
        : '^$version';
    if (version == null) return false;
    if (isDev) {
      pubSpec.devDependencies[package] = HostedReference.fromJson(version);
    } else {
      pubSpec.dependencies[package] = HostedReference.fromJson(version);
    }
    _savePub(pubSpec);
    // installPackageProgress.complete();
    if (runPubGet) {
      var runPubProgress = logger.progress('Running flutter pub get');
      try {
        await ShellUtils.pubGet();
        runPubProgress.complete();
      } catch (e) {
        runPubProgress.fail();
        return false;
      }
    }
    return true;
  }

  static void removeDependencies(String package, {bool logger = true}) {
    if (logger) Logger2.info('Removing package: "$package"');

    if (containsPackage(package)) {
      var dependencies = pubSpec.dependencies;
      var devDependencies = pubSpec.devDependencies;

      dependencies.removeWhere((key, value) => key == package);
      devDependencies.removeWhere((key, value) => key == package);
      var newPub = pubSpec.copy(
        devDependencies: devDependencies,
        dependencies: dependencies,
      );
      _savePub(newPub);
      if (logger) {
        Logger2.success('Package: $package removed!');
      }
    } else if (logger) {
      Logger2.info('$package not installed');
    }
  }

  static bool containsPackage(String package, [bool isDev = false]) {
    var dependencies = isDev ? pubSpec.devDependencies : pubSpec.dependencies;
    return dependencies.containsKey(package.trim());
  }

  static void _savePub(PubSpec pub) {
    var value = const CliYamlToString().toYamlString(pub.toJson());
    _pubspecFile.writeAsStringSync(value);
  }
}

class _PubValue<T> {
  final T Function() _setValue;
  bool _isChecked = false;
  T? _value;

  /// takes the value of the file,
  /// if not already called it will call the first time
  T? get value {
    if (!_isChecked) {
      _isChecked = true;
      _value = _setValue.call();
    }
    return _value;
  }

  _PubValue(this._setValue);
}
