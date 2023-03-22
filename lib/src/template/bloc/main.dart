import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class BlocMainTemplate extends Template {
  BlocMainTemplate() : super('lib/main.dart', overwrite: true);

  String get _mainTemplate => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:${PubspecUtils.projectName}/app/common/multi_bloc_provider_list.dart';
import 'package:${PubspecUtils.projectName}/app/routes/app_pages.dart';
import 'package:${PubspecUtils.projectName}/app/core/di/injectable.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocList(
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
