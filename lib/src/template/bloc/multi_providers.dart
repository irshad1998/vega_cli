import 'package:vega_cli/src/template/interface/template.dart';
import 'package:vega_cli/src/utils/pubspec/pubspec_utils.dart';

class BlocMultiBlocProviderListTemplate extends Template {
  BlocMultiBlocProviderListTemplate()
      : super('lib/app/common/multi_bloc_provider_list.dart', overwrite: true);

  String get _multiProviderListTemplate => '''
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:${PubspecUtils.projectName}/app/modules/home/bloc/home_bloc.dart';

  /// DO NOT EDIT THIS LINE. This is code generated via package:vega_cli/vega_cli.dart
  /// Do not remove trailing comma in [providerList]
  /// Changes in structure of this file will cause error running command `vega create page`
  
 class MultiBlocList extends StatelessWidget {
  const MultiBlocList({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
      ],
      child: child,
    );
  }
}


  ''';

  @override
  String get content => _multiProviderListTemplate;
}
