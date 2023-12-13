import 'package:alfred/alfred.dart' as alfred;
import 'package:alfred_endpoints/alfred_endpoints.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../extensions/extensions.dart';

enum Annotations {
  method(TypeChecker.fromRuntime(alfred.Method)),
  path(TypeChecker.fromRuntime(Path));

  final TypeChecker typeChecker;

  const Annotations(this.typeChecker);

  static Annotations from(
      Element element, ElementAnnotation annotation, DartObject? value) {
    final type = value?.type;
    if (type == null) {
      throw UnimplementedError(
          'Cannot determine type of annotation: $annotation at ${element.getFileAndLine()}');
    }
    for (final value in values) {
      if (value.typeChecker.isExactlyType(type)) {
        return value;
      }
    }
    final location = element.getFileAndLine();
    throw UnimplementedError(
        'Unhandled annotation type: $type, from library: ${type.element?.library}, at: $location');
  }
}
