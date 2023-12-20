import 'package:alfred_api/src/builders/method_info.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

class EndpointInfo {
  EndpointInfo(this.element, this.methods);

  final ClassElement element;
  final List<MethodInfo> methods;

  late final Uri? import =
      element.location?.components.firstOrNull?.let((s) => Uri.parse(s));

  late final String serverClassName = element.name;
  late final String clientClassName =
      '${serverClassName.replaceFirst('Endpoint', '')}Client';

  late final String clientGetterName = serverClassName
      .replaceFirst(RegExp(r'endpoint', caseSensitive: false), '')
      .toLowerCase();

  late final Reference serverConstructor =
      Reference(serverClassName, import.toString());

  late final Reference clientConstructor = Reference(clientClassName);

  @override
  String toString() => '''EndpointInfo(
    name: ${clientGetterName.color(Pens.yellow)},
    element: $element,
    import: $import,
    methods: $methods
  )'''
      .color(Pens.green);
}
