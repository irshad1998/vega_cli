import 'package:vega_cli/src/template/interface/template.dart';

class ProviderViewTemplate extends Template {
  final String _viewName;

  ProviderViewTemplate(String path, this._viewName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  String get _flutterView => '''import 'package:flutter/material.dart';

class $_viewName extends StatelessWidget {
 const $_viewName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$_viewName'),
        centerTitle: false,
      ),
      body:const Center(
        child: Text(
          'Vega View ✨', 
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}
  ''';

  @override
  String get content => _flutterView;
}
