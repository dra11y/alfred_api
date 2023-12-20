import 'package:alfred_api/src/builders/endpoint_info.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:alfred_api/src/types/resolved_type.dart';
import 'package:code_builder/code_builder.dart';

class ClientGenerator {
  ClientGenerator(this.endpoints, this.resolvedTypes);

  final List<ResolvedType> resolvedTypes;
  final List<EndpointInfo> endpoints;

  static const String _httpUri = 'package:http/http.dart';
  static const Reference _httpClientRef = Reference('Client', _httpUri);
  static const String _httpClientFieldName = 'httpClient';
  static const String _mainClientName = 'Client';

  List<Spec> generateList() {
    final List<Class> clientClasses = [];

    final httpClientParam = Parameter(
      (p) => p
        ..toThis = true
        ..name = _httpClientFieldName,
    );
    final httpClientField = Field(
      (f) => f
        ..name = _httpClientFieldName
        ..modifier = FieldModifier.final$
        ..type = _httpClientRef,
    );
    final httpClientConstructor = Constructor(
      (c) => c
        ..requiredParameters.addAll([
          httpClientParam,
        ]),
    );

    final mainClientBuilder = ClassBuilder()
      ..name = _mainClientName
      ..fields.addAll([
        httpClientField,
      ])
      ..constructors.add(httpClientConstructor)
      ..methods.addAll([
        // Method.returnsVoid(
        //   (m) => m
        //     ..name = 'testmethod'
        //     ..body = Block.of([
        //       //
        //     ]),
        // ),
      ]);

    for (final endpoint in endpoints) {
      mainClientBuilder.fields.add(
        Field((f) => f
          ..name = endpoint.clientGetterName
          ..type = refer(endpoint.clientClassName)
          ..late = true
          ..modifier = FieldModifier.final$
          ..assignment = refer(endpoint.clientClassName)
              .call([refer(httpClientParam.name)]).code),
      );

      clientClasses.add(Class((ec) => ec
        ..name = endpoint.clientClassName
        ..constructors.add(httpClientConstructor)
        ..fields.add(httpClientField)
        ..methods.addAll([
          for (final method in endpoint.methods)
            Method(
              (m) => m
                ..name = method.name
                ..returns = method.returnType.type.getRef(resolvedTypes)
                ..modifier = method.returnType.modifier
                ..body = Block.of([]),
            ),
        ])));
    }

    return [
      mainClientBuilder.build(),
      ...clientClasses,
    ];
  }
}
