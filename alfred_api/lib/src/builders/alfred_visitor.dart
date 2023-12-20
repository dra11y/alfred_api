import 'dart:async';
import 'dart:collection';
import 'dart:mirrors';
import 'package:alfred/alfred.dart';
import 'package:alfred_api/src/builders/type_handler_type.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class AlfredVisitor {
  AlfredVisitor();

  final _typeHandlerType = TypeChecker.fromRuntime(TypeHandler);

  UnmodifiableSetView<TypeHandlerType> get typeHandlerTypes =>
      UnmodifiableSetView(_typeHandlerTypes);
  final Set<TypeHandlerType> _typeHandlerTypes = {};

  bool get visited => _visited;
  bool _visited = false;

  Future<void> visitAlfredOnce(LibraryElement library, BuildStep buildStep,
      [void Function(AlfredVisitor)? completion]) async {
    if (_visited) {
      return;
    }
    _visited = true;
    final sourceUri = reflectType(Alfred).location!.sourceUri;
    final alfredLibrary =
        await library.session.getLibraryByUri(sourceUri.toString());
    if (alfredLibrary is! LibraryElementResult) {
      return;
    }
    for (final import in alfredLibrary.element.libraryImports) {
      await _visitImport(import);
    }
    completion?.call(this);
  }

  Future<void> _visitImport(LibraryImportElement import) async {
    final dcu = import.importedLibrary?.definingCompilationUnit;
    if (dcu == null) {
      return;
    }
    for (final accessor in dcu.accessors
        .where((a) => _typeHandlerType.isExactlyType(a.returnType))) {
      await _visitAccessor(accessor);
    }
  }

  Future<void> _visitAccessor(PropertyAccessorElement accessor) async {
    final decl = await accessor.getResolvedDeclaration();
    final body = decl?.node.childEntities
        .whereType<FunctionExpression>()
        .firstOrNull
        ?.childEntities
        .whereType<ExpressionFunctionBody>()
        .firstOrNull;
    final staticType = body?.expression.staticType;
    if (staticType is ParameterizedType) {
      _typeHandlerTypes
          .add(TypeHandlerType.asDefault(staticType.typeArguments.first));
    }
  }
}
