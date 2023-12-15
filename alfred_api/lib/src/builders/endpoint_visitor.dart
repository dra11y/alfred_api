import 'package:alfred_api/src/builders/method_info.dart';
import 'package:alfred_api/src/builders/param_info.dart';
import 'package:alfred_api/src/builders/type_info.dart';
import 'package:alfred_api/src/extensions/dart_type_extension.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';

class EndpointVisitor extends SimpleElementVisitor<void> {
  final ClassElement endpoint;
  final Map<DartType, Uri> typeImports;
  final List<MethodInfo> methods = [];

  EndpointVisitor(this.endpoint, this.typeImports);

  @override
  void visitMethodElement(MethodElement element) {
    final annotationValues = AnnotationValues.ofElement(element,
        defaults: AnnotationValues.ofElement(endpoint));
    print('annotationValues: $annotationValues');
    final info = MethodInfo(
      element: element,
      method: annotationValues.method,
      path: annotationValues.path,
      params: element.parameters
          .map(
            (p) => ParamInfo(
              name: p.name,
              type: p.type,
              flatType: p.type.flatten(),
              import: typeImports[p.type],
            ),
          )
          .toList(),
      returnType: TypeInfo(
        type: element.returnType,
        flatType: element.returnType.flatten(),
        import: typeImports[element.returnType],
      ),
    );
    print(info);
    methods.add(info);
    print('visitMethodElement: $element');
  }
}
