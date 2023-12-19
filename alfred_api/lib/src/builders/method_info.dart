import 'package:alfred/alfred.dart';
import 'package:alfred_api/src/builders/param_info.dart';
import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/color_extension.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:ansicolor/ansicolor.dart';

class MethodInfo {
  MethodInfo({
    required this.element,
    required this.import,
    required this.method,
    required this.path,
    required this.params,
    required this.returnType,
    required this.hasTypeHandler,
  });

  final MethodElement element;
  final Uri import;
  final Method method;
  final String path;
  final List<ParamInfo> params;
  final TypeInfo returnType;
  final bool hasTypeHandler;

  late final pathRecord = PathRecord(path, method);
  late final String name = element.name;

  @override
  String toString() => '''MethodInfo(
    name: ${name.color(AnsiPen()..yellow())},
    path: ${path.color(AnsiPen()..yellow())},
    element: $element,
    method: ${method.name.toUpperCase()},
    params: $params,
    returnType: $returnType,
    hasTypeHandler: $hasTypeHandler,
  )'''
      .color(AnsiPen()..cyan());
}
