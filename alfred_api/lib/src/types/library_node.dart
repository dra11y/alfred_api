import 'package:analyzer/dart/element/element.dart';

class LibraryNode {
  final LibraryElement library;
  LibraryNode? parent;
  final Set<LibraryNode> children = {};

  LibraryNode(this.library);

  void addChild(LibraryNode child) {
    children.add(child);
    child.parent = this;
  }

  LibraryNode get root => parent?.root ?? this;

  List<LibraryNode> get path =>
      [this, if (parent != null) ...parent!.path].reversed.toList();

  List<ElementAnnotation> get allMetadata =>
      path.expand((node) => node.library.metadata).toList();

  Uri get uri => library.source.uri;

  @override
  int get hashCode => uri.hashCode;

  @override
  bool operator ==(Object other) => other is LibraryNode && other.uri == uri;

  @override
  String toString() => uri.toString();

  String tree([int level = 0]) {
    var result = '${'    ' * level}$this\n';
    for (var child in children) {
      result += child.tree(level + 1);
    }
    return result;
  }
}
