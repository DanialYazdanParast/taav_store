import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/shared/models/product_model.dart';
// ✅ ایمپورت مدل سبد خرید (مسیر را بر اساس پروژه خود چک کنید)
import 'package:example/src/pages/buyer/cart/models/cart_item_model.dart';

abstract class ISellerProductsRepository {
  Future<Either<Failure, List<ProductModel>>> getSellerProducts(String sellerId);
  Future<Either<Failure, void>> deleteProduct(String productId);

  // ✅ متد جدید: دریافت آیتم‌های سبد خرید مربوط به این فروشنده
  Future<Either<Failure, List<CartItemModel>>> getCartItemsBySeller(String sellerId);
}

class SellerProductsRepository extends BaseRepository implements ISellerProductsRepository {
  final NetworkService _network;

  SellerProductsRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, List<ProductModel>>> getSellerProducts(String sellerId) {
    return safeCall<List<ProductModel>>(
      request: () => _network.get('/products', queryParameters: {'sellerId': sellerId}),
      fromJson: (json) {
        if (json is List) return json.map((e) => ProductModel.fromJson(e)).toList();
        return [];
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) {
    return safeCall<void>(
      request: () => _network.delete('/products/$productId'),
      fromJson: (_) {},
    );
  }

  // ✅ پیاده‌سازی متد جدید
  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItemsBySeller(String sellerId) {
    return safeCall<List<CartItemModel>>(
      // درخواست به اندپوینت cart با فیلتر sellerId
      // این کوئری تمام آیتم‌های داخل کارت تمام یوزرها که sellerId آنها برابر با فروشنده جاری است را برمی‌گرداند
      request: () => _network.get('/cart', queryParameters: {'sellerId': sellerId}),

      fromJson: (json) {
        if (json is List) {
          return json.map((e) => CartItemModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }
}