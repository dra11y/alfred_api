import 'dart:collection';

import 'package:alfred/alfred.dart';
import 'package:alfred_api/src/builders/endpoint_info.dart';
import 'package:alfred_api/src/builders/type_handler_type.dart';
import 'package:alfred_api_annotation/alfred_api_annotation.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:source_gen/source_gen.dart';

import '../types/types.dart';
import 'endpoint_visitor.dart';
import 'method_info.dart';

class LibraryVisitor extends RecursiveElementVisitor<void> {
  UnmodifiableMapView<DartType, Uri> get typeImports =>
      UnmodifiableMapView(_typeImports);
  UnmodifiableListView<ClassElement> get endpointClasses =>
      UnmodifiableListView(_endpointClasses);
  UnmodifiableSetView<TypeHandlerType> get typeHandlerTypes =>
      UnmodifiableSetView(_typeHandlerTypes);

  UnmodifiableListView<EndpointInfo> get endpoints =>
      UnmodifiableListView(_endpoints);

  final Map<DartType, Uri> _typeImports = {};
  final List<ClassElement> _endpointClasses = [];
  final Set<TypeHandlerType> _typeHandlerTypes = {};
  late final List<EndpointInfo> _endpoints;

  final Map<PathRecord, (EndpointInfo, MethodInfo)> _pathRecords = {};

  LibraryVisitor();

  static const _endpointType = TypeChecker.fromRuntime(Endpoint);
  static const _typeHandlerType = TypeChecker.fromRuntime(TypeHandler);

  void addTypeHandlerTypes(Set<TypeHandlerType> types) {
    for (final type in types) {
      if (!_typeHandlerTypes.add(type)) {
        throw Exception('Duplicate TypeHandlerType: $type');
      }
    }
  }

  void visitCollected() {
    _endpoints = [];
    for (final element in _endpointClasses) {
      _visitEndpoint(element);
    }
  }

  void _visitEndpoint(ClassElement element) {
    final endpointVisitor =
        EndpointVisitor(element, typeImports, typeHandlerTypes);
    element.visitChildren(endpointVisitor);
    final info = EndpointInfo(element, endpointVisitor.methods);
    _checkMethodsUnique(info);
    _endpoints.add(info);
  }

  void _checkMethodsUnique(EndpointInfo info) {
    for (final m2 in info.methods) {
      if (_pathRecords.keys.contains(m2.pathRecord)) {
        final (e1, m1) = _pathRecords[m2.pathRecord]!;
        throw Exception(
            'Duplicate path: ${m2.pathRecord} at ${info.endpoint.name}#${m2.name}; already defined at ${e1.name}#${m1.name}');
      }
      _pathRecords[m2.pathRecord] = (info, m2);
    }
  }

  @override
  void visitClassElement(ClassElement element) {
    if (_endpointType.isSuperOf(element)) {
      _endpointClasses.add(element);
    }
  }

  @override
  void visitLibraryImportElement(LibraryImportElement element) {
    final library = element.importedLibrary;
    if (library == null || library.isInSdk) {
      return;
    }

    final exports = library.exportNamespace.definedNames.values
        .whereType<InstanceElement>()
        .where(
            (element) => element.library == element.thisType.element?.library)
        .map((element) => element.thisType);

    for (final export in exports) {
      _typeImports[export] = library.source.uri;
    }
    super.visitLibraryImportElement(element);
  }

  @override
  void visitPropertyAccessorElement(PropertyAccessorElement element) {
    final returnType = element.returnType;
    if (_typeHandlerType.isExactlyType(returnType) &&
        returnType is ParameterizedType) {
      print('add TypeHandler for type: ${returnType.typeArguments.first}');
      _typeHandlerTypes
          .add(TypeHandlerType.custom(returnType.typeArguments.first));
    }
    super.visitPropertyAccessorElement(element);
  }
}
