import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class ProviderMainTemplate extends Template {
  ProviderMainTemplate() : super('lib/main.dart', overwrite: true);

  String get _mainTemplate => '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:${PubspecUtils.projectName}/app/common/multi_provider_list.dart';
import 'package:${PubspecUtils.projectName}/app/routes/app_pages.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderList.providerList,
      child: MaterialApp(
        title: 'Application',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.instance.generateRoute,
      ),
    );
  }
}
  ''';

  @override
  String get content => _mainTemplate;
}
