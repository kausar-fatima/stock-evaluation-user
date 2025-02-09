import 'package:stock_management/headers.dart';

class Texts {
  static String onBoardTitle1 = 'WELCOME';
  static String onBoardText11 =
      'StockPro Is Your Ultimate Solution For Managing Stock And Sales In Your Shop Branches';
  static String onBoardText12 =
      'With Powerful Features And Intuitive Design, You Can Streamline Your Inventory Management And Boost Sales Effortlessly';

  static String onBoardTitle2 = 'DISCOVER POWERFUL FEATURES';
  static String onBoardText21 = 'Realtime Stock Tracking';
  static String onBoardText22 = 'Comprehensive Sales Analytics';
  static String onBoardText23 = 'Effortless Branch Management';

  static String onBoardTitle3 = 'UNLOCK EXCITING BENEFITS';
  static String onBoardText31 = 'Save Time With Efficient Stock Management';
  static String onBoardText32 = 'Increase Sales With Actionable Insights';
  static String onBoardText33 = 'Experience Hassle-Free Inventory Tracking';

  static String onBoardTitle4 = 'GET STARTED';
  static String onBoardText41 = 'SignUp Or Login To Your StockPro Account';
  static String onBoardText42 = 'Add Your Shop Branches And Products';
  static String onBoardText43 = 'Monitor Stock Levels And Analyze Sales Data';

  //Form Error
  static RegExp emailValidatorRegExp =
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static String kEmailNullError = 'Please Enter your email';
  static String kInvalidEmailError = 'Please Enter valid email';
  static String kPassNullError = 'Please Enter your password';
  static String kShortPassError = 'Password is too short';
  static String kMatchPassError = 'Passwords don\'t match';
  static String kNameNullError = 'Please Enter your name';
  static String kPhoneNumberNullError = 'Please enter your phone number';
  static String kAddressNullError = 'Please enter your address';

  static String apiKey = "Yphz78R1cby8bekL1wbAkGCbqKX4WOS4";
  static var from = // Beni merred
      const LatLng(40.7128, -74.0060);
  static var to = // Somia blida
      const LatLng(40.7128, -74.0055);
}
