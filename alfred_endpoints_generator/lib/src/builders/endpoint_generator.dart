import 'package:alfred_endpoints_generator/src/builders/method_info.dart';
import 'package:alfred_endpoints_generator/src/builders/typed_param.dart';
import 'package:alfred_endpoints_generator/src/types/comment.dart';
import 'package:alfred_endpoints_generator/src/types/types.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

class EndpointGenerator {
  const EndpointGenerator(this.endpointClass, this.pathRecords);

  final ClassElement endpointClass;
  final List<PathRecord> pathRecords;

  static const String _endpointVar = 'endpoint';
  static const String _reqVar = 'req';
  static const String _resVar = 'res';

  Block generate() {
    final endpointValues = AnnotationValues.ofElement(endpointClass);
    return Block.of(
      endpointClass.methods.map((m) => _generateMethodCall(m, endpointValues)),
    );
  }

  Block _generateMethodCall(
      MethodElement instanceMethod, AnnotationValues endpointValues) {
    final methodInfo = MethodInfo(
      endpointClass: endpointClass,
      instanceMethod: instanceMethod,
      endpointValues: endpointValues,
    );

    if (pathRecords.contains(methodInfo.pathRecord)) {
      throw Exception(
          'Duplicate path+method: ${methodInfo.pathRecord.$2.name.toUpperCase()} ${methodInfo.pathRecord.$1}');
    }
    pathRecords.add(methodInfo.pathRecord);

    if (methodInfo.params.toSet().length != methodInfo.params.length) {
      throw Exception('Duplicate parameters: ${methodInfo.params}}');
    }

    final routeMethod = Method((b) => b
      ..requiredParameters.addAll([
        Parameter((b) => b..name = _reqVar),
        Parameter((b) => b..name = _resVar),
      ]));
    final routeParams =
        routeMethod.requiredParameters.map((p) => refer(p.name));

    final constructor =
        Reference(methodInfo.endpointClassName, methodInfo.importUrl);

    final pathParams = instanceMethod.parameters.map((p) => TypedParam(p));

    return Block.of([
      Comment.doc(
              '${methodInfo.method.name.toUpperCase()} ${methodInfo.endpointClassName}.${methodInfo.name}')
          .code,
      refer(methodInfo.method.name).call([
        literalString(methodInfo.path),
        (routeMethod.toBuilder()
              ..body = Block.of([
                declareFinal(_endpointVar)
                    .assign(constructor.call(routeParams))
                    .statement,
                for (final param in pathParams)
                  declareFinal(param.name, type: param.typeRef)
                      .assign(refer("$_reqVar.params['${param.name}']"))
                      .statement,
                refer('$_endpointVar.${methodInfo.name}').call([
                  for (final param in pathParams) param.ref,
                ]).statement,
              ]))
            .build()
            .closure
      ]).statement,
    ]);
  }
}
