import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mason_logger/mason_logger.dart' hide cyan;
import 'package:vega_cli/src/commands/cli/create/page/create_page.dart';
import 'package:vega_cli/src/core/structure.dart';
import 'package:vega_cli/src/functions/create/create_list_dir.dart';
import 'package:vega_cli/src/functions/write/write_flavor.dart';
import 'package:vega_cli/src/template/bloc/constants.dart';
import 'package:vega_cli/src/template/bloc/exceptions.dart';
import 'package:vega_cli/src/template/bloc/injectable.dart';
import 'package:vega_cli/src/template/bloc/main.dart';
import 'package:vega_cli/src/template/bloc/multi_providers.dart';
import 'package:vega_cli/src/template/provider/app_config.dart';
import 'package:vega_cli/src/template/provider/app_pages.dart';
import 'package:vega_cli/src/template/provider/develop_main.dart';
import 'package:vega_cli/src/template/provider/extensions.dart';
import 'package:vega_cli/src/template/provider/flavor_config.dart';
import 'package:vega_cli/src/template/provider/functions.dart';
import 'package:vega_cli/src/template/provider/helpers.dart';
import 'package:vega_cli/src/template/provider/main.dart';
import 'package:vega_cli/src/template/provider/main_production.dart';
import 'package:vega_cli/src/template/provider/main_staging.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';
import 'package:vega_cli/src/utils/shell/shell_utils.dart';

import '../../../template/provider/launch_json.dart';

Future<void> initBloc() async {
  var initialDirs = [
    /// ASSETS FOLDERS
    Directory(Structure.replaceAsExpected(path: 'assets/fonts/')),
    Directory(Structure.replaceAsExpected(path: 'assets/images/')),
    Directory(Structure.replaceAsExpected(path: 'assets/icons/')),
    Directory(Structure.replaceAsExpected(path: 'assets/docs/')),

    /// ADDITIONAL FOLDERS
    Directory(Structure.replaceAsExpected(path: 'lib/app/common/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/common/configs/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/data/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/modules/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/routes/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/services/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/utils/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/widgets/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/core/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/core/di/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/core/exceptions/')),
  ];

  createListDirectory(initialDirs);

  /// ADD DEPENDENCIES
  var pubAddDependenciesProgress =
      Logger().progress(cyan('Adding dependencies ..'));
  try {
    await PubspecUtils.addDependencies('dartz', isDev: false, runPubGet: false);
    await PubspecUtils.addDependencies('freezed_annotation',
        isDev: false, runPubGet: false);
    await PubspecUtils.addDependencies('flutter_bloc',
        isDev: false, runPubGet: false);
    await PubspecUtils.addDependencies('injectable',
        isDev: false, runPubGet: false);
    await PubspecUtils.addDependencies('get_it',
        isDev: false, runPubGet: false);
    await PubspecUtils.addDependencies('freezed',
        isDev: true, runPubGet: false);
    await PubspecUtils.addDependencies('build_runner',
        isDev: true, runPubGet: false);
    await PubspecUtils.addDependencies('injectable_generator',
        isDev: true, runPubGet: false);
    pubAddDependenciesProgress.complete();
  } catch (e) {
    pubAddDependenciesProgress.fail();
    return;
  }

  await ShellUtils.pubGet();

  /// Create templates
  var createTemplateProgress =
      Logger().progress(cyan('Generating bloc files ..'));
  try {
    await BlocInjectableTemplate().create();
    await BlocExceptionsTemplate().create();

    /// common files
    await ProviderExtensionTemplate().create();
    await ProviderFunctionsTemplate().create();
    await ProviderHelpersTemplate().create();

    ///
    await ProviderAppConfigTemplate().create();
    await ProviderFlavorConfigTemplate().create();
    await BlocMultiBlocProviderListTemplate().create();

    /// files => lib/app/routes
    await ProviderAppRoutesTemplate().create();
    await ProviderAppPagesTemplate().create();

    ///
    await ProviderMainDevelopTemplate().create();
    await ProviderMainProductionTemplate().create();
    await ProviderMainStagingTemplate().create();

    ///
    await BlocConstTemplate().create();
    await BlocMainTemplate().create();

    createTemplateProgress.complete();
  } catch (e) {
    createTemplateProgress.fail();
    return;
  }
  File('assets/docs/launch.json').writeAsStringSync(launchJsonData);
  writeAndroidFlavor();

  var pageCreationProgress =
      Logger().progress(cyan('Generating module home ..'));
  try {
    /// create page
    await Future.wait([CreatePageCommand(package: 'bloc').execute()]);
    pageCreationProgress.complete();
  } catch (_) {
    pageCreationProgress.fail();
  }

  var buildRunnerProgress = Logger().progress(cyan('Running build runner ..'));

  try {
    await ShellUtils.runBuildRunner();
    buildRunnerProgress.complete();
  } catch (e) {
    buildRunnerProgress.fail();
    return;
  }
}
