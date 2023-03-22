import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class BlocInjectableTemplate extends Template {
  BlocInjectableTemplate()
      : super('lib/app/core/di/injectable.dart', overwrite: true);

  String get _functionsTemplate => '''
import 'package:${PubspecUtils.projectName}/app/core/di/injectable.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
void setup() => getIt.init();

  ''';

  @override
  String get content => _functionsTemplate;
}
