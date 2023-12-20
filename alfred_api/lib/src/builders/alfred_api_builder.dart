import 'dart:async';

import 'package:alfred_api/src/builders/alfred_visitor.dart';
import 'package:alfred_api/src/builders/asset_copier.dart';
import 'package:alfred_api/src/builders/client_generator.dart';
import 'package:alfred_api/src/builders/library_visitor.dart';
import 'package:alfred_api/src/builders/type_handler_generator.dart';
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
  static const _addEndpointRoutes = 'addEndpointRoutes';
  static const _alfredExtensionName = 'AlfredEndpointRoutesExtension';

  final _serverEmitter = DartEmitter.scoped(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final _clientEmitter = DartEmitter.scoped(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  @override
  Future<void> build(BuildStep buildStep) async {
    final libraryVisitor = LibraryVisitor();
    final alfredVisitor = AlfredVisitor();

    await for (final input in buildStep.findAssets(Glob('**/*.dart'))) {
      final library = await buildStep.resolver.libraryFor(input);
      print('NEW LIBRARY: $library');
      print('library.enclosingElement: ${library.enclosingElement}');
      await alfredVisitor.visitAlfredOnce(library, buildStep, (visitor) {
        libraryVisitor.addTypeHandlerTypes(visitor.typeHandlerTypes);
      });

      /// Why isn't there an element.visitSelf?
      ///
      /// Calling: library.visitChildren(libraryVisitor);
      /// skips the library itself. Since we're using a recursive
      /// visitor, we need only visit the library itself.
      libraryVisitor.visitLibraryElement(library);
    }

    libraryVisitor.visitCollected();

    print('libraryVisitor.endpoints: ${libraryVisitor.endpoints}');
    print('libraryVisitor.typeHandlers: ${libraryVisitor.typeHandlers}');
    // print('libraryVisitor.resolvedTypes: ${libraryVisitor.resolvedTypes}');

    if (libraryVisitor.endpoints.isEmpty) {
      log.warning('No endpoints found!');
      return;
    }

    final serverGenerated = Library((b) => b
      ..comments.addAll([
        _generatedComment,
        '',
        'GENERATED SERVER CODE',
        '',
        'Import this file into the file where you initialize Alfred:',
        'final app = Alfred();',
        '',
        'Then add:',
        'app.$_addEndpointRoutes();',
      ])
      ..body.add(
        Extension((b) => b
          ..name = _alfredExtensionName
          ..on = refer('Alfred', _alfredUrl)
          ..methods.add(
            Method((b) => b
              ..name = _addEndpointRoutes
              ..returns = refer('void')
              ..body = Block.of([
                TypeHandlerGenerator(libraryVisitor.typeHandlers).generate(),
                ...libraryVisitor.endpoints
                    .map((e) => EndpointGenerator(e).generate()),
              ])),
          )),
      )).accept(_serverEmitter).toString();

    final clientGenerated = Library((b) => b
      ..comments.addAll([
        _generatedComment,
        '',
        'GENERATED CLIENT CODE',
        '',
      ])
      ..body.addAll(
        ClientGenerator(libraryVisitor.endpoints, libraryVisitor.resolvedTypes)
            .generateList(),
      )).accept(_clientEmitter).toString();

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
