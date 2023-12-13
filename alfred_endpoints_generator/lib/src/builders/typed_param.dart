import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

class TypedParam {
  final ParameterElement param;

  TypedParam(this.param);

  late final String name = param.name;
  late final String type = param.type.getDisplayString(withNullability: true);
  late final String? uri = param.type.element?.librarySource?.uri.toString();
  late final Reference ref = refer(name);
  late final Reference typeRef = refer(type, uri);
}
