// ignore_for_file: avoid_print

import 'package:ansicolor/ansicolor.dart';

class Logger2 {
  static final AnsiPen _penError = AnsiPen()..rgb(r: 255, g: 0, b: 0);
  static final AnsiPen _penSuccess = AnsiPen()..green(bold: true);
  static final AnsiPen _penInfo = AnsiPen()..cyan(bold: true);

  static final AnsiPen code = AnsiPen()
    ..black(bold: false, bg: true)
    ..white();

  static final AnsiPen codeBold = AnsiPen()..gray(level: 1);

//  static var _errorWrapper = '_' * 40;
  static void error(String msg) {
    const sep = '\n';
    // to check: ⚠ ❌✖✕
    msg = '\n❌  ${_penError(msg.trim())} ❌';
    msg = msg + sep;
    print(msg);
  }

  static void success(dynamic msg) {
    print('✅  ${_penSuccess(msg.toString())}');
  }

  static void info(String msg, [bool trim = false, bool newLines = true]) {
    final sep = newLines ? '\n' : '';
    if (trim) msg = msg.trim();
    msg = _penInfo(msg);
    msg = sep + msg.toString() + sep;
    print(msg);
  }
}
