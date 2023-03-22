import 'package:vega_cli/src/template/interface/template.dart';

class BlocConstTemplate extends Template {
  BlocConstTemplate() : super('lib/app/common/const.dart', overwrite: true);

  String get _functionsTemplate => '''

  class Constants {}

  ''';

  @override
  String get content => _functionsTemplate;
}
