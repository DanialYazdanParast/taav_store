
class CartItemDTO {
  String? id;
  final String productId;
  final String productTitle;
  final String productImage;
  final String sellerId;
  final String userId;
  final String colorHex;
  int quantity;
  final int price;
  final int originalPrice;
  final int maxStock;

  CartItemDTO({
    this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.sellerId,
    required this.userId,
    required this.colorHex,
    required this.quantity,
    required this.price,
    required this.originalPrice,
    required this.maxStock,
  });


  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "userId": userId,
      "productId": productId,
      "productTitle": productTitle,
      "image": productImage,
      "sellerId": sellerId,
      "quantity": quantity,
      "color": colorHex,
      "price": price,
      "originalPrice": originalPrice,
      "maxStock": maxStock,
    };
  }
}