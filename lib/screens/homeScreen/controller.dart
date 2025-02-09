import 'package:stock_management/headers.dart';

class ShopDetailsController extends GetxController {
  final shops = <ShopDetails>[].obs;
  var userId = "".obs;

  var isLoading = true.obs; // Observable boolean to track loading state

  Future<void> getuserid() async {
    userId.value = (await getUserId())!;
    debugPrint("&&&&&&&&&${await getUserId()}&&&&&&&&&&");
    if (userId == null) {
      // Handle the case where userId is not available
      debugPrint('User ID is not available');
      return;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch products when the controller is initialized
    fetchShops();
  }

  // Method to fetch products
  Future<bool> fetchShops() async {
    // bool to make sure no error is occured
    isLoading.value = true;
    await getuserid();
    try {
      final res = await Api.getShopDetails(
          userId.value); // Call your static fetchShops method
      // Clear existing lists before updating
      shops.clear();
      shops.assignAll(res.toList());
      // Set loading state to false after fetching
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('----------Error fetching shops-----------: $e');
      // Set loading state to false if an error occurs
      isLoading.value = false;
      return false;
    }
  }

  // Method to update products

  // Method to add a product
  void addShops(ShopDetails shop) async {
    try {
      var newshop =
          await Api.addShopDetails(shop); // Call your static addProduct method
      await Api.addShopToUser(userId.value, newshop.id);

      // Clear existing shop IDs in SharedPreferences
      await clearShopIds();

      // Add the new product to the observable lists
      shops.add(shop);
      await Api.getShopDetails(userId.value);
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }
}
