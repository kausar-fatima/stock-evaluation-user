import 'package:stock_management/headers.dart';

class ExpensesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExpensesController>(
      ExpensesController(),
    );
  }
}
