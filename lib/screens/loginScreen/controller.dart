import 'package:stock_management/headers.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var remember = false.obs;
  var showPassword = false.obs; // New variable to track password visibility

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void setRemember(bool value) {
    remember.value = value;
    update();
  }

  // Method to toggle password visibility
  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
    update();
  }
}
