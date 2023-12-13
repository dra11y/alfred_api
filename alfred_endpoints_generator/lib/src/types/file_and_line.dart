import 'package:analyzer/source/line_info.dart';

class FileAndLine {
  final Uri? uri;
  final CharacterLocation location;

  const FileAndLine(this.uri, this.location);

  @override
  String toString() => [
        uri?.path,
        '${location.lineNumber}:${location.columnNumber}'
      ].whereType<String>().join(' ');
}
