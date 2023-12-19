import 'package:alfred_api/src/builders/method_info.dart';
import 'package:alfred_api/src/extensions/extensions.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:ansicolor/ansicolor.dart';

class EndpointInfo {
  EndpointInfo(this.endpoint, this.methods);

  final ClassElement endpoint;
  final List<MethodInfo> methods;

  Uri? get import =>
      endpoint.location?.components.firstOrNull?.let((s) => Uri.parse(s));

  late final String name = endpoint.name
      .replaceFirst(RegExp(r'endpoint', caseSensitive: false), '')
      .toLowerCase();

  @override
  String toString() => '''EndpointInfo(
    endpoint: $endpoint,
    name: ${name.color(AnsiPen()..yellow())},
    methods: $methods
  )'''
      .color(AnsiPen()..green());
}
