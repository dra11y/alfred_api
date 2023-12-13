// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alfred/alfred.dart' as _i1;
import 'package:example/src/members_endpoint.dart' as _i2;

extension AlfredEndpointRoutesExtension on _i1.Alfred {
  void addEndpointRoutes() {
    /// GET MembersEndpoint.all
    get(
      '/members',
      (
        req,
        res,
      ) {
        final endpoint = _i2.MembersEndpoint(
          req,
          res,
        );
        endpoint.all();
      },
    );

    /// GET MembersEndpoint.find
    get(
      '/members/:id',
      (
        req,
        res,
      ) {
        final endpoint = _i2.MembersEndpoint(
          req,
          res,
        );
        final String id = req.params['id'];
        endpoint.find(id);
      },
    );

    /// PUT MembersEndpoint.update
    put(
      '/members/:id',
      (
        req,
        res,
      ) {
        final endpoint = _i2.MembersEndpoint(
          req,
          res,
        );
        final _i2.Member member = req.params['member'];
        endpoint.update(member);
      },
    );

    /// POST MembersEndpoint.create
    post(
      '/members',
      (
        req,
        res,
      ) {
        final endpoint = _i2.MembersEndpoint(
          req,
          res,
        );
        final _i2.Member member = req.params['member'];
        endpoint.create(member);
      },
    );
  }
}
