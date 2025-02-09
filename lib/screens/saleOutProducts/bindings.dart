import 'package:stock_management/headers.dart';

class SaleOutProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SaleOutProductController>(
      SaleOutProductController(),
    );
  }
}
