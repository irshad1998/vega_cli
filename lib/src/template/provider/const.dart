import 'package:vega_cli/src/template/interface/template.dart';

class ProviderConstTemplate extends Template {
  ProviderConstTemplate() : super('lib/app/common/const.dart', overwrite: true);

  String get _functionsTemplate => '''

  class Constants {}

  enum ScreenState { loaded, loading, error, networkError, noData }

  ''';

  @override
  String get content => _functionsTemplate;
}
