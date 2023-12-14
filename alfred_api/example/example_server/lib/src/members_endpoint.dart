import 'package:alfred/alfred.dart';
import 'package:alfred_api_annotation/alfred_api_annotation.dart';
import 'package:example_models/example_models.dart';

@Path('/members')
class MembersEndpoint extends Endpoint {
  MembersEndpoint(super.req, super.res);

  Future<List<Member>> all() async {
    return [];
  }

  @Path(':id')
  Future<Member?> find(String id) async {
    return Member(name: 'Tom');
  }

  @Path(':id')
  @Method.put
  Future<Member?> update(Member member) async {
    return member;
  }

  @Method.post
  Future<Member?> create(Member member) async {
    return member;
  }
}
