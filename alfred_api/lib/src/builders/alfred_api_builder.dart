import 'dart:async';

import 'package:alfred_api/src/builders/alfred_visitor.dart';
import 'package:alfred_api/src/builders/asset_copier.dart';
import 'package:alfred_api/src/builders/library_visitor.dart';
import 'package:alfred_api/src/types/comment.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:glob/glob.dart';
import 'package:logging/logging.dart';

import '../constants.dart';
import '../extensions/extensions.dart';
import 'code_formatter.dart';
import 'endpoint_generator.dart';

final log = Logger.root;

class AlfredApiBuilder implements Builder {
  final BuilderOptions options;

  AlfredApiBuilder(this.options);

  static const _alfredUrl = 'package:alfred/alfred.dart';
  static const _generatedComment = 'GENERATED CODE - DO NOT MODIFY BY HAND';

  final _emitter = DartEmitter.scoped(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  @override
  Future<void> build(BuildStep buildStep) async {
    final libraryVisitor = LibraryVisitor();
    final alfredVisitor = AlfredVisitor();

    await for (final input in buildStep.findAssets(Glob('lib/**/*.dart'))) {
      final library = await buildStep.resolver.libraryFor(input);
      await alfredVisitor.visitAlfredOnce(library, buildStep, (visitor) {
        libraryVisitor.addTypeHandlerTypes(visitor.typeHandlerTypes);
      });
      library.visitChildren(libraryVisitor);
    }

    libraryVisitor.visitCollected();

    print('libraryVisitor.endpoints:\n${libraryVisitor.endpoints}');

    if (libraryVisitor.endpoints.isEmpty) {
      log.warning('No endpoints found!');
      return;
    }

    final serverGenerated = Library((b) => b
      ..comments.add(_generatedComment)
      ..body.add(
        Extension((b) => b
          ..name = 'AlfredEndpointRoutesExtension'
          ..on = refer('Alfred', _alfredUrl)
          ..methods.add(
            Method((b) => b
              ..name = 'addEndpointRoutes'
              ..returns = refer('void')
              ..body = Block.of(
                libraryVisitor.endpoints
                    .map((e) => EndpointGenerator(e).generate()),
              )),
          )),
      )).accept(_emitter).toString();

    final clientGenerated = Library((b) => b
      ..comments.add(_generatedComment)
      ..body.add(
        Comment.doc('This is a test'),
      )).accept(_emitter).toString();

    final serverFormatted =
        CodeFormatter(removeTrailingCommas(serverGenerated)).format();
    final clientFormatted =
        CodeFormatter(removeTrailingCommas(clientGenerated)).format();

    await buildStep.writeAsString(buildStep.serverAssetId, serverFormatted);
    await buildStep.writeAsString(buildStep.clientAssetId, clientFormatted);

    await AssetCopier(buildStep).copyAssets();
  }

  final _trailingCommaRegex = RegExp(r',\s*\)', multiLine: true);

  String removeTrailingCommas(String source) =>
      source.replaceAll(_trailingCommaRegex, ')');

  @override
  final buildExtensions = {
    r'$lib$': [
      serverOutputFile,
      clientOutputFile,
    ],
  };
}
