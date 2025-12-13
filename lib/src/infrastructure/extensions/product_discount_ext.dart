import 'package:taav_store/src/pages/shared/models/product_model.dart';


extension ProductDiscountExt on ProductModel {
  int get discountPercent {
    if (price == 0) return 0;
    return ((price - discountPrice) * 100 / price).round();
  }

  String get discountPercentString => '$discountPercent';
}
