import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

class TypeInfo {
  TypeInfo({
    required this.type,
    required this.typeRef,
  });

  final DartType type;
  late final DartType flatType = type.flatten();
  Reference get ref => typeRef;
  final TypeReference typeRef;

  String get name => type.getDisplayString(withNullability: true);

  MethodModifier? get modifier =>
      (type.isDartAsyncFuture || type.isDartAsyncFutureOr)
          ? MethodModifier.async
          : type.isDartAsyncStream
              ? MethodModifier.asyncStar
              : null;

  @override
  String toString() => '''TypeInfo(
    flatType: ${flatType.getDisplayString(withNullability: true).color(Pens.yellow)},
    type: ${type.getDisplayString(withNullability: true)},
    ref: typeRef,
    typeRef: ${typeRef.expression.code}, url: ${typeRef.url},
  )'''
      .color(Pens.red);
}
