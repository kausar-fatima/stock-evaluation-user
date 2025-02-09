import 'package:stock_management/headers.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShopDetailsController>(
      ShopDetailsController(),
    );
  }
}
