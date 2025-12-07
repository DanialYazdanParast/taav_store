class ProductModel {
  final String id;
  final String title;
  final String description;
  final int quantity;
  final int price;
  final int discountPrice;
  final String image;
  final List<String> colors;
  final List<String> tags;
  final String sellerId;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.quantity,
    required this.price,
    required this.discountPrice,
    required this.image,
    required this.colors,
    required this.tags,
    required this.sellerId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      discountPrice: json['discountPrice'] ?? 0,
      image: json['image'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      sellerId: json['sellerId'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'quantity': quantity,
      'price': price,
      'discountPrice': discountPrice,
      'image': image,
      'colors': colors,
      'tags': tags,
      'sellerId': sellerId,
    };
  }


}