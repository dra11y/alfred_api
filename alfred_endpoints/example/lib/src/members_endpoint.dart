import 'package:alfred/alfred.dart';
import 'package:alfred_endpoints/alfred_endpoints.dart';

class Member {}

@Path('/members')
class MembersEndpoint extends Endpoint {
  MembersEndpoint(super.req, super.res);

  Future<List<Member>> all() async {
    return [];
  }

  @Path(':id')
  Future<Member?> find(String id) async {
    return Member();
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
