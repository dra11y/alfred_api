import 'package:alfred_api/src/builders/library_visitor.dart';
import 'package:alfred_api/src/builders/method_info.dart';
import 'package:alfred_api/src/builders/param_info.dart';
import 'package:alfred_api/src/builders/type_handler_type.dart';
import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/dart_type_extension.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:collection/collection.dart';

class EndpointVisitor extends SimpleElementVisitor<void> {
  final ClassElement endpoint;
  final Map<DartType, Uri> typeImports;
  final Set<TypeHandlerType> typeHandlerTypes;

  final List<MethodInfo> methods = [];

  EndpointVisitor(this.endpoint, this.typeImports, this.typeHandlerTypes);

  @override
  void visitMethodElement(MethodElement element) {
    final annotationValues = AnnotationValues.ofElement(element,
        defaults: AnnotationValues.ofElement(endpoint));

    final flatType = element.returnType.flatNonNull;
    final typeHandlerType = typeHandlerTypes
        .firstWhereOrNull((tht) => tht.isAssignableFromType(flatType));

    final methodInfo = MethodInfo(
      element: element,
      import: element.librarySource.uri,
      method: annotationValues.method,
      path: annotationValues.path,
      params: element.parameters
          .map(
            (p) => ParamInfo(
              name: p.name,
              type: p.type,
              flatType: p.type.flat,
              import: typeImports[p.type.flat],
            ),
          )
          .toList(),
      returnType: TypeInfo(
        type: element.returnType,
        flatType: flatType,
        import: typeImports[flatType],
      ),
      typeHandlerType: typeHandlerType,
    );
    methods.add(methodInfo);
  }
}
