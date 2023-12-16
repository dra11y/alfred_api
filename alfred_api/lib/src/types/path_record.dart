import 'package:alfred/alfred.dart';

class PathRecord {
  const PathRecord(this.path, this.method);

  final String path;
  final Method method;

  @override
  int get hashCode => Object.hash(path, method);

  @override
  bool operator ==(Object other) =>
      other is PathRecord && path == other.path && method == other.method;

  @override
  String toString() => '${method.name.toUpperCase()} $path';
}
