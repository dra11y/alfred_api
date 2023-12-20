import 'package:alfred/alfred.dart' as alfred;
import 'package:alfred_api/src/extensions/analysis_error_extension.dart';
import 'package:alfred_api_annotation/alfred_api_annotation.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/exception/exception.dart';
import 'package:source_gen/source_gen.dart';

import '../extensions/extensions.dart';

enum Annotations {
  method(TypeChecker.fromRuntime(alfred.Method)),
  path(TypeChecker.fromRuntime(Path)),
  version(TypeChecker.fromRuntime(Version));

  final TypeChecker typeChecker;

  const Annotations(this.typeChecker);

  static Annotations from(
      Element element, ElementAnnotation annotation, DartObject? value) {
    final type = value?.type;

    if (type == null) {
      if (annotation.constantEvaluationErrors != null) {
        final sb = StringBuffer();
        for (final error in annotation.constantEvaluationErrors!) {
          sb.writeln(error.message);
          sb.writeln(error.errorCode);
          sb.writeAll([
            '\tfile: ${error.fileAndLine.uri}',
            '\tlocation: ${error.fileAndLine.location}',
            '\tsource:\n${error.getLinesAroundOffset()}\n',
          ], '\n');
          for (final message in error.contextMessages) {
            sb.writeln(message.messageText(includeUrl: true));
          }
        }
        throw AnalysisException(sb.toString());
      }
      throw UnimplementedError(
          'Annotation not implemented: $annotation at ${element.getFileAndLine()}');
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
