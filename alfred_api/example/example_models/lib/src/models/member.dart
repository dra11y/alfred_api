import 'package:dart_mappable/dart_mappable.dart';

part 'member.mapper.dart';

@MappableClass()
class Member with MemberMappable {
  final String name;
  final String? email;

  const Member({
    required this.name,
    this.email,
  });
}
