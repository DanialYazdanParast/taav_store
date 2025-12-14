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

    // 👇 لاجیک هوشمند برای انتخاب عکس
    String imageSource = '';
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imageSource = json['image'];
    } else if (json['imageBase64'] != null && json['imageBase64'].toString().isNotEmpty) {
      imageSource = json['imageBase64'];
    }

    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      quantity: _parseInt(json['quantity']),
      price: _parseInt(json['price']),
      discountPrice: _parseInt(json['discountPrice']),

      image: imageSource, // 👈 اینجا مقدار نهایی را پاس میدهیم

      colors: List<String>.from(json['colors'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      sellerId: json['sellerId'] ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
extension ProductModelCopy on ProductModel {
  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    int? price,
    int? discountPrice,
    int? quantity,
    String? sellerId,
    List<String>? colors,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      quantity: quantity ?? this.quantity,
      sellerId: sellerId ?? this.sellerId,
      colors: colors ?? this.colors,
      tags: tags ?? this.tags,
    );
  }
}
