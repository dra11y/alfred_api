import 'dart:async';

import 'package:alfred/alfred.dart' as alfred;
import 'package:alfred_endpoints/alfred_endpoints.dart';
import 'package:alfred_endpoints_generator/src/types/comment.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

import '../extensions/extensions.dart';
import '../output_file.dart';
import '../types/types.dart';

// https://github.com/dart-lang/build/blob/master/docs/writing_an_aggregate_builder.md

class EndpointsBuilder extends Builder {
  static final _allDartFiles = Glob('lib/**/*.dart');

  static const endpointChecker = TypeChecker.fromRuntime(Endpoint);
  late final Set<String> imports = {};

  static const _alfredEndpointsUrl =
      'package:alfred_endpoints/alfred_endpoints.dart';
  static const _alfredUrl = 'package:alfred/alfred.dart';

  static const _endpointVar = 'endpoint';

  static final _dartfmt = DartFormatter(experimentFlags: ['tall-style']);

  final _emitter = DartEmitter.scoped(useNullSafetySyntax: true);

  @override
  Future<void> build(BuildStep buildStep) async {
    final List<ClassElement> libraryClasses = [];
    await for (final input in buildStep.findAssets(_allDartFiles)) {
      final library = await buildStep.resolver.libraryFor(input);
      final classesInLibrary = LibraryReader(library).classes;

      libraryClasses.addAll(classesInLibrary);
    }

    final pathRecords = <PathRecord>[];
    final endpoints = libraryClasses.where((c) => endpointChecker.isSuperOf(c));

    if (endpoints.isEmpty) {
      return;
    }

    final List<Code> codes = [];

    for (final endpoint in endpoints) {
      _generateEndpoint(endpoint, codes, pathRecords);
    }

    final addEndpointRoutes = Method((b) => b
      ..name = 'addEndpointRoutes'
      ..returns = refer('void')
      ..body =
          Code(codes.map((e) => e.accept(_emitter).toString()).join('\n')));

    final ext = Extension((b) => b
      ..name = 'AlfredEndpointRoutesExtension'
      ..methods.add(addEndpointRoutes)
      ..on = refer('Alfred', _alfredUrl));

    final library = Library((b) => b.body.addAll([ext]));

    final generated = library.accept(_emitter);

    print(generated.toString());

    final formatted = _dartfmt.format(generated.toString());

    buildStep.writeAsString(buildStep.assetId, formatted);
  }

  @override
  final buildExtensions = const {
    r'$lib$': [outputFile],
  };

  void _generateEndpoint(ClassElement endpointElement, List<Code> codes,
      List<PathRecord> pathRecords) {
    final endpointValues = AnnotationValues.ofElement(endpointElement);
    for (final instanceMethod in endpointElement.methods) {
      codes.addAll(_generateMethodCall(
          endpointElement, instanceMethod, endpointValues, pathRecords));
    }
  }

  List<Code> _generateMethodCall(
      ClassElement endpointElement,
      MethodElement instanceMethod,
      AnnotationValues endpointValues,
      List<PathRecord> pathRecords) {
    final name = instanceMethod.name;
    final importUrl = endpointElement.location!.components.first;
    final endpointClassName =
        endpointElement.thisType.getDisplayString(withNullability: false);

    final methodValues = AnnotationValues.ofElement(instanceMethod,
        defaultMethod: endpointValues.method);

    final path = '/${[
      endpointValues.path,
      methodValues.path
    ].whereType<String>().join('/').normalizePath}';
    final method = methodValues.method;
    final PathRecord pathRecord = (path, method);
    if (pathRecords.contains(pathRecord)) {
      throw Exception(
          'Duplicate path+method: ${pathRecord.$2.name.toUpperCase()} ${pathRecord.$1}');
    }
    final params = path
        .split('/')
        .where((p) => p.startsWith(':'))
        .map((p) => p.split(':').firstWhere((e) => e.isNotEmpty))
        .toList();
    if (params.toSet().length != params.length) {
      throw Exception('Duplicate parameters: $params}');
    }
    pathRecords.add(pathRecord);

    final routeMethod = Method((b) => b
      ..requiredParameters.addAll([
        Parameter((b) => b..name = 'req'),
        Parameter((b) => b..name = 'res'),
      ]));

    refer(endpointClassName, importUrl)
        .call([...routeMethod.requiredParameters.map((p) => refer(p.name))]);

    final List<Code> codes = [];

    final endpointDeclaration = declareFinal(_endpointVar)
        .assign(refer(endpointClassName, importUrl).call(
          routeMethod.requiredParameters.map((p) => refer(p.name)),
        ))
        .statement;

    codes.add(endpointDeclaration);

    codes.add(refer('$_endpointVar.$name').call([]).statement);

    final code = Code(codes.map((c) => c.accept(_emitter)).join(''));

    return [
      Comment.doc('${method.name.toUpperCase()} $endpointClassName.$name').code,
      refer(method.name).call([
        literalString(path),
        (routeMethod.toBuilder()..body = code).build().closure
      ]).statement,
    ];
  }
}
