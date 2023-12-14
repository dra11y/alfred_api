import 'package:build/build.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';

extension BuildStepExtension on BuildStep {
  AssetId get clientAssetId => AssetId(
        inputId.package,
        path.join('lib', clientOutputFile),
      );
  AssetId get serverAssetId => AssetId(
        inputId.package,
        path.join('lib', serverOutputFile),
      );
}
