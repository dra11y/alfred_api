import 'dart:collection';
import 'package:alfred_api/src/extensions/uri_extension.dart';
import 'package:alfred_api/src/types/library_node.dart';
import 'package:analyzer/dart/element/element.dart';

class LibraryTree {
  final Map<Uri, LibraryNode> _nodes = {};
  UnmodifiableMapView<Uri, LibraryNode> get nodes =>
      UnmodifiableMapView(_nodes);

  LibraryNode _findOrCreateNode(LibraryElement library) =>
      _nodes.putIfAbsent(library.source.uri, () => LibraryNode(library));

  void addLibrary(LibraryElement library) {
    final node = _findOrCreateNode(library);

    final linkedLibraries =
        (library.importedLibraries + library.exportedLibraries)
            .where((i) => i.source.uri.inSamePackage(library.source.uri));

    // Set children (libraries in same package that this library imports/exports)
    for (final linkedLibrary in linkedLibraries) {
      final child = _findOrCreateNode(linkedLibrary);
      node.addChild(child);
    }

    // // Set parents (libraries in same package that this library is imported/exported from)
    for (final potentialParent in _nodes.values) {
      final potentialLinked = potentialParent.library.importedLibraries +
          potentialParent.library.exportedLibraries;

      if (potentialLinked.contains(library)) {
        potentialParent.addChild(node);
      }
    }

    // if (node.parent == null && node.children.isEmpty && nodes.length > 1) {
    //   print('LibraryNode is orphaned: $node');
    // }

    print('node: $node\nallMetadata: ${node.allMetadata}');

    // print('LibraryNode keys: ${nodes.keys}');
  }

  String tree() => _nodes.values
      .where((n) => n.parent == null)
      .map((n) => n.tree())
      .join('\n');
}
