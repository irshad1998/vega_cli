import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';
import 'package:recase/recase.dart';

class BlocTemplate extends Template {
  final String name;
  BlocTemplate(this.name)
      : super('lib/app/modules/bloc/${name.snakeCase}.dart', overwrite: true);

  String get _functionsTemplate => '''

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '${name.snakeCase}_event.dart';
part '${name.snakeCase}_state.dart';
part '${name.snakeCase}_bloc.freezed.dart';

class ${name.pascalCase}Bloc extends Bloc<${name.pascalCase}Event, ${name.pascalCase}State> {
  ${name.pascalCase}Bloc() : super(const  ${name.pascalCase}State.initial()) {
    on<${name.pascalCase}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}
  ''';

  @override
  String get content => _functionsTemplate;
}
