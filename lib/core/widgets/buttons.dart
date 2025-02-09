import 'package:stock_management/headers.dart';

class Buttons {
  static Widget CustomButton(
      double horPad, double verPad, String text, void Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horPad, vertical: verPad),
        width: double.infinity,
        child: Text(
          text,
          style: TextWidgets.titleTextStyle(secondaryColor),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: primaryColor),
      ),
    );
  }
}
