import 'package:stock_management/headers.dart';

class SaleOutProductController extends GetxController {
  var saleoutproducts = <SaleOutProduct>[].obs;
  var productCategories = <String>[].obs;
  var productNames = <String>[].obs;
  var productQuantities = 0.obs;
  var selectedCategory = ''.obs;
  var selectedProductName = ''.obs;
  var selectedQuantity = 0.obs;
  var selectedproductPrice = 0.0.obs;
  var isLoading = true.obs;
  var saleoutQuantity = 0.obs; // Initialize the total saleout quantity

  // set selected product name
  void setSelectedProductName(String productName) {
    selectedProductName.value = productName;
  }

  // set selected quantity
  void setSelectedQuantity(int quantity) {
    selectedQuantity.value = quantity;
  }

  // set selected category
  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  // Method to fetch product categories
  void fetchProductCategories(String shopId) async {
    try {
      final List<Product> products = await Api.fetchProducts(shopId);
      productCategories.clear();
      productCategories.assignAll(
          products.map((product) => product.category).toSet().toList());
      isLoading.value = false;
    } catch (e) {
      debugPrint('Error fetching product categories: $e');
    }
  }

// Method to fetch product names based on selected category
  void fetchProductNames(String shopId) async {
    final List<Product> products = await Api.fetchProducts(shopId);
    productNames.clear();
    final filteredProducts = products
        .where((product) => product.category == selectedCategory.value)
        .toList();
    productNames.assignAll(
        filteredProducts.map((product) => product.name).toSet().toList());
  }

  // Method to fetch quantities based on selected product name
  void fetchQuantities(String shopId) async {
    final List<Product> products = await Api.fetchProducts(shopId);

    productQuantities.value = 0;
    int purchasedQuantity = 0; // Initialize the total purchased quantity
    saleoutQuantity.value = 0; // Reset saleout quantity

    // Loop through the products to find the quantities of the selected product name
    for (var product in products) {
      if (product.name == selectedProductName.value &&
          product.category == selectedCategory.value) {
        purchasedQuantity =
            product.quantity; // Set the quantity of the matching product
      }
      debugPrint("^^^^^^^Purchased quantity:  ${purchasedQuantity}^^^^^^^");
    }

    // Loop through the saleout products to find the quantities of the selected product name
    for (var product in saleoutproducts) {
      if (product.name == selectedProductName.value &&
          product.category == selectedCategory.value) {
        saleoutQuantity.value += product
            .quantity; // Add the quantity of each matching saleout product
      }
      debugPrint("^^^^^^^Saleout quantity:  ${saleoutQuantity.value}^^^^^^^");
    }

    // Calculate the available quantity
    if (purchasedQuantity > saleoutQuantity.value) {
      productQuantities.value = purchasedQuantity - saleoutQuantity.value;
      debugPrint(
          "^^^^^^^Available quantity:  ${productQuantities.value}^^^^^^^");
    } else {
      productQuantities.value = 0;
      debugPrint(
          "^^^^^^^Available quantity:  ${productQuantities.value}^^^^^^^");
    }
  }

  //on selecting product quantity for edit product
  // void updateQuantity() {
  //   if (selectedQuantity.value < saleoutQuantity.value) {
  //     productQuantities.value +=
  //         (productQuantities.value - selectedQuantity.value);
  //   } else if (selectedQuantity.value > saleoutQuantity.value) {
  //     productQuantities.value -=
  //         (selectedQuantity.value - productQuantities.value);
  //   }
  // }

  // Method to fetch prices based on selected product name and category
  void fetchPrices(String shopId) async {
    final List<Product> products = await Api.fetchProducts(shopId);
    selectedproductPrice.value = 0;
    // Loop through the products to find the prices of the selected product name
    for (var product in products) {
      if (product.category == selectedCategory.value &&
          product.name == selectedProductName.value &&
          selectedQuantity.value != 0) {
        selectedproductPrice.value = product.price * selectedQuantity.value;
        return;
      } else {
        selectedproductPrice.value = 0;
      }
    }
  }

  // Method to fetch products
  Future<bool> fetchProducts(String id) async {
    // bool to make sure no error is occured
    isLoading.value = true;

    try {
      saleoutproducts.clear();
      final res = await Api.fetchSaleOutProducts(
          id); // Call your static fetchSaleOutProducts method
      // Clear existing lists before updating
      saleoutproducts.assignAll(res.toList());

      for (var product in saleoutproducts) {
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

  // Method to update products

  // Method to add a product
  void addProduct(SaleOutProduct product, String id) async {
    try {
      await Api.addSaleOutProduct(
          product, id); // Call your static addSaleOutProduct method
      // Add the new product to the observable lists
      saleoutproducts.add(product);
    } catch (e) {
      debugPrint('Error adding Saleout product: $e');
    }
  }

  // Method to update a product
  void updateProduct(SaleOutProduct updatedProduct) async {
    try {
      // Find the index of the product to be updated
      int index = saleoutproducts.indexWhere((product) => (product.id ==
          updatedProduct.id)); // Assuming 'id' is the unique identifier

      if (index != -1) {
        // If the product is found, update its properties
        saleoutproducts[index].name = updatedProduct.name;
        saleoutproducts[index].price = updatedProduct.price;
        saleoutproducts[index].quantity = updatedProduct.quantity;
        saleoutproducts[index].category = updatedProduct.category;

        for (var products in saleoutproducts) {
          debugPrint(
              "_______ ${products.id} ___ ${products.name} ___ ${products.category} ___ ${products.price} ___ ${products.quantity} _______");
        }
        // Call the API method or update the data source with the updated product
        await Api.updateSaleOutProduct(updatedProduct);
      } else {
        // Handle the case where the product is not found
        debugPrint('Product not found for updating');
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  //Method to delete a product
  void deleteProduct(SaleOutProduct product) async {
    try {
      debugPrint('Deleting product: ${product.toJson()}');
      saleoutproducts.remove(product);
      await Api.deleteSaleOutProduct(product);
    } catch (e) {
      debugPrint('Error deleting Saleout product: $e');
    }
  }
}
