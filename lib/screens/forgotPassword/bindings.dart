import 'package:stock_management/headers.dart';

class ForgotPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<forgotPassController>(
      forgotPassController(),
    );
  }
}
