import 'package:vega_cli/src/template/interface/template.dart';

class ProviderExtensionTemplate extends Template {
  ProviderExtensionTemplate()
      : super('lib/app/common/extensions.dart', overwrite: true);

  String get _extensionTemplate => '''
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';

  /// Add project extensions here
  /// To log - "string".log();
  extension Log on Object {
    void log({String name = ''}) => devtools.log(toString(), name: name);
  }


  /// To remove splash on a widget
  ///  InkWell(
  ///    onTap: ()=> print('vega_app'),
  ///    child: Text('Click Sample')
  ///  ).removeSplash();
  extension InkWellExtension on InkWell {
  InkWell removeSplash({Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      splashColor: color,
      highlightColor: color,
      child: child,
    );
  }
}

/// To convert a widget to a sliver widget
/// Container().convertToSliver();
extension ConvertToSliver on Widget {
  Widget convertToSliver() {
    return SliverToBoxAdapter(
      child: this,
    );
  }
}

/// To get device width and height
/// final width = context.sw();
/// final height = context.sh();
extension Context on BuildContext {
  double sh({double size = 1.0}) {
    return MediaQuery.of(this).size.height * size;
  }

  double sw({double size = 1.0}) {
    return MediaQuery.of(this).size.width * size;
  }
}

  ''';

  @override
  String get content => _extensionTemplate;
}
