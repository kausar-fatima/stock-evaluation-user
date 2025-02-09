import 'package:stock_management/headers.dart';

class OTPController extends GetxController {
  var OTPvalue = ''.obs;
  var remember = false.obs;

  void setOTP(String value) {
    OTPvalue.value = value;
  }

  void setRemember(bool value) {
    remember.value = value;
  }
}
