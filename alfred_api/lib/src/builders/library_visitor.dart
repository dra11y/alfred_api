import 'package:alfred_api_annotation/alfred_api_annotation.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:source_gen/source_gen.dart';

class LibraryVisitor extends RecursiveElementVisitor<void> {
  final Map<DartType, Uri> typeImports = {};
  final List<ClassElement> endpoints = [];

  LibraryVisitor();

  static const endpointType = TypeChecker.fromRuntime(Endpoint);

  @override
  void visitClassElement(ClassElement element) {
    if (endpointType.isSuperOf(element)) {
      endpoints.add(element);
    }
  }

  @override
  void visitLibraryImportElement(LibraryImportElement element) {
    final library = element.importedLibrary;
    if (library == null || library.isInSdk) {
      return;
    }
    final instanceElements = library.exportNamespace.definedNames.values
        .whereType<InstanceElement>();
    for (final instance in instanceElements) {
      typeImports[instance.thisType] = library.source.uri;
    }
    super.visitLibraryImportElement(element);
  }
}
