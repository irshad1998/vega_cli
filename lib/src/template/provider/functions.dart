import 'package:vega_cli/src/template/interface/template.dart';

class ProviderFunctionsTemplate extends Template {
  ProviderFunctionsTemplate()
      : super('lib/app/common/functions.dart', overwrite: true);

  String get _functionsTemplate => '''
import 'package:flutter/scheduler.dart';
  /// Add common functions

  class Functions {

    /// Schedule a function after initState()
    static void afterInit(Function function) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      function();
    });
  } 
  
  }
  ''';

  @override
  String get content => _functionsTemplate;
}
