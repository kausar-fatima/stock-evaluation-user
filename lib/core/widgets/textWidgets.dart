import 'package:stock_management/headers.dart';

class TextWidgets {
  static TextStyle titleTextStyle(Color color) {
    return TextStyle(
        fontWeight: FontWeight.bold, color: color, fontSize: Sizes.title);
  }

  static TextStyle bodyTextStyle(Color color) {
    return TextStyle(
        fontWeight: FontWeight.w500, color: color, fontSize: Sizes.text);
  }
}
