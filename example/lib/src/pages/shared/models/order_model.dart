
class OrderModel {
  final int id;
  final String buyerId;
  final int totalPrice;
  final String date;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.totalPrice,
    required this.date,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      buyerId: json['buyerId'],
      totalPrice: json['totalPrice'],
      date: json['date'],
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
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

  OrderItem({
    required this.productId,
    required this.productTitle,
    required this.image,
    required this.quantity,
    required this.colorHex,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'].toString(),
      productTitle: json['productTitle'],
      image: json['image'],
      quantity: json['quantity'],
      colorHex: json['color'],
      price: json['price'],
    );
  }
}