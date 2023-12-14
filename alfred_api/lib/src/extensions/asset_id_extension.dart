import 'package:build/build.dart';

extension AssetIdExtension on AssetId {
  String get cachePath => '.dart_tool/build/generated/$package/$path';
}
