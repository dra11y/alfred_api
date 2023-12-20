import 'dart:math';

import 'package:analyzer/source/line_info.dart';
import 'package:ansicolor/ansicolor.dart';

final RegExp ansiPattern = RegExp(r'\x1B\[[^m]*m.*?\x1B\[0m', dotAll: true);

class Pens {
  static final black = AnsiPen()..black();
  static final red = AnsiPen()..red();
  static final green = AnsiPen()..green();
  static final yellow = AnsiPen()..yellow();
  static final blue = AnsiPen()..blue();
  static final magenta = AnsiPen()..magenta();
  static final cyan = AnsiPen()..cyan();
  static final white = AnsiPen()..white();
}

extension StringExtension on String {
  List<String> get lines => split('\n');

  String getLinesAroundOffset(int offset, int length,
      {int before = 2, int after = 2, bool arrow = true}) {
    final info = lineInfo;
    final start = info.getLocation(offset);
    final end = info.getLocation(offset + length);
    final startLine = max(0, start.lineNumber - before);
    final endLine = min(info.lineCount, end.lineNumber + after);
    final newStart = info.getOffsetOfLine(startLine);
    final newEnd = info.getOffsetOfLine(endLine);
    final text = substring(newStart, newEnd);
    if (!arrow) {
      return text;
    }
    final lines = text.lines;
    lines.insert(before, '${'=' * (max(0, start.columnNumber - 1))}^');
    return lines.join('\n');
  }

  String color(AnsiPen pen) {
    final multiline = contains('\n');
    final nested = replaceAll('\n', '\n\t')
        .replaceAllMapped(ansiPattern, (match) => match.group(0)! + pen.down);
    return '${pen.down}${multiline ? '\n\t' : ''}$nested${pen.up}';
  }

  LineInfo get lineInfo => LineInfo([
        0,
        ...'\n'.allMatches(this).map((m) => m.end),
      ]);
}
