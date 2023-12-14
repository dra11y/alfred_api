import 'dart:io';
import 'package:dart_style/dart_style.dart';

class CodeFormatter {
  final String unformattedCode;

  const CodeFormatter(this.unformattedCode);

  // static final _dartfmt = DartFormatter(experimentFlags: ['tall-style']);
  static final _dartfmt = DartFormatter();

  String format() {
    try {
      return _dartfmt.format(unformattedCode);
    } catch (e) {
      String? message;
      if (e is UnimplementedError) {
        message = '${e.message}\n\n${e.stackTrace}';
      } else if (e is FormatException) {
        message = '${e.message}\n\noffset: ${e.offset}';
      }
      print(
          '\nERROR: ${e.runtimeType}: $message\n\n\nGENERATED:\n\n$unformattedCode');
      exit(1);
    }
  }
}
