import 'package:alfred_api/src/builders/type_info.dart';
import 'package:code_builder/src/specs/reference.dart';

class ParamInfo extends TypeInfo {
  const ParamInfo({
    required this.name,
    required super.type,
    required super.flatType,
    required super.import,
  });

  final String name;

  Reference get ref => Reference(name);

  @override
  String toString() => '''ParamInfo(
    name: $name,
    type: ${type.getDisplayString(withNullability: true)},
    flatType: ${flatType.getDisplayString(withNullability: true)},
    import: $import,
  )''';
}
