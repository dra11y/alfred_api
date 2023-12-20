import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../types/comment.dart';
import '../types/types.dart';
import 'old_method_info.dart';
import 'typed_param.dart';

class OldEndpointGenerator {
  OldEndpointGenerator(this.endpointClass, this.pathRecords) {
    endpointValues = AnnotationValues.ofElement(endpointClass);
    importedLibraries = endpointClass.library.libraryImports
        .map((i) => i.importedLibrary)
        .whereType<LibraryElement>()
        .toList();
  }

  final ClassElement endpointClass;
  final List<PathRecord> pathRecords;
  late final AnnotationValues endpointValues;
  late final List<LibraryElement> importedLibraries;

  static const String _endpoint = 'endpoint';
  static const String _req = 'req';
  static const String _res = 'res';

  Block generate() {
    return Block.of(
      endpointClass.methods.map((m) => _generateMethodCall(m)),
    );
  }

  Block _generateMethodCall(MethodElement instanceMethod) {
    final methodInfo = OldMethodInfo(
      endpointClass: endpointClass,
      instanceMethod: instanceMethod,
      endpointValues: endpointValues,
    );

    if (pathRecords.contains(methodInfo.pathRecord)) {
      throw Exception(
          'Duplicate path+method: ${methodInfo.pathRecord.path.toUpperCase()} ${methodInfo.pathRecord.method}');
    }
    pathRecords.add(methodInfo.pathRecord);

    if (methodInfo.params.toSet().length != methodInfo.params.length) {
      throw Exception('Duplicate parameters: ${methodInfo.params}}');
    }

    final routeMethod = Method((b) => b
      ..modifier = MethodModifier.async
      ..requiredParameters.addAll([
        Parameter((b) => b..name = _req),
        Parameter((b) => b..name = _res),
      ]));

    final routeParams =
        routeMethod.requiredParameters.map((p) => refer(p.name));

    final constructor =
        Reference(methodInfo.endpointClassName, methodInfo.importUrl);

    final pathParams =
        instanceMethod.parameters.map((p) => TypedParam(p, importedLibraries));

    for (final param in pathParams) {
      print('param: ${param.name}, uri: ${param.uri}');
    }

    return Block.of([
      Comment.doc(
              '${methodInfo.method.name.toUpperCase()} ${methodInfo.endpointClassName}.${methodInfo.name}')
          .code,
      refer(methodInfo.method.name)([
        literalString(methodInfo.path),
        (routeMethod.toBuilder()
              ..body = Block.of([
                declareFinal(_endpoint)
                    .assign(constructor(routeParams))
                    .statement,
                for (final param in pathParams)
                  declareFinal(param.name, type: param.ref)
                      .assign(refer("$_req.params['${param.name}']"))
                      .statement,
                refer('$_endpoint.${methodInfo.name}').awaited([
                  for (final param in pathParams) param.ref,
                ]).statement,
              ]))
            .build()
            .closure
      ]).statement,
    ]);
  }
}
