class Expense {
  String id;
  String shopId;
  String name;
  double amount;

  Expense({
    required this.id,
    required this.shopId,
    required this.name,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'] ?? '', // Use empty string if 'id' is null or missing
      shopId: json['shopId'] ?? '',
      name: json['name'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include ID in JSON
      'shopId': shopId,
      'name': name,
      'amount': amount,
    };
  }
}
