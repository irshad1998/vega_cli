import 'package:vega_cli/src/template/interface/template.dart';
import 'package:recase/recase.dart';

class BlocStateTemplate extends Template {
  final String name;
  BlocStateTemplate(this.name)
      : super('lib/app/modules/bloc/${name.snakeCase}.dart', overwrite: true);

  String get _functionsTemplate => '''

 part of '${name.snakeCase}_bloc.dart';

@freezed
class ${name.pascalCase}State with _\$${name.pascalCase}State {
  const factory ${name.pascalCase}State.initial() = _Initial;
}
  ''';

  @override
  String get content => _functionsTemplate;
}
