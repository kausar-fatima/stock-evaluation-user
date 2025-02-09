// ignore_for_file: camel_case_types

import 'package:stock_management/headers.dart';

class forgotPassController extends GetxController {
  var email = ''.obs;
  var newpassword = ''.obs;
  var confirmPassword = ''.obs;
  var remember = false.obs;
  var showPassword = false.obs; // New variable to track password visibility
  var showConfirmPassword =
      false.obs; // New variable to track confirm password visibility

  void setEmail(String value) {
    email.value = value;
    update();
  }

  void setNewPassword(String value) {
    newpassword.value = value;
    update();
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
    update();
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

  // Method to toggle confirm password visibility
  void toggleShowConfirmPassword() {
    showConfirmPassword.value = !showConfirmPassword.value;
    update();
  }
}
