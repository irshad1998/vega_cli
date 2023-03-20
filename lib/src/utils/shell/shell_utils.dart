import 'package:dcli/dcli.dart' hide run;
import 'package:mason_logger/mason_logger.dart' hide cyan;
import 'package:process_run/shell_run.dart';

class ShellUtils {
  static Future<void> pubGet() async {
    await run('flutter pub get', verbose: false);
  }

  static Future<void> activatedNullSafe() async {
    await pubGet();
    await run('dart migrate --apply-changes --skip-import-check',
        verbose: true);
  }

  static Future<void> flutterCreate(
    String path,
    String? org,
    String iosLang,
    String androidLang,
  ) async {
    Logger logger = Logger();

    var flutterCreateProgress =
        logger.progress(cyan('Creating flutter project'));

    try {
      await run(
          'flutter create --no-pub -i $iosLang -a $androidLang --org $org  $path',
          verbose: false);
      flutterCreateProgress.complete();
    } catch (e) {
      flutterCreateProgress.fail();
      return;
    }
  }
}

String fi = '''\n
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
||                  :: Created A Vega App ✨ ::                    ||
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n
  ''';
