import 'package:vega_cli/src/commands/cli/create/page/create_page.dart';
import 'package:vega_cli/src/commands/cli/create/project/create_project.dart';
import 'package:vega_cli/src/commands/cli/help/help_command.dart';
import 'package:vega_cli/src/commands/interfaces/command_interface.dart';

final List<Command> commands = [
  CommandParent('create', [
    CreateProjectCommand(),
    CreatePageCommand(),
  ], [
    '-c'
  ]),
  HelpCommand(),
];

// Command parant class
class CommandParent extends Command {
  final String _name;
  final List<String> _alias;
  final List<Command> _childrens;
  CommandParent(this._name, this._childrens, [this._alias = const []]);

  @override
  String get commandName => _name;
  @override
  List<Command> get childrens => _childrens;
  @override
  List<String> get alias => _alias;

  @override
  Future<void> execute() async {}

  @override
  String get hint => '';

  @override
  bool validate() => true;

  @override
  String get codeSample => '';

  @override
  int get maxParameters => 0;
}
