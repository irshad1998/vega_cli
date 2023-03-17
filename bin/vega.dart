import 'package:dcli/dcli.dart';
import 'package:vega_cli/src/core/vega_gen.dart';
import 'package:vega_cli/src/exceptions/exception_handler.dart';

void main(List<String> arguments) async {
  var time = Stopwatch();
  time.start();
  final command = VegaCli(arguments).findCommand();
  if (arguments.contains('--debug')) {
    if (command.validate()) {
      await command.execute();
    }
  } else {
    try {
      if (command.validate()) {
        await command.execute();
      }
    } on Exception catch (e) {
      ExceptionHandler().handle(e);
    }
  }
}
