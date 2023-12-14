import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';

class TypedParam {
  final ParameterElement param;
  final List<LibraryElement> importedLibraries;

  TypedParam(this.param, this.importedLibraries);

  late final String name = param.name;
  late final String type = param.type.getDisplayString(withNullability: true);
  late final String? uri = param.type.element != null
      ? importedLibraries
          .firstWhereOrNull((import) => import
              .exportNamespace.definedNames.values
              .contains(param.type.element!.declaration))
          ?.identifier
      : null;
  late final Reference ref = refer(name);
  late final Reference typeRef = refer(type, uri);
}
