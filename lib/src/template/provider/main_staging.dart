import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class ProviderMainStagingTemplate extends Template {
  ProviderMainStagingTemplate()
      : super('lib/main_staging.dart', overwrite: true);

  String get _mainDevelopTemplate => '''
  import 'main.dart';
import 'package:${PubspecUtils.projectName}/app/common/configs/flavor_config.dart';

Future<void> main() async {
  FlavourConstants.setEnvironment(Environment.stage);
  await initApp();
}


  ''';

  @override
  String get content => _mainDevelopTemplate;
}
