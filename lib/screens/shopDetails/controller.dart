import 'package:stock_management/headers.dart';

class DetailsController extends GetxController {
  final shopproducts = <ShopProductDetails>[].obs;
  final totalpurchased = 0.0.obs;
  final totalsaleout = 0.0.obs;
  final totalexpense = 0.0.obs;
  final revenue = 0.0.obs;
  final loss = 0.0.obs;
  final profit = 0.0.obs;

  var isLoading = true.obs; // Observable boolean to track loading state

  // Method to fetch products
  Future<void> fetchShopProducts(String shopId) async {
    isLoading.value = true;

    try {
      await Future.wait([
        fetchSaleoutProductsDetails(shopId),
        fetchPurchasedProductsDetails(shopId),
        fetchExpenses(shopId),
      ]);

      getRevenue();

      await addProductDetails(
        ShopProductDetails(
          expenses: totalexpense.value,
          id: shopId,
          loss: loss.value,
          profit: profit.value,
          purchasedProducts: totalpurchased.value,
          saleOutProducts: totalsaleout.value,
          revenue: revenue.value,
        ),
        shopId,
      );

      final res = await Api.getShopProductDetails(shopId);
      shopproducts.clear();
      shopproducts.add(res);
      for (var detail in shopproducts) {
        debugPrint(
            '-----fetch product detail response: -----${detail.purchasedProducts}-----${detail.saleOutProducts}-----${detail.expenses}------${detail.revenue}-----${detail.profit}-----${detail.loss}---------');
      }

      isLoading.value = false;
    } catch (e) {
      debugPrint(
          '----------Error fetching shop product details-----------: $e');
      isLoading.value = false;
    }
  }

  // Method to add a products detail
  Future<void> addProductDetails(ShopProductDetails product, String id) async {
    try {
      await Api.addShopProductDetails(product, id);
      debugPrint('Product details added successfully');
    } catch (e) {
      debugPrint('Error adding product details: $e');
    }
  }

  // Method to fetch saleout products
  Future<bool> fetchSaleoutProductsDetails(String shopId) async {
    // bool to make sure no error is occured
    isLoading.value = true;

    try {
      final res = await Api.fetchSaleOutProducts(
          shopId); // Call your static fetchSaleOutProducts method
      // Clear existing lists before updating
      var saleoutproducts = res.toList();

      for (var product in saleoutproducts) {
        totalsaleout.value += product.price;
        debugPrint(
            "_+_+_+_+_+__ ${product.id} ____ ${product.name} ___ ${product.category} ___ ${product.price} ___ ${product.quantity} _+_+_+_+_+__");
      }

      // Set loading state to false after fetching
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('----------Error fetching saleout products-----------: $e');
      // Set loading state to false if an error occurs
      isLoading.value = false;
      return false;
    }
  }

  // Method to fetch purchased products
  Future<bool> fetchPurchasedProductsDetails(String shopId) async {
    // bool to make sure no error is occured
    isLoading.value = true;

    try {
      final res = await Api.fetchProducts(
          shopId); // Call your static fetchSaleOutProducts method
      // Clear existing lists before updating
      var purchasedproducts = res.toList();

      for (var product in purchasedproducts) {
        totalpurchased.value += product.price;
        debugPrint(
            "_+_+_+_+_+__ ${product.id} ____ ${product.name} ___ ${product.category} ___ ${product.price} ___ ${product.quantity} _+_+_+_+_+__");
      }

      // Set loading state to false after fetching
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('----------Error fetching purchased products-----------: $e');
      // Set loading state to false if an error occurs
      isLoading.value = false;
      return false;
    }
  }

  // Method to fetch expenses
  Future<bool> fetchExpenses(String shopId) async {
    // bool to make sure no error is occured
    isLoading.value = true;

    try {
      final res = await Api.fetchExpenses(
          shopId); // Call your static fetchexpenses method
      // Clear existing lists before updating

      var expenses = res.toList();
      debugPrint("======= ${expenses} =======");

      for (var expense in expenses) {
        totalexpense.value += expense.amount;
      }
      // Set loading state to false after fetching
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('----------Error fetching expenses-----------: $e');
      // Set loading state to false if an error occurs
      isLoading.value = false;
      return false;
    }
  }

  // get revenue, profit and loss
  getRevenue() {
    revenue.value = (totalsaleout.value);
    final cost = totalexpense.value + totalpurchased.value;
    final difference = revenue.value - cost;
    if (difference > 0) {
      profit.value = difference;
      loss.value = 0.0;
    } else {
      loss.value = difference;
      profit.value = 0.0;
    }
    debugPrint(
        "======== ${totalpurchased.value} === ${totalsaleout.value} === ${totalexpense.value} === ${revenue.value} === ${profit} === ${loss} =======");
  }
}
