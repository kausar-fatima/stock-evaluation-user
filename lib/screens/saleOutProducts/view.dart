import 'package:stock_management/headers.dart';

class SaleOutProductPage extends StatefulWidget {
  @override
  State<SaleOutProductPage> createState() => _SaleOutProductPageState();
}

class _SaleOutProductPageState extends State<SaleOutProductPage> {
  final SaleOutProductController saleoutproductController =
      Get.find<SaleOutProductController>();
  final isError = false.obs;
  late String shopId;

  final _addProductFormKey = GlobalKey<FormState>();
  final _editProductFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    shopId = Get.arguments['shopId']; // Initialize shopId from arguments
    _init();
  }

  _init() async {
    isError.value = false;
    final isSuccess = await saleoutproductController.fetchProducts(shopId);
    if (!isSuccess) {
      isError.value = true;
    }
    saleoutproductController.fetchProductCategories(shopId);
  }

  void onAdd() {
    if (_addProductFormKey.currentState!.validate()) {
      try {
        saleoutproductController.addProduct(
            SaleOutProduct(
              id: UniqueKey().toString(),
              shopId: shopId,
              name: saleoutproductController.selectedProductName.value,
              price: saleoutproductController.selectedproductPrice.value,
              quantity: saleoutproductController.selectedQuantity.value,
              category: saleoutproductController.selectedCategory.value,
            ),
            shopId);
        saleoutproductController
            .fetchQuantities(shopId); // Update available quantities
        resetFields();
      } catch (e) {
        debugPrint("ERROR OCCURRED THAT CAN BE OR CANNOT BE IGNORED $e");
      }
    }
  }

  void onEdit(SaleOutProduct product) {
    // Implement edit logic here

    saleoutproductController.setSelectedCategory(product.category);
    saleoutproductController.setSelectedProductName(product.name);
    saleoutproductController.setSelectedQuantity(product.quantity);
    saleoutproductController.selectedproductPrice.value = product.price;
    _showEditSaleOutProductDialog(context, product);
  }

  void onDelete(SaleOutProduct product) {
    saleoutproductController.deleteProduct(product);
  }

  void resetFields() {
    saleoutproductController.selectedProductName.value = '';
    saleoutproductController.selectedCategory.value = '';
    saleoutproductController.selectedQuantity.value = 0;
    saleoutproductController.selectedproductPrice.value = 0;
    saleoutproductController.productNames.clear();
    saleoutproductController.productQuantities.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SaleOut Products'),
      ),
      body: Obx(() {
        if (saleoutproductController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(), // Show loading indicator
          );
        } else if (isError.value) {
          return Center(
            child: ElevatedButton(onPressed: _init, child: const Text("Retry")),
          );
        } else if (saleoutproductController.saleoutproducts.isEmpty) {
          return const Center(
            child: Text('No products found.'),
          );
        } else {
          return ListView.builder(
            itemCount: saleoutproductController.saleoutproducts.length,
            itemBuilder: (context, index) {
              if (saleoutproductController.saleoutproducts.isEmpty) {
                return SizedBox(); // Return an empty widget if the list is empty
              } else {
                return ListTile(
                  title: Text(
                      'Name: ${saleoutproductController.saleoutproducts[index].name} | Category: ${saleoutproductController.saleoutproducts[index].category}'),
                  subtitle: Text(
                    'Price: ${saleoutproductController.saleoutproducts[index].price} | Quantity: ${saleoutproductController.saleoutproducts[index].quantity}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => onEdit(
                            saleoutproductController.saleoutproducts[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => onDelete(
                            saleoutproductController.saleoutproducts[index]),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSaleOutProductDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddSaleOutProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Sale Out Product'),
          content: SingleChildScrollView(
            child: Form(
              key: _addProductFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryDropdown(),
                  SizedBox(height: 20),
                  _buildProductNameDropdown(),
                  SizedBox(height: 20),
                  _buildQuantityDropdown(),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                resetFields();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_addProductFormKey.currentState!.validate()) {
                  onAdd();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditSaleOutProductDialog(
      BuildContext context, SaleOutProduct product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Sale Out Product'),
          content: SingleChildScrollView(
            child: Form(
              key: _editProductFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryDropdown(),
                  SizedBox(height: 20),
                  _buildProductNameDropdown(),
                  SizedBox(height: 20),
                  _buildEditQuantityDropdown(product),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                resetFields();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_editProductFormKey.currentState!.validate()) {
                  saleoutproductController.updateProduct(SaleOutProduct(
                    id: product.id,
                    shopId: shopId,
                    name: saleoutproductController.selectedProductName.value,
                    price: saleoutproductController.selectedproductPrice.value,
                    quantity: saleoutproductController.selectedQuantity.value,
                    category: saleoutproductController.selectedCategory.value,
                  ));
                  saleoutproductController
                      .fetchQuantities(shopId); // Update available quantities
                  resetFields();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(() {
      debugPrint("^^^^^^^${saleoutproductController.selectedCategory}^^^^^^^");
      debugPrint(
          "^^^^^^^${saleoutproductController.selectedProductName}^^^^^^^");
      debugPrint("^^^^^^^${saleoutproductController.selectedQuantity}^^^^^^^");
      debugPrint(
          "^^^^^^^${saleoutproductController.selectedproductPrice}^^^^^^^");
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: 'Category'),
        value: saleoutproductController.selectedCategory.isEmpty
            ? null
            : saleoutproductController.selectedCategory.value,
        items: saleoutproductController.productCategories
            .toSet()
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
            .toList(),
        onChanged: (String? value) {
          // Reset the selected values when the category changes
          saleoutproductController.setSelectedCategory(value!);
          saleoutproductController.selectedProductName.value = "";
          saleoutproductController.selectedQuantity.value = 0;

          saleoutproductController.fetchProductNames(shopId);
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Please select a category' : null,
      );
    });
  }

  Widget _buildProductNameDropdown() {
    return Obx(() {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: 'Product Name'),
        value: saleoutproductController.selectedProductName.value.isEmpty
            ? null
            : saleoutproductController.selectedProductName.value,
        items: saleoutproductController.productNames
            .map((productName) => DropdownMenuItem(
                  value: productName,
                  child: Text(productName),
                ))
            .toList(),
        onChanged: (String? value) {
          // Reset the selected quantity when the product name changes
          // saleoutproductController.selectedProductName.value = " ";
          saleoutproductController.selectedProductName(value!);
          saleoutproductController.selectedQuantity.value = 0;
          saleoutproductController.fetchQuantities(shopId);
        },
        validator: (value) => value == null || value.isEmpty
            ? 'Please select a product name'
            : null,
      );
    });
  }

  Widget _buildQuantityDropdown() {
    return Obx(() {
      int maxQuantity = saleoutproductController.productQuantities.value;
      debugPrint("^^^^^^^Fetched quantity:  ${maxQuantity}^^^^^^^");
      // Ensure the maxQuantity is non-negative and greater than zero.
      maxQuantity = maxQuantity < 0 ? 0 : maxQuantity;
      return DropdownButtonFormField<int>(
        decoration: InputDecoration(labelText: 'Quantity'),
        value: saleoutproductController.selectedQuantity.value == 0
            ? null
            : saleoutproductController.selectedQuantity.value,
        items: maxQuantity > 0
            ? List.generate(
                maxQuantity,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}'),
                ),
              )
            : [],
        onChanged: (int? value) {
          saleoutproductController.setSelectedQuantity(value!);
          saleoutproductController.fetchPrices(shopId);
        },
        validator: (value) => value == null || value <= 0
            ? 'Please select a valid quantity'
            : null,
      );
    });
  }

  // Quantity dropdown for edit saleoutProducts
  Widget _buildEditQuantityDropdown(SaleOutProduct product) {
    return Obx(() {
      int maxQuantity = saleoutproductController.productQuantities.value;
      if (product.name == saleoutproductController.selectedProductName.value &&
          product.category == saleoutproductController.selectedCategory.value) {
        maxQuantity += product.quantity;
      }
      debugPrint("^^^^^^^Product quantity:  ${product.quantity}^^^^^^^");
      debugPrint("^^^^^^^Fetched quantity:  ${maxQuantity}^^^^^^^");
      // Ensure the maxQuantity is non-negative and greater than zero.
      maxQuantity = maxQuantity < 0 ? 0 : maxQuantity;
      return DropdownButtonFormField<int>(
        decoration: InputDecoration(labelText: 'Quantity'),
        value: saleoutproductController.selectedQuantity.value == 0
            ? null
            : saleoutproductController.selectedQuantity.value,
        items: maxQuantity > 0
            ? List.generate(
                maxQuantity,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}'),
                ),
              )
            : [],
        onChanged: (int? value) {
          saleoutproductController.setSelectedQuantity(value!);
          saleoutproductController.fetchPrices(shopId);
        },
        validator: (value) => value == null || value <= 0
            ? 'Please select a valid quantity'
            : null,
      );
    });
  }
}
