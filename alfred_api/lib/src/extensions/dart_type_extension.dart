import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:source_gen/source_gen.dart';

extension DartTypeExtension on DartType {
  static final _stringType = TypeChecker.fromRuntime(String);

  TypeSystem get typeSystem => element!.library!.typeSystem;

  bool isList() => flatNonNull().isDartCoreList;
  bool isMap() => flatNonNull().isDartCoreMap;

  DartType? get listType {
    final t = flatNonNull();
    return t is ParameterizedType && t.isDartCoreList
        ? t.typeArguments.first
        : null;
  }

  DartType? get jsonMapType {
    final t = flatNonNull();
    return t is ParameterizedType &&
            t.isDartCoreMap &&
            _stringType.isExactlyType(t.typeArguments.first)
        ? t.typeArguments.last
        : null;
  }

  DartType flatNonNull() => flatten().nonNull();
  DartType nonNull() => typeSystem.promoteToNonNull(this);
  DartType flatten() => typeSystem.flatten(this);
}
