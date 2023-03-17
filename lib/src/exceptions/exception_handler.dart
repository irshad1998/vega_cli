// ignore_for_file: avoid_print

import 'dart:io';

import 'package:vega_cli/src/exceptions/exception.dart';
import 'package:vega_cli/src/utils/log/logger.dart';

class ExceptionHandler {
  void handle(dynamic e) {
    if (e is CommandLineException) {
      Logger2.error(e.message!);
      if (e.codeSample!.isNotEmpty) {
        Logger2.info('Example', false, false);
        print(Logger2.codeBold(e.codeSample!));
      }
    } else if (e is FileSystemException) {
      if (e.osError!.errorCode == 2) {
        Logger2.error('File not found in %s');
        return;
      } else if (e.osError!.errorCode == 13) {
        Logger2.error('Access denied to %s');
        return;
      }
      _logException(e.message);
    } else {
      _logException(e.toString());
    }
    if (!Platform.isWindows) exit(0);
  }

  static void _logException(String msg) {
    Logger2.error('Unexpected error $msg');
  }
}
