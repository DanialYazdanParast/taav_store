class OrderModel {
  final int id;
  final String buyerId;
  final int totalPrice;
  final String date;
  final String status;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.totalPrice,
    required this.date,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      buyerId: json['buyerId']?.toString() ?? '',
      totalPrice: json['totalPrice'] is int ? json['totalPrice'] : int.tryParse(json['totalPrice'].toString()) ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? 'pending',
      items: (json['items'] as List?)?.map((e) => OrderItem.fromJson(e)).toList() ?? [],
    );
  }
}

class OrderItem {
  final String productId;
  final String productTitle;
  final String image;
  final int quantity;
  final String colorHex;
  final int price;
  final String sellerId;

  OrderItem({
    required this.productId,
    required this.productTitle,
    required this.image,
    required this.quantity,
    required this.colorHex,
    required this.price,
    required this.sellerId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId']?.toString() ?? '',
      productTitle: json['productTitle'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity'].toString()) ?? 0,
      colorHex: json['color'] ?? '',
      price: json['price'] is int ? json['price'] : int.tryParse(json['price'].toString()) ?? 0,

      // ✅ اضافه شده: خواندن از جیسون
      sellerId: json['sellerId']?.toString() ?? '',
    );
  }
}