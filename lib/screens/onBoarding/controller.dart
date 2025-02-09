import 'package:stock_management/headers.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;

  void setPageIndex(int index) {
    currentIndex.value = index;
  }
}
