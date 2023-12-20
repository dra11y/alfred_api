import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/string_extension.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:code_builder/code_builder.dart';

class ParamInfo extends TypeInfo {
  ParamInfo({
    required this.name,
    required super.type,
    required this.ref,
    required super.typeRef,
  });

  @override
  final String name;

  @override
  final Reference ref;

  @override
  String toString() => '''ParamInfo(
    name: ${name.color(Pens.yellow)},
    type: ${type.getDisplayString(withNullability: true)},
    flatType: ${flatType.getDisplayString(withNullability: true)},
    ref: ${ref.expression.code}, url: ${ref.url},
    typeRef: ${typeRef.expression.code}, url: ${typeRef.url},
  )'''
      .color(Pens.magenta);
}
