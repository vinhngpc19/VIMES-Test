class StockInItemModel {
  String? name;
  String? code;
  String? unit;
  int? docQuantity;
  int? quantity;
  int? price;
  int? total;

  StockInItemModel({
    required this.name,
    required this.code,
    required this.unit,
    required this.docQuantity,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory StockInItemModel.fromJson(Map<String, dynamic> json) {
    return StockInItemModel(
      name: json['name'],
      code: json['code'],
      unit: json['unit'],
      docQuantity: json['docQuantity'],
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'unit': unit,
      'docQuantity': docQuantity,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }
}
