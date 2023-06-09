import 'package:vega_cli/src/template/interface/template.dart';

class ProviderFlavorConfigTemplate extends Template {
  ProviderFlavorConfigTemplate()
      : super('lib/app/common/configs/flavor_config.dart', overwrite: true);

  String get _functionsTemplate => '''
enum Environment {
  dev,
  stage,
  prod,
}

class FlavourConstants {
  static late Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        _config = _Config.debugConstants;
        break;
      case Environment.stage:
        _config = _Config.stageConstants;
        break;
      case Environment.prod:
        _config = _Config.prodConstants;
        break;
    }
  }

  static String get findFlavour {
    return _config[_Config.flavour] as String;
  }
}

class _Config {
  static const flavour = 'flavour';

  static Map<String, dynamic> debugConstants = {
    flavour: 'dev',
  };

  static Map<String, dynamic> stageConstants = {
    flavour: 'stage',
  };

  static Map<String, dynamic> prodConstants = {
    flavour: 'prod',
  };
}

  ''';

  @override
  String get content => _functionsTemplate;
}
