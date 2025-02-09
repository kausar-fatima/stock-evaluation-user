import 'package:stock_management/headers.dart';

class PurchaseProductController extends GetxController {
  final products = <Product>[].obs;

  var isLoading = true.obs; // Observable boolean to track loading state

  // Method to fetch products
  Future<bool> fetchProducts(String shopId) async {
    // bool to make sure no error is occured
    isLoading.value = true;

    try {
      final res = await Api.fetchProducts(
          shopId); // Call your static fetchProducts method
      // Clear existing lists before updating
      products.clear();
      products.assignAll(res.toList());
      // Set loading state to false after fetching
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('----------Error fetching products-----------: $e');
      // Set loading state to false if an error occurs
      isLoading.value = false;
      return false;
    }
  }

  // Method to update products

  // Method to add a product
  void addProduct(Product product) async {
    try {
      await Api.addProduct(product); // Call your static addProduct method
      // Add the new product to the observable lists
      products.add(product);
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }

  // Method to edit a product
  // Method to update a product
  void updateProduct(Product updatedProduct) async {
    try {
      // Find the index of the product to be updated
      int index = products.indexWhere((product) => (product.id ==
          updatedProduct.id)); // Assuming 'id' is the unique identifier

      if (index != -1) {
        // If the product is found, update its properties
        products[index].name = updatedProduct.name;
        products[index].price = updatedProduct.price;
        products[index].quantity = updatedProduct.quantity;
        products[index].category = updatedProduct.category;

        for (var products in products) {
          debugPrint(
              "_______ ${products.id} ___ ${products.name} ___ ${products.category} ___ ${products.price} ___ ${products.quantity} _______");
        }
        // Call the API method or update the data source with the updated product
        await Api.updateProduct(updatedProduct);
      } else {
        // Handle the case where the product is not found
        debugPrint('Product not found for updating');
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  //Method to delete a product
  void deleteProduct(Product product) async {
    try {
      debugPrint('Deleting product: ${product.toJson()}');
      products.remove(product);
      await Api.deleteProduct(product);
    } catch (e) {
      debugPrint('Error deleting Saleout product: $e');
    }
  }
}
