import 'package:alfred/alfred.dart' as alfred;
import 'package:analyzer/dart/element/element.dart';

import '../types/types.dart';

class AnnotationValues {
  final alfred.Method method;
  final String path;

  AnnotationValues._(this.method, this.path);

  factory AnnotationValues.ofElement(Element element,
      {alfred.Method? defaultMethod}) {
    alfred.Method method = defaultMethod ?? alfred.Method.get;
    String path = '';
    for (final annotation in element.metadata) {
      final value = annotation.computeConstantValue();
      final type = Annotations.from(element, annotation, value);
      switch (type) {
        case Annotations.method:
          final index = value!.getField('index')!.toIntValue()!;
          method = alfred.Method.values[index];
        case Annotations.path:
          path = value!.getField('path')!.toStringValue()!.normalizePath;
      }
    }
    return AnnotationValues._(method, path);
  }
}
