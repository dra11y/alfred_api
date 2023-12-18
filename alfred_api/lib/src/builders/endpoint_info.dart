import 'package:alfred_api/src/builders/method_info.dart';
import 'package:alfred_api/src/extensions/let_extension.dart';
import 'package:analyzer/dart/element/element.dart';

class EndpointInfo {
  EndpointInfo(this.endpoint, this.methods);

  final ClassElement endpoint;
  final List<MethodInfo> methods;

  Uri? get import =>
      endpoint.location?.components.firstOrNull?.let((s) => Uri.parse(s));

  late final String name = endpoint.name;

  @override
  String toString() => '''EndpointInfo(
    endpoint: $endpoint,
    methods: $methods
  )''';
}
