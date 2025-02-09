import 'package:stock_management/headers.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PurchaseProductController productController =
      Get.find<PurchaseProductController>();
  final isError = false.obs;
  late String shopId;

  @override
  void initState() {
    super.initState();
    shopId = Get.arguments['shopId']; // Initialize shopId from arguments
    _init();
  }

  _init() async {
    isError.value = false;
    final isSuccess = await productController.fetchProducts(shopId);
    if (!isSuccess) {
      isError.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchased Products'),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(), // Show loading indicator
          );
        } else if (isError.value) {
          return Center(
            child: ElevatedButton(onPressed: _init, child: const Text("Retry")),
          );
        } else if (productController.products.isEmpty) {
          return const Center(
            child: Text('No products found.'),
          );
        } else {
          return ListView.builder(
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final p = productController.products[index];
              return ListTile(
                title: Text('Name: ${p.name} | Category: ${p.category}'),
                subtitle: Text('Price: \$${p.price} | Quantity: ${p.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditProductDialog(context, p)),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => productController.deleteProduct(p),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _AddForm(
          addProduct: productController.addProduct,
          fetchProduct: () => productController.fetchProducts(shopId),
          shopId: shopId,
          existingProductNames:
              productController.products.map((p) => p.name).toList(),
        );
      },
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _EditForm(
          editProduct: productController.updateProduct,
          fetchProduct: () => productController.fetchProducts(shopId),
          shopId: shopId,
          existingProductNames:
              productController.products.map((p) => p.name).toList(),
          product: product,
        );
      },
    );
  }
}

class _AddForm extends StatefulWidget {
  const _AddForm({
    required this.addProduct,
    required this.fetchProduct,
    required this.shopId,
    required this.existingProductNames,
  });

  final FutureOr<void> Function(Product) addProduct;
  final Future<bool> Function() fetchProduct;
  final String shopId;
  final List<String> existingProductNames;

  @override
  State<_AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<_AddForm> {
  final _formKey = GlobalKey<FormState>();
  final nameTEC = TextEditingController();
  final priceTEC = TextEditingController();
  final quantityTEC = TextEditingController();
  final categoryTEC = TextEditingController();

  Future<void> onAdd() async {
    if (_formKey.currentState!.validate()) {
      try {
        double price = double.tryParse(priceTEC.text) ?? 0.0;
        int quantity = int.tryParse(quantityTEC.text) ?? 0;

        await widget.addProduct(
          Product(
            id: UniqueKey().toString(),
            shopId: widget.shopId,
            name: nameTEC.text,
            price: price,
            quantity: quantity,
            category: categoryTEC.text,
          ),
        );
        widget.fetchProduct();
        Navigator.of(context).pop();
      } catch (e) {
        debugPrint("ERROR OCCURRED THAT CAN BE OR CANNOT BE IGNORED $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameTEC,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  if (widget.existingProductNames.contains(value)) {
                    return 'Product name already exists';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceTEC,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantityTEC,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoryTEC,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm({
    required this.editProduct,
    required this.fetchProduct,
    required this.shopId,
    required this.product,
    required this.existingProductNames,
  });

  final FutureOr<void> Function(Product) editProduct;
  final Future<bool> Function() fetchProduct;
  final String shopId;
  final Product product;
  final List<String> existingProductNames;

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameTEC;
  late TextEditingController priceTEC;
  late TextEditingController quantityTEC;
  late TextEditingController categoryTEC;

  @override
  void initState() {
    super.initState();
    nameTEC = TextEditingController(text: widget.product.name);
    priceTEC = TextEditingController(text: widget.product.price.toString());
    quantityTEC =
        TextEditingController(text: widget.product.quantity.toString());
    categoryTEC = TextEditingController(text: widget.product.category);
  }

  Future<void> onEdit() async {
    if (_formKey.currentState!.validate()) {
      try {
        double price = double.tryParse(priceTEC.text) ?? 0.0;
        int quantity = int.tryParse(quantityTEC.text) ?? 0;

        await widget.editProduct(
          Product(
            id: widget.product.id,
            shopId: widget.shopId,
            name: nameTEC.text,
            price: price,
            quantity: quantity,
            category: categoryTEC.text,
          ),
        );
        widget.fetchProduct();
        Navigator.of(context).pop();
      } catch (e) {
        debugPrint("ERROR OCCURRED THAT CAN BE OR CANNOT BE IGNORED $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameTEC,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  // Allow the same name for the current product being edited
                  if (widget.existingProductNames.contains(value)) {
                    return 'Product name already exists';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceTEC,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantityTEC,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoryTEC,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: onEdit,
          child: const Text('Edit'),
        ),
      ],
    );
  }
}
