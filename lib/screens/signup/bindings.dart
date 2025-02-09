import 'package:stock_management/headers.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SignUpController>(
      SignUpController(),
    );
  }
}
