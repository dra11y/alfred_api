import 'dart:collection';

import 'package:alfred_api/src/builders/method_info.dart';
import 'package:alfred_api/src/builders/param_info.dart';
import 'package:alfred_api/src/builders/type_handler_type.dart';
import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/dart_type_extension.dart';
import 'package:alfred_api/src/extensions/let_extension.dart';
import 'package:alfred_api/src/types/resolved_type.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:code_builder/code_builder.dart';

class EndpointVisitor extends SimpleElementVisitor<void> {
  final ClassElement endpoint;
  final UnmodifiableListView<ResolvedType> resolvedTypes;
  final UnmodifiableSetView<TypeHandlerType> typeHandlerTypes;

  UnmodifiableListView<MethodInfo> get methods =>
      UnmodifiableListView(_methods);

  final List<MethodInfo> _methods = [];

  EndpointVisitor(this.endpoint, this.resolvedTypes, this.typeHandlerTypes);

  @override
  void visitMethodElement(MethodElement element) {
    final annotationValues = AnnotationValues.ofElement(element,
        defaults: AnnotationValues.ofElement(endpoint));

    List<ParamInfo> makeParams(Iterable<ParameterElement> parameters) =>
        parameters
            .map(
              (param) => param.type.flatten().let((flatParamType) => ParamInfo(
                    name: param.name,
                    type: param.type,
                    ref: refer(param.name),
                    typeRef: param.type.getRef(resolvedTypes),
                  )),
            )
            .toList();

    final methodInfo = MethodInfo(
      element: element,
      import: element.librarySource.uri,
      method: annotationValues.method,
      path: annotationValues.path,
      positionalParams:
          makeParams(element.parameters.where((p) => p.isPositional)),
      namedParams: makeParams(element.parameters.where((p) => p.isNamed)),
      returnType: TypeInfo(
        type: element.returnType,
        typeRef: element.returnType.getRef(resolvedTypes),
      ),
      hasTypeHandler: typeHandlerTypes
          .any((t) => t.isAssignableFromType(element.returnType.flatNonNull())),
    );

    _methods.add(methodInfo);
  }
}
