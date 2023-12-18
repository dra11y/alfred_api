import 'package:analyzer/dart/element/type.dart';
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
    type: ${type.getDisplayString(withNullability: true)},
    flatType: ${flatType.getDisplayString(withNullability: true)},
    import: $import,
  )''';
}
