import 'package:alfred/alfred.dart' as alfred;
import 'package:analyzer/dart/element/element.dart';

import '../types/types.dart';

class AnnotationValues {
  final alfred.Method method;
  final String path;

  const AnnotationValues._(this.method, this.path);

  factory AnnotationValues.ofElement(Element element,
      {AnnotationValues? defaults}) {
    alfred.Method method = defaults?.method ?? alfred.Method.get;
    String path = defaults?.path ?? '';
    for (final annotation in element.metadata) {
      final value = annotation.computeConstantValue();
      final type = Annotations.from(element, annotation, value);
      switch (type) {
        case Annotations.method:
          final index = value!.getField('index')!.toIntValue()!;
          method = alfred.Method.values[index];
        case Annotations.path:
          path = [
            defaults?.path,
            value!.getField('path')!.toStringValue(),
          ].whereType<String>().join('/').normalizePath;
      }
    }
    return AnnotationValues._(method, path);
  }

  @override
  String toString() => '''AnnotationValues(
    method: $method,
    path: $path
  )''';
}
