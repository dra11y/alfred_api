import 'dart:async';

import 'package:alfred_endpoints/alfred_endpoints.dart';
import 'package:alfred_endpoints_generator/src/builders/class_finder.dart';
import 'package:alfred_endpoints_generator/src/builders/code_formatter.dart';
import 'package:alfred_endpoints_generator/src/builders/endpoint_generator.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:source_gen/source_gen.dart';

import '../extensions/extensions.dart';
import '../output_file.dart';
import '../types/types.dart';

class EndpointsBuilder extends Builder {
  static const endpointChecker = TypeChecker.fromRuntime(Endpoint);
  static const _alfredUrl = 'package:alfred/alfred.dart';

  final _emitter = DartEmitter.scoped(useNullSafetySyntax: true);

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

    final generated = Library((b) => b
      ..comments.add('GENERATED CODE - DO NOT MODIFY BY HAND')
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
      )).accept(_emitter);

    final formatted = CodeFormatter(generated.toString()).format();

    buildStep.writeAsString(buildStep.assetId, formatted);
  }

  @override
  final buildExtensions = const {
    r'$lib$': [outputFile],
  };
}
