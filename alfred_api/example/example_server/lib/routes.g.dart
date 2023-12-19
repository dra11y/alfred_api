// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alfred/alfred.dart' as _i1;
import 'package:example_models/example_models.dart' as _i3;
import 'package:example_server/src/members_endpoint.dart' as _i2;

extension AlfredEndpointRoutesExtension on _i1.Alfred {
  void addEndpointRoutes() {
    /// GET members.all
    get('members', (req, res) async {
      final endpoint = _i2.members(req, res);
      await endpoint.all();
    });

    /// GET members.find
    get('members/:id', (req, res) async {
      final endpoint = _i2.members(req, res);
      final String id = req.params['id'];
      await endpoint.find(id);
    });

    /// PUT members.update
    put('members/:id', (req, res) async {
      final endpoint = _i2.members(req, res);
      final _i3.Member member = req.params['member'];
      await endpoint.update(member);
    });

    /// POST members.create
    post('members', (req, res) async {
      final endpoint = _i2.members(req, res);
      final _i1.HttpRequest testparam = req.params['testparam'];
      final _i3.Member member = req.params['member'];
      await endpoint.create(testparam, member);
    });
  }
}
