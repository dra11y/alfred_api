import 'package:alfred/alfred.dart';
import 'package:analyzer/dart/element/element.dart';

import '../types/types.dart';

class MethodInfo {
  final ClassElement endpointClass;
  final MethodElement instanceMethod;
  final AnnotationValues endpointValues;

  late final name = instanceMethod.name;
  late final importUrl = endpointClass.location!.components.first;
  late final endpointClassName =
      endpointClass.thisType.getDisplayString(withNullability: false);
  late final AnnotationValues methodValues = AnnotationValues.ofElement(
      instanceMethod,
      defaultMethod: endpointValues.method);
  late final path = '/${[
    endpointValues.path,
    methodValues.path
  ].whereType<String>().join('/').normalizePath}';
  late final method = methodValues.method;
  late final PathRecord pathRecord = (path, method);
  late final params = path
      .split('/')
      .where((p) => p.startsWith(':'))
      .map((p) => p.split(':').firstWhere((e) => e.isNotEmpty))
      .toList();

  MethodInfo({
    required this.endpointClass,
    required this.instanceMethod,
    required this.endpointValues,
  });
}