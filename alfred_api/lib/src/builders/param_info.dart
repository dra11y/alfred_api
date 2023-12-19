import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/color_extension.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:code_builder/code_builder.dart';

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
    name: ${name.color(AnsiPen()..yellow())},
    type: ${type.getDisplayString(withNullability: true)},
    flatType: ${flatType.getDisplayString(withNullability: true)},
    import: $import,
  )'''
      .color(AnsiPen()..magenta());
}
