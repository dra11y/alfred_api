import 'package:build/build.dart';
import 'package:path/path.dart' as path;

import '../output_file.dart';

extension BuildStepExtension on BuildStep {
  AssetId get assetId => AssetId(
        inputId.package,
        path.join('lib', outputFile),
      );
}
