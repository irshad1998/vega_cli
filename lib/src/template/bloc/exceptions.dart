import 'package:vega_cli/src/template/interface/template.dart';

class BlocExceptionsTemplate extends Template {
  BlocExceptionsTemplate()
      : super('lib/app/core/exceptions/api_exceptions.dart', overwrite: true);

  String get _functionsTemplate => '''
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exceptions.freezed.dart';

@freezed
class ApiExceptions with _\$ApiExceptions {
  const factory ApiExceptions.clientSideFailure() = _ClinentSideFailure;
  const factory ApiExceptions.serverSideFailure() = _ServerSideFailure;
  const factory ApiExceptions.noData() = _NoData;
}
''';

  @override
  String get content => _functionsTemplate;
}
