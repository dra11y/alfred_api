import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:alfred_api_annotation/alfred_api_annotation.dart';
import 'package:example_models/example_models.dart';

final memberTypeHandler =
    TypeHandler<Map<String, Member>>((HttpRequest req, HttpResponse res, val) {
  res.headers.contentType = ContentType.json;
  res.write(val.values.map((v) => v.toJson()));
  return res.close();
});

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
  Future<String?> update(Member member) async {
    return member.toString();
  }

  @Method.post
  Future<Member?> create(HttpRequest testparam, Member member) async {
    return member;
  }
}
