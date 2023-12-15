import 'package:analyzer/dart/element/type.dart';

extension DartTypeExtension on DartType {
  DartType flatten() => element!.library!.typeSystem.flatten(this);
}
