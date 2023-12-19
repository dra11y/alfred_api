import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:code_builder/code_builder.dart';

class TypeInfo {
  const TypeInfo({
    required this.type,
    required this.flatType,
    required this.import,
  });

  final DartType type;
  final DartType flatType;
  final Uri? import;

  Reference get typeRef => Reference(
      type.getDisplayString(withNullability: true), import?.toString());

  @override
  String toString() => '''TypeInfo(
    flatType: ${flatType.getDisplayString(withNullability: true).color(AnsiPen()..yellow())},
    type: ${type.getDisplayString(withNullability: true)},
    import: $import,
  )'''
      .color(AnsiPen()..magenta());
}
