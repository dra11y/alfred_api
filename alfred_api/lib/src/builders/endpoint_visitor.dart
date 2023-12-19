import 'dart:collection';

import 'package:alfred_api/src/builders/method_info.dart';
import 'package:alfred_api/src/builders/param_info.dart';
import 'package:alfred_api/src/builders/type_handler_type.dart';
import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/dart_type_extension.dart';
import 'package:alfred_api/src/extensions/let_extension.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';

class EndpointVisitor extends SimpleElementVisitor<void> {
  final ClassElement endpoint;
  final UnmodifiableMapView<DartType, Uri> typeImports;
  final UnmodifiableSetView<TypeHandlerType> typeHandlerTypes;

  UnmodifiableListView<MethodInfo> get methods =>
      UnmodifiableListView(_methods);

  final List<MethodInfo> _methods = [];

  EndpointVisitor(this.endpoint, this.typeImports, this.typeHandlerTypes);

  @override
  void visitMethodElement(MethodElement element) {
    final annotationValues = AnnotationValues.ofElement(element,
        defaults: AnnotationValues.ofElement(endpoint));

    final flatReturnType = element.returnType.flatNonNull();
    final hasTypeHandler =
        typeHandlerTypes.any((t) => t.isAssignableFromType(flatReturnType));

    final methodInfo = MethodInfo(
      element: element,
      import: element.librarySource.uri,
      method: annotationValues.method,
      path: annotationValues.path,
      params: element.parameters
          .map(
            (param) => param.type.flatten().let((flatParamType) => ParamInfo(
                  name: param.name,
                  type: param.type,
                  flatType: flatParamType,
                  import: typeImports[flatParamType],
                )),
          )
          .toList(),
      returnType: TypeInfo(
        type: element.returnType,
        flatType: flatReturnType,
        import: typeImports[flatReturnType],
      ),
      hasTypeHandler: hasTypeHandler,
    );

    _methods.add(methodInfo);
  }
}
