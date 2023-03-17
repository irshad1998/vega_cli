import 'package:dcli/dcli.dart';
import 'package:vega_cli/src/commands/cli/init/init_bloc.dart';
import 'package:vega_cli/src/commands/cli/init/init_provider.dart';
import 'package:vega_cli/src/commands/interfaces/command_interface.dart';
import 'package:vega_cli/src/common/menu.dart';
import 'package:vega_cli/src/utils/log/logger.dart';

class InitCommand extends Command {
  @override
  String get commandName => 'init';

  @override
  String? get hint => 'Generate the chosen structure on an existing project:';

  @override
  bool validate() {
    super.validate();
    return true;
  }

  @override
  String? get codeSample => Logger2.code('get init');

  @override
  int get maxParameters => 0;

  @override
  Future<void> execute() async {
    if (containsArg('--provider')) {
      await createProviderProject();
    } else if (containsArg('--bloc')) {
      await initBloc();
    } else {
      final menu = Menu(
        [
          cyan('Provider'),
          'Bloc',
        ],
        title: cyan('Select state management'),
      );
      final result = menu.choose();
      result.index == 0 ? await createProviderProject() : await initBloc();
    }

    return;
  }
}
