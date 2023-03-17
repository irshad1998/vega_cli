class CommandLineException implements Exception {
  String? message;
  String? codeSample;
  CommandLineException(this.message, {this.codeSample = ''});
}
