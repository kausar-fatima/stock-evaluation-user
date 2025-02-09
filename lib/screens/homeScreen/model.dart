class ShopDetails {
  final String id; // Add this line
  final String userId;
  final String name;
  final String location;
  final double purchasedProducts;
  final double saleOutProducts;
  final double revenue;
  final double profit;
  final double loss;
  final double expenses;

  ShopDetails({
    required this.id, // Add this line
    required this.userId,
    required this.name,
    required this.location,
    this.purchasedProducts = 0.0,
    this.saleOutProducts = 0.0,
    this.revenue = 0.0,
    this.profit = 0.0,
    this.loss = 0.0,
    this.expenses = 0.0,
  });

  factory ShopDetails.fromJson(Map<String, dynamic> json) {
    return ShopDetails(
      id: json['_id'], // Use _id from the backend response
      userId: json['userId'],
      name: json['name'],
      location: json['location'],
      purchasedProducts: json['purchasedProducts']?.toDouble() ?? 0.0,
      saleOutProducts: json['saleOutProducts']?.toDouble() ?? 0.0,
      revenue: json['revenue']?.toDouble() ?? 0.0,
      profit: json['profit']?.toDouble() ?? 0.0,
      loss: json['loss']?.toDouble() ?? 0.0,
      expenses: json['expenses']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Add this line
      'userId': userId,
      'name': name,
      'location': location,
      'purchasedProducts': purchasedProducts,
      'saleOutProducts': saleOutProducts,
      'revenue': revenue,
      'profit': profit,
      'loss': loss,
      'expenses': expenses,
    };
  }
}
