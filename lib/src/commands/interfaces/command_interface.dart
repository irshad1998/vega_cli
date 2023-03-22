import 'package:vega_cli/src/commands/args_mixin.dart';
import 'package:vega_cli/src/core/vega_gen.dart';
import 'package:vega_cli/src/exceptions/exception.dart';
import 'package:vega_cli/src/utils/log/logger.dart';

abstract class Command with ArgsMixin {
  Command({String? package}) {
    while (
        ((args.contains(commandName) || args.contains('$commandName:$name'))) &&
            args.isNotEmpty) {
      args.removeAt(0);
    }
    if (args.isNotEmpty && args.first == name) {
      args.removeAt(0);
    }
  }
  int get maxParameters;
  String? get codeSample;
  String get commandName;
  List<String> get alias => [];
  List<String> get acceptedFlags => [];
  String? get hint;

  bool validate() {
    if (VegaCli.arguments.contains(commandName) ||
        VegaCli.arguments.contains('$commandName:$name')) {
      var flagsNotAceppts = flags;
      flagsNotAceppts.removeWhere((element) => acceptedFlags.contains(element));
      if (flagsNotAceppts.isNotEmpty) {
        Logger2.info('The $flagsNotAceppts is not necessary');
      }

      if (args.length > maxParameters) {
        List pars = args.skip(maxParameters).toList();
        throw CommandLineException('the $pars parameter is not necessary',
            codeSample: codeSample);
      }
    }
    return true;
  }

  Future<void> execute();
  List<Command> get childrens => [];
}
