import 'dart:io';
import 'package:collection/collection.dart';
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
      } else if (e is FormatterException) {
        message = e.message(color: true);
      }
      final lineNumberedCode = unformattedCode
          .split('\n')
          .mapIndexed(
              (index, line) => '${(index + 1).toString().padLeft(3)}. $line')
          .join('\n');
      print(
          '\nERROR: ${e.runtimeType}: $message\n\n\nGENERATED:\n\n$lineNumberedCode');
      exit(1);
    }
  }
}
