import 'package:vega_cli/src/commands/cli/help/help_command.dart';
import 'package:vega_cli/src/commands/commands.dart';
import 'package:vega_cli/src/commands/interfaces/command_interface.dart';
import 'package:vega_cli/src/utils/log/logger.dart';

class VegaCli {
  final List<String> _arguments;

  VegaCli(this._arguments) {
    _instance = this;
  }

  static VegaCli? _instance;
  static VegaCli? get to => _instance;

  static List<String> get arguments => to!._arguments;

  Command findCommand() => _findCommand(0, commands);

  Command _findCommand(int currentIndex, List<Command> commands) {
    try {
      final currentArgument = arguments[currentIndex].split(':').first;

      var command = commands.firstWhere(
          (command) =>
              command.commandName == currentArgument ||
              command.alias.contains(currentArgument),
          orElse: () => ErrorCommand('Command not found'));
      if (command.childrens.isNotEmpty) {
        if (command is CommandParent) {
          command = _findCommand(++currentIndex, command.childrens);
        } else {
          var childrenCommand = _findCommand(++currentIndex, command.childrens);
          if (childrenCommand is! ErrorCommand) {
            command = childrenCommand;
          }
        }
      }
      return command;
      // ignore: avoid_catching_errors
    } on RangeError catch (_) {
      return HelpCommand();
    } on Exception catch (_) {
      rethrow;
    }
  }
}

class ErrorCommand extends Command {
  @override
  String get commandName => 'onerror';
  String error;
  ErrorCommand(this.error);
  @override
  Future<void> execute() async {
    Logger2.error(error);
    Logger2.info('Run `vega help` to view available commands', false, false);
  }

  @override
  String get hint => 'Print on error';

  @override
  String get codeSample => '';

  @override
  int get maxParameters => 0;

  @override
  bool validate() => true;
}

class NotFoundComannd extends Command {
  @override
  String get commandName => 'Command not found!';

  @override
  Future<void> execute() async {}

  @override
  String get hint => 'Command not found!';

  @override
  String get codeSample => '';

  @override
  int get maxParameters => 0;

  @override
  bool validate() => true;
}
