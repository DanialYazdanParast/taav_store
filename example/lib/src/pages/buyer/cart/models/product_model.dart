import 'package:example/src/pages/shared/models/product_model.dart';

class CartItemModel {
  final String id; // ترکیبی از آیدی محصول و رنگ برای یکتا بودن
  final ProductModel product;
  final String selectedColor;
  int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    required this.selectedColor,
    required this.quantity,
  });

  // محاسبه قیمت نهایی این آیتم (تعداد × قیمت واحد)
  double get totalPrice {
    double price = (product.discountPrice > 0 && product.discountPrice < product.price)
        ? product.discountPrice.toDouble()
        : product.price.toDouble();
    return price * quantity;
  }
}