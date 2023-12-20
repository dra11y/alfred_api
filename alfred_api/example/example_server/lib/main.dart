import 'package:alfred/alfred.dart';

import 'routes.g.dart';

void main() async {
  final app = Alfred();

  app.addEndpointRoutes();
  app.post('/post-route', (req, res) async {
    final body = await req.body; //JSON body
    body != null; //true
  });

  await app.listen(); //Listening on port 3000
}
