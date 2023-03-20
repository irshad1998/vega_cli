import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';
import 'package:vega_cli/src/functions/create/create_single_file.dart';
import 'package:vega_cli/src/functions/find_file/find_file.dart';
import 'package:vega_cli/src/functions/sort/sort_imports.dart';
import 'package:vega_cli/src/template/provider/multi_provider_list.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

addProvider(String name) async {
  var providerListFile = findFileByName('multi_provider_list.dart');

  var lineIdentifier = '];';
  var importIdentifier =
      '''import 'package:provider/single_child_widget.dart';''';

  var lines = <String>[];

  if (providerListFile.path.isEmpty) {
    ProviderMultiProviderListTemplate().create(skipFormatter: true);
    providerListFile = File(ProviderMultiProviderListTemplate().path);
    lines = providerListFile.readAsLinesSync();
  } else {
    var content = formatterDartFile(providerListFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }

  var providerInsertIndex =
      lines.indexWhere((element) => element.contains(lineIdentifier));
  var importInsertIndex =
      lines.indexWhere((element) => element.contains(importIdentifier)) + 1;

  lines.insert(providerInsertIndex,
      '''ChangeNotifierProvider(create: (_) => ${name.pascalCase}Provider()), ''');
  lines.insert(importInsertIndex,
      '''import 'package:${PubspecUtils.projectName}/app/modules/$name/providers/${name}_provider.dart';''');

  writeFile(
    providerListFile.path,
    lines.join('\n'),
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );
}
