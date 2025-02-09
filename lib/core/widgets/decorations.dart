import 'package:stock_management/headers.dart';

class Decorations {
  static BoxDecoration pageModelDecoration = BoxDecoration(
    color: secondaryColor,
    border: Border.all(
      width: 0.0,
      color: secondaryColor,
    ),
  );

  static Padding pagePadding() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Sizes.padh, vertical: Sizes.padv),
    );
  }

  static OutlineInputBorder InputFieldFocusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: primaryColor),
    );
  }

  static OutlineInputBorder InputFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: primaryColor),
    );
  }
}
