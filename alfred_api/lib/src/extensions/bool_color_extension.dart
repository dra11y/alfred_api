import 'package:alfred_api/src/extensions/extensions.dart';

extension BoolColorExtension on bool {
  String color() {
    final pen = Pens.black;
    this ? pen.green(bg: true) : pen.red(bg: true);
    return pen(toString());
  }
}
