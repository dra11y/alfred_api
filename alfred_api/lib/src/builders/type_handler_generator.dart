import 'package:alfred_api/src/builders/type_handler_info.dart';
import 'package:code_builder/code_builder.dart';
import 'package:logging/logging.dart';

final log = Logger.root;

class TypeHandlerGenerator {
  final Set<TypeHandlerInfo> typeHandlers;

  const TypeHandlerGenerator(this.typeHandlers);

  Block generate() {
    return Block.of([
      refer('typeHandlers')
          .property('addAll')([
            literalList([
              for (final handler in typeHandlers) handler.ref,
            ])
          ])
          .statement,
    ]);
  }
}
