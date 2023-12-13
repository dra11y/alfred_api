import 'package:alfred/alfred.dart';

abstract class Endpoint {
  const Endpoint(this.req, this.res);

  final HttpRequest req;
  final HttpResponse res;
}
