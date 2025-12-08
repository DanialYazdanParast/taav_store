class CartItemModel {
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

  CartItemModel({
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

  factory CartItemModel.fromJson(Map<String, dynamic> json) {

    int finalPrice = json['price'] is int ? json['price'] : int.tryParse(json['price'].toString()) ?? 0;
    return CartItemModel(
      id: json['id']?.toString(),
      productId: json['productId']?.toString() ?? '',
      productTitle: json['productTitle'] ?? '',
      productImage: json['image'] ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      colorHex: json['color'] ?? '',
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity'].toString()) ?? 1,
      price: finalPrice,
      originalPrice: json['originalPrice'] is int
          ? json['originalPrice']
          : int.tryParse(json['originalPrice']?.toString() ?? finalPrice.toString()) ?? finalPrice,

      maxStock: json['maxStock'] is int ? json['maxStock'] : int.tryParse(json['maxStock']?.toString() ?? '999') ?? 999,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     if (id != null) "id": id,
  //     "userId": userId,
  //     "productId": productId,
  //     "productTitle": productTitle,
  //     "image": productImage,
  //     "sellerId": sellerId,
  //     "quantity": quantity,
  //     "color": colorHex,
  //     "price": price,
  //     "originalPrice": originalPrice,
  //     "maxStock": maxStock,
  //   };
  // }

  int get totalPrice => price * quantity;
}