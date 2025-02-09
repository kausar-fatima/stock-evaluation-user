// product_model.dart
import 'package:stock_management/headers.dart';

class SaleOutProduct {
  String _id; // Add ID field
  String shopId;
  String name;
  double price;
  int quantity;
  String category;

  SaleOutProduct({
    required String id, // Public constructor parameter without underscore
    required this.shopId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  }) : _id = id; // Assign the public parameter to the private field

  String get id => _id; // Getter method for the private field

  factory SaleOutProduct.fromJson(Map<String, dynamic> json) {
    debugPrint("----------${json}---------");
    return SaleOutProduct(
      id: json['_id'] ?? '', // Use empty string if 'id' is null or missing
      shopId: json['shopId'] ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id, // Include ID in JSON
      'shopId': shopId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
    };
  }
}
