import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';
import 'package:vega_cli/src/functions/create/create_single_file.dart';
import 'package:vega_cli/src/functions/find_file/find_file.dart';
import 'package:vega_cli/src/functions/sort/sort_imports.dart';
import 'package:vega_cli/src/template/bloc/multi_providers.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

addBloc(String name) async {
  var blocListFile = findFileByName('multi_bloc_provider_list.dart');

  var importIdentifier = '''import 'package:flutter_bloc/flutter_bloc.dart';''';

  var lineIdentifier = '],';

  var lines = <String>[];

  if (blocListFile.path.isEmpty) {
    BlocMultiBlocProviderListTemplate().create(skipFormatter: true);
    blocListFile = File(BlocMultiBlocProviderListTemplate().path);
    lines = blocListFile.readAsLinesSync();
  } else {
    var content = formatterDartFile(blocListFile.readAsStringSync());
    lines = LineSplitter.split(content).toList();
  }

  var blocInsertIndex =
      lines.indexWhere((element) => element.contains(lineIdentifier));

  var importInsertIndex =
      lines.indexWhere((element) => element.contains(importIdentifier)) + 1;

  lines.insert(blocInsertIndex, '''
      BlocProvider(
          create: (context) => getIt<${name.pascalCase}Bloc>(),
        ),
   ''');

  lines.insert(importInsertIndex,
      '''import 'package:${PubspecUtils.projectName}/app/modules/$name/bloc/${name}_bloc.dart';''');

  writeFile(
    blocListFile.path,
    lines.join('\n'),
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );
}
