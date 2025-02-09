import 'package:stock_management/headers.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OTPController>(
      OTPController(),
    );
  }
}
