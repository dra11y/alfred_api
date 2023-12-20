// GENERATED CODE - DO NOT MODIFY BY HAND
//
// GENERATED CLIENT CODE
//

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example_models/example_models.dart' as _i2;
import 'package:http/http.dart' as _i1;

class Client {
  Client(this.httpClient);

  final _i1.Client httpClient;

  late final MembersClient members = MembersClient(httpClient);
}

class MembersClient {
  MembersClient(this.httpClient);

  final _i1.Client httpClient;

  Future<List<_i2.Member>> all() async {}
  Future<_i2.Member?> find() async {}
  Future<String?> update() async {}
  Future<_i2.Member?> create() async {}
}
