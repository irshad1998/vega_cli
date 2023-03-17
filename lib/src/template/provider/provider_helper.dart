import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class ProviderHelperClassTemplate extends Template {
  ProviderHelperClassTemplate()
      : super('lib/app/utils/provider_helper.dart', overwrite: true);

  String get _functionsTemplate => '''
import 'package:${PubspecUtils.projectName}/app/common/const.dart';
import 'package:${PubspecUtils.projectName}/app/services/service_config.dart';
abstract class ProviderHelper{
  final ServiceConfig serviceConfig = ServiceConfig();
  ScreenState screenState = ScreenState.loaded;

  void pageInit() {}

  void pageDispose() {}

  void updateScreenState(ScreenState state);
}
  ''';

  @override
  String get content => _functionsTemplate;
}
