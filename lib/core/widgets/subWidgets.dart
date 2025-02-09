import 'package:stock_management/headers.dart';

class SubWidgets {
  static Padding pageModelChild1(String onboard) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.padh1,
        vertical: Sizes.padv1,
      ),
      child: Image.asset(onboard),
    );
  }

  static Padding pageModelChild2(String Title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.padh1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Title,
          style: TextWidgets.titleTextStyle(primaryColor),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  static Padding pageModelChild3(String TexT) {
    return Padding(
      padding: EdgeInsets.only(
          left: Sizes.padh1, right: Sizes.padh1, top: Sizes.padv2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          TexT,
          style: TextWidgets.bodyTextStyle(primaryColor),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  static Widget BottomSheetDialog(BuildContext context) {
    return Container(
      color: primaryColor, // Optional: Set the background color
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Remember me has not been marked",
            style: TextStyle(color: secondaryColor),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the bottom sheet
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
