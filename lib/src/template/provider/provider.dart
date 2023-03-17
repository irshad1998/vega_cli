import 'package:recase/recase.dart';
import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

/// [Sample] file from Module_Controller file creation.
class ProviderTemplate extends Template {
  final String _fileName;
  ProviderTemplate(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => provider;

  String get provider => '''import 'package:flutter/material.dart';
import 'package:${PubspecUtils.projectName}/app/common/const.dart';
import 'package:${PubspecUtils.projectName}/app/utils/provider_helper.dart';

class ${_fileName.pascalCase}Provider extends ChangeNotifier with ProviderHelper {
 
  @override
  void updateScreenState(ScreenState state) {
    screenState = state;
    notifyListeners();
  }
}
''';
}
