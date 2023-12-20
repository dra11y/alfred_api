import 'dart:math';

import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:alfred_api/src/types/types.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/line_info.dart';

extension AnalysisErrorExtension on AnalysisError {
  String getLinesAroundOffset(
      {int before = 2, int after = 2, bool arrow = true}) {
    return source.contents.data.getLinesAroundOffset(offset, length,
        before: before, after: after, arrow: arrow);
  }

  LineInfo get lineInfo => source.contents.data.lineInfo;

  FileAndLine get fileAndLine =>
      FileAndLine(source.uri, lineInfo.getLocation(offset));
}
