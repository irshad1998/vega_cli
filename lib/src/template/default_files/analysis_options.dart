import 'package:vega_cli/src/template/interface/template.dart';

/// [Sample] file from analysis_options.yaml file creation.
class AnalysisOptionsSample extends Template {
  String include;
  AnalysisOptionsSample(
      {String path = 'analysis_options.yaml', this.include = ''})
      : super(path, overwrite: true);

  @override
  String get content => '''$include
linter:
  rules:
    
''';
}
