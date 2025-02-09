import 'package:stock_management/headers.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(),
    );
  }
}
