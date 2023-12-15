import 'package:alfred_api/src/builders/method_info.dart';
import 'package:analyzer/dart/element/element.dart';

class EndpointInfo {
  const EndpointInfo(this.endpoint, this.methods);

  final ClassElement endpoint;
  final List<MethodInfo> methods;

  @override
  String toString() => '''EndpointInfo(
    endpoint: $endpoint,
    methods: $methods
  )''';
}
