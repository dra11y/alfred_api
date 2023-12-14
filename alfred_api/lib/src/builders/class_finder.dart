import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

class ClassFinder {
  final String glob;
  final bool Function(ClassElement)? filter;

  const ClassFinder({
    this.glob = 'lib/**/*.dart',
    this.filter,
  });

  Future<List<ClassElement>> find(BuildStep buildStep) async {
    final List<ClassElement> libraryClasses = [];

    await for (final input in buildStep.findAssets(Glob(glob))) {
      final library = await buildStep.resolver.libraryFor(input);
      final classesInLibrary = LibraryReader(library).classes;
      libraryClasses.addAll(classesInLibrary);
    }

    return filter != null
        ? libraryClasses.where((c) => filter!(c)).toList()
        : libraryClasses;
  }
}
