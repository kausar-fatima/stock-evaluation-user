class ShopProductDetails {
  final String id; // Add this line
  final double purchasedProducts;
  final double saleOutProducts;
  final double revenue;
  final double profit;
  final double loss;
  final double expenses;

  ShopProductDetails({
    required this.id,
    required this.purchasedProducts,
    required this.saleOutProducts,
    required this.revenue,
    required this.profit,
    required this.loss,
    required this.expenses,
  });

  factory ShopProductDetails.fromJson(Map<String, dynamic> json) {
    return ShopProductDetails(
      id: json['_id'],
      purchasedProducts: json['purchasedProducts'].toDouble(),
      saleOutProducts: json['saleOutProducts'].toDouble(),
      revenue: json['revenue'].toDouble(),
      profit: json['profit'].toDouble(),
      loss: json['loss'].toDouble(),
      expenses: json['expenses'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Add this line
      'purchasedProducts': purchasedProducts,
      'saleOutProducts': saleOutProducts,
      'revenue': revenue,
      'profit': profit,
      'loss': loss,
      'expenses': expenses,
    };
  }
}
