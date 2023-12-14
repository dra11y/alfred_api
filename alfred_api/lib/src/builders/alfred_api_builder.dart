import 'dart:async';
import 'dart:io';

import 'package:alfred_api/src/types/comment.dart';
import 'package:path/path.dart' as path;
import 'package:alfred_api_annotation/alfred_api_annotation.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';

import 'package:pubspec2/pubspec2.dart';
import 'package:source_gen/source_gen.dart';

import '../extensions/extensions.dart';
import '../constants.dart';
import '../types/types.dart';
import 'class_finder.dart';
import 'code_formatter.dart';
import 'endpoint_generator.dart';

class AlfredApiBuilder implements Builder {
  final BuilderOptions options;

  AlfredApiBuilder(this.options);

  static const endpointChecker = TypeChecker.fromRuntime(Endpoint);
  static const _alfredUrl = 'package:alfred/alfred.dart';
  static const _generatedComment = 'GENERATED CODE - DO NOT MODIFY BY HAND';

  final _emitter = DartEmitter.scoped(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final _endpointClassFinder =
      ClassFinder(filter: (c) => endpointChecker.isSuperOf(c));

  @override
  Future<void> build(BuildStep buildStep) async {
    List<ClassElement> endpointClasses =
        await _endpointClassFinder.find(buildStep);

    if (endpointClasses.isEmpty) {
      return;
    }

    final pathRecords = <PathRecord>[];

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
                endpointClasses
                    .map((c) => EndpointGenerator(c, pathRecords).generate()),
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

    await copyAssets(buildStep);
  }

  final _trailingCommaRegex = RegExp(r',\s*\)', multiLine: true);

  String removeTrailingCommas(String source) =>
      source.replaceAll(_trailingCommaRegex, ')');

  Future<void> copyAssets(BuildStep buildStep) async {
    final serverPackage = buildStep.inputId.package;
    final clientPackage =
        serverPackage.replaceFirst(RegExp(r'_server$'), '_client');

    final serverFile = File(buildStep.serverAssetId.cachePath).absolute;
    final serverPath =
        path.canonicalize(path.join(buildStep.inputId.path, '..', '..'));
    final clientFile = File(buildStep.clientAssetId.cachePath).absolute;
    final clientPath =
        path.canonicalize(path.join(serverPath, '..', clientPackage));

    final pubSpec = await PubSpec.load(clientPath);
    if (pubSpec.name != clientPackage) {
      throw Exception(
          'Expected client package name: $clientPackage, but got ${pubSpec.name} instead.');
    }
    final serverFilePath =
        path.join(serverPath, 'lib', path.basename(serverFile.path));
    await serverFile.copy(serverFilePath);
    final clientFilePath =
        path.join(clientPath, 'lib', path.basename(clientFile.path));
    await clientFile.copy(clientFilePath);
  }

  @override
  final buildExtensions = {
    r'$lib$': [
      serverOutputFile,
      clientOutputFile,
    ],
  };
}
