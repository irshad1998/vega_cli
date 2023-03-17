import 'package:vega_cli/src/template/interface/template.dart';

class ProviderAppConfigTemplate extends Template {
  ProviderAppConfigTemplate()
      : super('lib/app/common/configs/app_config.dart', overwrite: true);

  String get _functionsTemplate => '''
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  static String baseUrl = "APP_BASE_URL";
  static String appLocale = 'en';
}
  ''';

  @override
  String get content => _functionsTemplate;
}
