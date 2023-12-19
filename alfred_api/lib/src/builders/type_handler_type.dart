import 'package:analyzer/dart/element/type.dart';
import 'package:equatable/equatable.dart';
import 'package:source_gen/source_gen.dart';

class TypeHandlerType extends Equatable {
  final DartType type;
  final bool isDefault;
  TypeChecker get typeChecker => TypeChecker.fromStatic(type);
  bool isAssignableFromType(DartType fromType) =>
      typeChecker.isAssignableFromType(fromType);

  const TypeHandlerType(this.type, this.isDefault);

  TypeHandlerType.asDefault(this.type) : isDefault = true;
  TypeHandlerType.custom(this.type) : isDefault = false;

  @override
  List<Object?> get props => [type, isDefault];

  @override
  String toString() => '''TypeHandlerType(
    type: $type,
    isDefault: $isDefault,
  )''';
}
