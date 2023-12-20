import 'package:alfred_api/src/builders/type_handler_type.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:equatable/equatable.dart';

class TypeHandlerInfo extends Equatable {
  final TypeHandlerType type;
  final PropertyAccessorElement element;

  late final String propertyName = element.name;
  late final Uri import = element.librarySource.uri;
  late final Reference ref = refer(propertyName, import.toString());

  TypeHandlerInfo({
    required this.type,
    required this.element,
  });

  @override
  List<Object?> get props => [type, element];

  @override
  String toString() => '''TypeHandlerInfo(
    type: ${type.type.toString().color(Pens.yellow)},
    propertyName: $propertyName,
    import: $import,
    element: $element,
  )'''
      .color(Pens.blue);
}
