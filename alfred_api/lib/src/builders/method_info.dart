import 'package:alfred/alfred.dart';
import 'package:alfred_api/src/builders/param_info.dart';
import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';

class MethodInfo {
  MethodInfo({
    required this.element,
    required this.method,
    required this.path,
    required this.params,
    required this.returnType,
  });

  final MethodElement element;
  final Method method;
  final String path;
  final List<ParamInfo> params;
  final TypeInfo returnType;

  late final pathRecord = PathRecord(path, method);
  late final String name = element.name;

  @override
  String toString() => '''MethodInfo(
    element: ${element.name},
    method: ${method.name.toUpperCase()},
    path: $path,
    params: $params,
    returnType: $returnType,
  )''';
}
