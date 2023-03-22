import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';
import 'package:recase/recase.dart';

class BlocEventTemplate extends Template {
  final String name;
  BlocEventTemplate(this.name)
      : super('lib/app/modules/bloc/${name.snakeCase}.dart', overwrite: true);

  String get _functionsTemplate => '''

  part of '${name.snakeCase}_bloc.dart';

@freezed
class ${name.pascalCase}Event with _\$${name.pascalCase}Event {
  const factory ${name.pascalCase}Event.started() = _Started;
}

  ''';

  @override
  String get content => _functionsTemplate;
}
