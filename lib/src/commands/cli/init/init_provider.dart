import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mason_logger/mason_logger.dart' hide cyan;
import 'package:vega_cli/src/commands/cli/create/page/create_page.dart';
import 'package:vega_cli/src/core/structure.dart';
import 'package:vega_cli/src/functions/create/create_list_dir.dart';
import 'package:vega_cli/src/functions/write/write_flavor.dart';
import 'package:vega_cli/src/template/provider/app_config.dart';
import 'package:vega_cli/src/template/provider/app_pages.dart';
import 'package:vega_cli/src/template/provider/const.dart';
import 'package:vega_cli/src/template/provider/develop_main.dart';
import 'package:vega_cli/src/template/provider/extensions.dart';
import 'package:vega_cli/src/template/provider/flavor_config.dart';
import 'package:vega_cli/src/template/provider/functions.dart';
import 'package:vega_cli/src/template/provider/helpers.dart';
import 'package:vega_cli/src/template/provider/launch_json.dart';
import 'package:vega_cli/src/template/provider/main.dart';
import 'package:vega_cli/src/template/provider/main_production.dart';
import 'package:vega_cli/src/template/provider/main_staging.dart';
import 'package:vega_cli/src/template/provider/multi_provider_list.dart';
import 'package:vega_cli/src/template/provider/provider_helper.dart';
import 'package:vega_cli/src/template/provider/service_config.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';
import 'package:vega_cli/src/utils/shell/shell_utils.dart';

Future<void> createProviderProject() async {
  var initialDirs = [
    /// ASSETS FOLDERS
    Directory(Structure.replaceAsExpected(path: 'assets/fonts/')),
    Directory(Structure.replaceAsExpected(path: 'assets/images/')),
    Directory(Structure.replaceAsExpected(path: 'assets/icons/')),
    Directory(Structure.replaceAsExpected(path: 'assets/docs/')),

    /// ADDITIONAL FOLDERS
    Directory(Structure.replaceAsExpected(path: 'lib/app/common/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/common/configs/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/common/palette/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/data/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/modules/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/routes/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/services/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/utils/')),
    Directory(Structure.replaceAsExpected(path: 'lib/app/widgets/')),
  ];
  createListDirectory(initialDirs);
  var fileCreationProgress = Logger().progress(cyan('Generating files ..'));

  try {
    /// files => lib/app/common
    await ProviderExtensionTemplate().create();
    await ProviderFunctionsTemplate().create();
    await ProviderHelpersTemplate().create();
    await ProviderMultiProviderListTemplate().create();

    /// files => lib/app/common/configs
    await ProviderAppConfigTemplate().create();
    await ProviderFlavorConfigTemplate().create();

    /// files => lib/app/routes
    await ProviderAppRoutesTemplate().create();
    await ProviderAppPagesTemplate().create();

    /// files => lib/utils
    await ProviderHelperClassTemplate().create();
    await ProviderConstTemplate().create();
    await ProviderServiceConfigTemplate().create();

    /// files => main files
    await ProviderMainTemplate().create();
    await ProviderMainDevelopTemplate().create();
    await ProviderMainProductionTemplate().create();
    await ProviderMainStagingTemplate().create();

    File('assets/docs/launch.json').writeAsStringSync(launchJsonData);
    writeAndroidFlavor();

    fileCreationProgress.complete();
  } catch (_) {
    fileCreationProgress.fail();
    return;
  }
  var pageCreationProgress =
      Logger().progress(cyan('Generating module home ..'));
  try {
    /// create page
    await Future.wait([CreatePageCommand().execute()]);
    pageCreationProgress.complete();
  } catch (_) {
    pageCreationProgress.fail();
  }

  var pubAddProgress = Logger().progress(cyan('Adding dependencies ..'));
  try {
    await PubspecUtils.addDependencies('provider',
        isDev: false, runPubGet: false);
    pubAddProgress.complete();
  } catch (e) {
    pubAddProgress.complete();
  }
  var pubGetProgress = Logger().progress(cyan('Running `flutter pub get` ..'));
  try {
    await ShellUtils.pubGet();
    pubGetProgress.complete();
  } catch (_) {
    pubGetProgress.fail();
  }
  print(cyan(fi));
}
