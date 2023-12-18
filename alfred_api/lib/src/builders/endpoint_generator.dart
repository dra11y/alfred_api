import 'package:alfred_api/src/builders/method_info.dart';
import 'package:code_builder/code_builder.dart';
import 'package:logging/logging.dart';

import '../types/comment.dart';
import 'endpoint_info.dart';

final log = Logger.root;

class EndpointGenerator {
  final EndpointInfo endpoint;

  const EndpointGenerator(this.endpoint);

  static const String _req = 'req';
  static const String _res = 'res';
  static const String _endpoint = 'endpoint';

  Block generate() {
    return Block.of(
      endpoint.methods.map((m) => _generateMethodCall(m)),
    );
  }

  Block _generateMethodCall(MethodInfo methodInfo) {
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

    final constructor = Reference(endpoint.name, endpoint.import.toString());

    // for (final param in methodInfo.params) {
    //   print('param: ${param.name}, uri: ${param.import}');
    // }
    // final app = Alfred();
    // for (final type in HttpRouteParam.paramTypes) {
    //   log.info('paramType: ${type.parse}');
    // }
    // final List<TypeHandler> typeHandlers = app.typeHandlers;
    // for (final handler in typeHandlers) {
    //   log.info('typeHandler: $handler');
    // }

    return Block.of([
      Comment.doc(
              '${methodInfo.method.name.toUpperCase()} ${endpoint.name}.${methodInfo.name}')
          .code,
      refer(methodInfo.method.name).call([
        literalString(methodInfo.path),
        (routeMethod.toBuilder()
              ..body = Block.of([
                declareFinal(_endpoint)
                    .assign(constructor.call(routeParams))
                    .statement,
                for (final param in methodInfo.params)
                  declareFinal(param.name, type: param.typeRef)
                      .assign(refer("$_req.params['${param.name}']"))
                      .statement,
                refer('$_endpoint.${methodInfo.name}').awaited.call([
                  for (final param in methodInfo.params) param.ref,
                ]).statement,
              ]))
            .build()
            .closure
      ]).statement,
    ]);
  }
}
