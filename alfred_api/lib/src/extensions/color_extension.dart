import 'package:ansicolor/ansicolor.dart';

final RegExp ansiPattern = RegExp(r'\x1B\[[^m]*m.*?\x1B\[0m', dotAll: true);

extension ColorExtension on String {
  String color(AnsiPen pen) {
    final multiline = contains('\n');
    final nested = replaceAll('\n', '\n\t')
        .replaceAllMapped(ansiPattern, (match) => match.group(0)! + pen.down);
    return '${pen.down}${multiline ? '\n\t' : ''}$nested${pen.up}';
  }
}
