import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

class ResolvedType {
  final DartType type;
  final Uri privateImport;
  final Uri publicImport;
  final TypeChecker typeChecker;

  ResolvedType({
    required this.type,
    required this.privateImport,
    required this.publicImport,
    required this.typeChecker,
  });
}
