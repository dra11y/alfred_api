import 'dart:async';
import 'dart:io';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec2/pubspec2.dart';

class AssetCopier {
  final BuildStep buildStep;

  AssetCopier(this.buildStep);

  Future<void> copyAssets() async {
    final serverPackage = buildStep.inputId.package;
    final clientPackage =
        serverPackage.replaceFirst(RegExp(r'_server$'), '_client');

    final serverFile = File(buildStep.serverAssetId.cachePath).absolute;
    final serverPath =
        path.canonicalize(path.join(buildStep.inputId.path, '..', '..'));
    final clientFile = File(buildStep.clientAssetId.cachePath).absolute;
    final clientPath =
        path.canonicalize(path.join(serverPath, '..', clientPackage));

    final pubSpec = await PubSpec.load(clientPath);
    if (pubSpec.name != clientPackage) {
      throw Exception(
          'Expected client package name: $clientPackage, but got ${pubSpec.name} instead.');
    }
    final serverFilePath =
        path.join(serverPath, 'lib', path.basename(serverFile.path));
    await serverFile.copy(serverFilePath);
    final clientFilePath =
        path.join(clientPath, 'lib', path.basename(clientFile.path));
    await clientFile.copy(clientFilePath);
  }
}
