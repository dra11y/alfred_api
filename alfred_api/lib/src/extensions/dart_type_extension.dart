import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:alfred_api/src/types/resolved_type.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';

extension DartTypeExtension on DartType {
  List<DartType> get parameters {
    final params = let((type) =>
        type is ParameterizedType ? type.typeArguments : <DartType>[]);
    // print('DartType: $this, params: $params');
    return params;
  }

  bool get isNullable => nullabilitySuffix == NullabilitySuffix.question;
  String get nullableSuffix => isNullable ? '?' : '';

  TypeReference getRef(
    List<ResolvedType> resolvedTypes, {
    bool withNullableSuffix = true,
  }) {
    final reference = TypeReference((t) => t
      ..symbol = element!.name! + (withNullableSuffix ? nullableSuffix : '')
      ..isNullable = isNullable
      ..url = resolvedTypes
          .firstWhereOrNull(
              (r) => r.privateImport == element!.librarySource!.uri)
          ?.publicImport
          .toString()
      ..types.addAll(parameters
          .map((p) => p.getRef(resolvedTypes, withNullableSuffix: false))));
    // print('reference: ${reference.expression.code}');
    return reference;
  }

  TypeSystem get typeSystem => element!.library!.typeSystem;

  bool isList() => flatNonNull().isDartCoreList;
  bool isMap() => flatNonNull().isDartCoreMap;

  DartType flatNonNull() => flatten().nonNull();
  DartType nonNull() => typeSystem.promoteToNonNull(this);
  DartType flatten() => typeSystem.flatten(this);
}
