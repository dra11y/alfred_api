extension UriExtension on Uri {
  String get package => pathSegments.first;
  bool inSamePackage(Uri other) =>
      other.scheme == scheme && other.package == package;
}
