import 'package:stock_management/headers.dart';

class onBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OnboardingController>(
      OnboardingController(),
    );
  }
}
