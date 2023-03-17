import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class ProviderAppPagesTemplate extends Template {
  ProviderAppPagesTemplate()
      : super('lib/app/routes/app_pages.dart', overwrite: true);

  String get _functionsTemplate => '''
import 'package:flutter/material.dart';
import 'package:${PubspecUtils.projectName}/app/modules/home/views/home_view.dart';
part 'app_routes.dart';
    class AppPages {
      static const routeHome = '/';
      static const routeError = '/errorView';
    }
  ''';

  @override
  String get content => _functionsTemplate;
}

class ProviderAppRoutesTemplate extends Template {
  ProviderAppRoutesTemplate()
      : super('lib/app/routes/app_routes.dart', overwrite: true);

  String get _functionsTemplate => '''
part of 'app_pages.dart';
  class AppRoutes {
     static AppRoutes? _instance;
  static AppRoutes get instance {
    _instance ??= AppRoutes();
    return _instance!;
  }
    Route generateRoute(RouteSettings settings, {var routeBuilders}) {
       var args = settings.arguments;
       switch(settings.name){
        case AppPages.routeHome:
          return _buildRoute(AppPages.routeHome, const HomeView());
          default:
          return _buildRoute(AppPages.routeError, const ErrorView());
       }
    }

       Route _buildRoute(String route, Widget widget,
      {bool enableFullScreen = false}) {
    return MaterialPageRoute(
        fullscreenDialog: enableFullScreen,
        settings: RouteSettings(name: route),
        builder: (_) => widget);
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body:  Center(child: Text('Page Not Found!')));
  }
}
  ''';

  @override
  String get content => _functionsTemplate;
}
