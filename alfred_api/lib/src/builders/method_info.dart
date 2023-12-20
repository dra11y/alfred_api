import 'package:alfred/alfred.dart';
import 'package:alfred_api/src/builders/param_info.dart';
import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart' hide Method;

class MethodInfo {
  MethodInfo({
    required this.element,
    required this.import,
    required this.method,
    required this.path,
    required this.positionalParams,
    required this.namedParams,
    required this.returnType,
    required this.hasTypeHandler,
  });

  final MethodElement element;
  final Uri import;
  final Method method;
  final String path;
  final List<ParamInfo> positionalParams;
  final List<ParamInfo> namedParams;
  Map<String, Expression> get namedParamsMap => {
        for (final param in namedParams) param.name: param.ref,
      };
  List<ParamInfo> get allParams => positionalParams + namedParams;
  final TypeInfo returnType;
  final bool hasTypeHandler;

  late final pathRecord = PathRecord(path, method);
  late final String name = element.name;

  @override
  String toString() => '''MethodInfo(
    name: ${name.color(Pens.yellow)},
    method: ${method.name.toUpperCase().color(Pens.yellow)},
    path: ${path.color(Pens.yellow)},
    element: $element,
    positionalParams: $positionalParams,
    namedParams: $namedParams,
    hasTypeHandler: ${hasTypeHandler.color()},
    returnType: $returnType,
  )'''
      .color(Pens.cyan);
}
