// GENERATED CODE - DO NOT MODIFY BY HAND
//
// GENERATED SERVER CODE
//
// Import this file into the file where you initialize Alfred:
// final app = Alfred();
//
// Then add:
// app.addEndpointRoutes();

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alfred/alfred.dart' as _i1;
import 'package:example_models/example_models.dart' as _i3;
import 'package:example_server/src/endpoints/members_endpoint.dart' as _i2;

extension AlfredEndpointRoutesExtension on _i1.Alfred {
  void addEndpointRoutes() {
    typeHandlers.addAll([_i2.memberTypeHandler]);

    /// GET members.all
    get('members', (req, res) async {
      final endpoint = _i2.MembersEndpoint(req, res);
      return await endpoint.all();
    });

    /// GET members.find
    get('members/:id', (req, res) async {
      final endpoint = _i2.MembersEndpoint(req, res);
      final String id = req.params['id'];
      final String lastName = req.params['lastName'];
      final String? firstName = req.params['firstName'];
      return await endpoint.find(id, lastName: lastName, firstName: firstName);
    });

    /// PUT members.update
    put('members/:id', (req, res) async {
      final endpoint = _i2.MembersEndpoint(req, res);
      final _i3.Member member = req.params['member'];
      final String? name = req.params['name'];
      return await endpoint.update(member, name);
    });

    /// POST members.create
    post('members', (req, res) async {
      final endpoint = _i2.MembersEndpoint(req, res);
      final _i3.Member member = req.params['member'];
      return await endpoint.create(member);
    });
  }
}
