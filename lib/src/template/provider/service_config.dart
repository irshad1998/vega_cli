import 'package:vega_cli/src/template/interface/template.dart';

class ProviderServiceConfigTemplate extends Template {
  ProviderServiceConfigTemplate()
      : super('lib/app/services/service_config.dart', overwrite: true);

  String get _functionsTemplate => '''

  class ServiceConfig {}

  ''';

  @override
  String get content => _functionsTemplate;
}
