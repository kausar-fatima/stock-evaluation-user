import 'package:stock_management/headers.dart';

class ShopProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DetailsController>(
      DetailsController(),
    );
  }
}
