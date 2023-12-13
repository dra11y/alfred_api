// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example/src/members_endpoint.dart' as _i1;
import 'package:alfred/alfred.dart' as _i2;

extension AlfredEndpointRoutesExtension on _i2.Alfred {
  void addEndpointRoutes() {
    /// GET MembersEndpoint.all
    get('/members', (req, res) {
      final endpoint = _i1.MembersEndpoint(req, res);
      endpoint.all();
    });

    /// GET MembersEndpoint.find
    get('/members/:id', (req, res) {
      final endpoint = _i1.MembersEndpoint(req, res);
      endpoint.find();
    });

    /// PUT MembersEndpoint.update
    put('/members/:id', (req, res) {
      final endpoint = _i1.MembersEndpoint(req, res);
      endpoint.update();
    });

    /// POST MembersEndpoint.create
    post('/members', (req, res) {
      final endpoint = _i1.MembersEndpoint(req, res);
      endpoint.create();
    });
  }
}
