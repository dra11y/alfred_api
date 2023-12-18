import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

import '../types/types.dart';

extension ElementExtension on Element {
  FileAndLine? getFileAndLine() {
    final elementDeclaration = getElementDeclaration();
    final node = elementDeclaration?.node;
    if (node == null) {
      return null;
    }

    final compilationUnit = node.root as CompilationUnit;
    final uri = elementDeclaration?.parsedUnit?.uri;
    final location = compilationUnit.lineInfo.getLocation(node.offset);
    return FileAndLine(uri, location);
  }

  Future<ElementDeclarationResult?> getResolvedDeclaration() async {
    final resolvedLib = await session!.getResolvedLibraryByElement(library!);
    return resolvedLib is ResolvedLibraryResult
        ? resolvedLib.getElementDeclaration(this)
        : null;
  }

  ElementDeclarationResult? getElementDeclaration() {
    final parsedLib = session!.getParsedLibraryByElement(library!);
    return parsedLib is ParsedLibraryResult
        ? parsedLib.getElementDeclaration(this)
        : null;
  }
}
