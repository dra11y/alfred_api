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
    if (methodInfo.allParams.toSet().length != methodInfo.allParams.length) {
      throw Exception('Duplicate parameters: ${methodInfo.allParams}}');
    }

    final routeMethod = Method((b) => b
      ..modifier = MethodModifier.async
      ..requiredParameters.addAll([
        Parameter((b) => b..name = _req),
        Parameter((b) => b..name = _res),
      ]));

    final routeParams =
        routeMethod.requiredParameters.map((p) => refer(p.name));

    return Block.of([
      Comment.doc(
              '${methodInfo.method.name.toUpperCase()} ${endpoint.clientGetterName}.${methodInfo.name}')
          .code,
      refer(methodInfo.method.name)([
        literalString(methodInfo.path),
        (routeMethod.toBuilder()
              ..body = Block.of([
                declareFinal(_endpoint)
                    .assign(endpoint.serverConstructor(routeParams))
                    .statement,
                for (final param in methodInfo.allParams)
                  declareFinal(param.name, type: param.typeRef)
                      .assign(refer("$_req.params['${param.name}']"))
                      .statement,
                refer('$_endpoint.${methodInfo.name}')
                    .awaited
                    .call([
                      for (final param in methodInfo.positionalParams)
                        param.ref,
                    ], methodInfo.namedParamsMap)
                    .returned
                    .statement,
              ]))
            .build()
            .closure
      ]).statement,
    ]);
  }
}
