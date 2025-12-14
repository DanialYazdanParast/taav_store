class AddProductDto {
  final String title;
  final String description;
  final int price;
  final int quantity;
  final int discountPrice;
  final String sellerId;
  final List<String> colors;
  final List<String> tags;
  final String? image;

  AddProductDto({
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.discountPrice,
    required this.sellerId,
    required this.colors,
    required this.tags,
    this.image,
  });


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
      'discountPrice': discountPrice,
      'sellerId': sellerId,
      'colors': colors,
      'tags': tags,
      'imageBase64': image,
    };
  }
}