import 'package:analyzer/dart/element/type.dart';

class TypeInfo {
  const TypeInfo({
    required this.type,
    required this.flatType,
    required this.import,
  });

  final DartType type;
  final DartType flatType;
  final Uri? import;

  @override
  String toString() => '''TypeInfo(
    type: ${type.getDisplayString(withNullability: true)},
    flatType: ${flatType.getDisplayString(withNullability: true)},
    import: $import,
  )''';
}
