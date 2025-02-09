import 'package:stock_management/headers.dart';

class PurchaseProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PurchaseProductController>(
      PurchaseProductController(),
    );
  }
}
