class EditProductDto {
  final String title;
  final String description;
  final int price;
  final int quantity;
  final int discountPrice;
  final String sellerId;
  final List<String> colors;
  final List<String> tags;
  final String? image;

  EditProductDto({
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
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'price': price,
      'quantity': quantity,
      'discountPrice': discountPrice,
      'sellerId': sellerId,
      'colors': colors,
      'tags': tags,
    };

    if (image != null && image!.isNotEmpty) {
      data['imageBase64'] = image;
    }

    return data;
  }
}