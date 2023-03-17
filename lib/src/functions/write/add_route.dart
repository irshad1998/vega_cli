import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';
import 'package:vega_cli/src/functions/create/create_single_file.dart';
import 'package:vega_cli/src/functions/find_file/find_file.dart';
import 'package:vega_cli/src/functions/sort/sort_imports.dart';
import 'package:vega_cli/src/template/provider/app_pages.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

void addAppPages(String routeName) {
  var appPagesFile = findFileByName('app_pages.dart');

  var pageIdentifier = '''static const routeError = '/errorView';''';
  var importIdentifier = '''part 'app_routes.dart';''';

  var lines = <String>[];

  if (appPagesFile.path.isEmpty) {
    ProviderAppPagesTemplate().create(skipFormatter: true);
    appPagesFile = File(ProviderAppPagesTemplate().path);
    lines = appPagesFile.readAsLinesSync();
  } else {
    var content = formatterDartFile(appPagesFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }

  var pageInsertIndex =
      lines.indexWhere((element) => element.contains(pageIdentifier));
  var importInsertIndex =
      lines.indexWhere((element) => element.contains(importIdentifier));

  lines.insert(pageInsertIndex,
      '''static const route${routeName.pascalCase} = '/${routeName.camelCase}View'; ''');

  lines.insert(importInsertIndex, '''
      import 'package:${PubspecUtils.projectName}/app/modules/$routeName/views/${routeName}_view.dart';
    ''');

  writeFile(
    appPagesFile.path,
    lines.join('\n'),
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );
}

void addAppRoutes(String routeName) {
  var appRouteFile = findFileByName('app_routes.dart');

  var switchIdentifier = 'default:';

  var lines = <String>[];

  if (appRouteFile.path.isEmpty) {
    ProviderAppRoutesTemplate().create(skipFormatter: true);
    appRouteFile = File(ProviderAppRoutesTemplate().path);
    lines = appRouteFile.readAsLinesSync();
  } else {
    var content = formatterDartFile(appRouteFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }

  var pageInsertIndex =
      lines.indexWhere((element) => element.contains(switchIdentifier));

  lines.insert(pageInsertIndex, '''
case AppPages.route${routeName.pascalCase}:\n
    \t return _buildRoute(AppPages.route${routeName.pascalCase}, const ${routeName.pascalCase}View());
       ''');

  writeFile(
    appRouteFile.path,
    lines.join('\n'),
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );
}
