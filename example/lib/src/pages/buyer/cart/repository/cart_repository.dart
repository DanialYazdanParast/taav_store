import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import '../models/cart_item_model.dart';

abstract class ICartRepository {
  Future<Either<Failure, List<CartItemModel>>> getCartItems(String userId);
  Future<Either<Failure, CartItemModel>> addToCart(CartItemModel item);
  Future<Either<Failure, CartItemModel>> updateQuantity(String itemId, int quantity);
  Future<Either<Failure, void>> deleteItem(String itemId);
  Future<Either<Failure, void>> submitOrder(Map<String, dynamic> orderData);
  Future<Either<Failure, void>> updateProductStock(String productId, int newStock); // ✅ اضافه شده
}

class CartRepository extends BaseRepository implements ICartRepository {
  final NetworkService _network;

  CartRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItems(String userId) {
    return safeCall<List<CartItemModel>>(
      request: () => _network.get('/cart?userId=$userId'),
      fromJson: (json) => (json as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
    );
  }

  @override
  Future<Either<Failure, CartItemModel>> addToCart(CartItemModel item) {
    return safeCall<CartItemModel>(
      request: () => _network.post('/cart', data: item.toJson()),
      fromJson: (json) => CartItemModel.fromJson(json),
    );
  }

  @override
  Future<Either<Failure, CartItemModel>> updateQuantity(String itemId, int quantity) {
    return safeCall<CartItemModel>(
      request: () => _network.patch('/cart/$itemId', data: {'quantity': quantity}),
      fromJson: (json) => CartItemModel.fromJson(json),
    );
  }

  @override
  Future<Either<Failure, void>> deleteItem(String itemId) {
    return safeCall<void>(
      request: () => _network.delete('/cart/$itemId'),
      fromJson: (_) {},
    );
  }

  @override
  Future<Either<Failure, void>> submitOrder(Map<String, dynamic> orderData) {
    return safeCall<void>(
      request: () => _network.post('/orders', data: orderData),
      fromJson: (_) {},
    );
  }

  @override
  Future<Either<Failure, void>> updateProductStock(String productId, int newStock) {
    return safeCall<void>(
      // ارسال درخواست PATCH برای تغییر فقط فیلد quantity
      request: () => _network.patch('/products/$productId', data: {'quantity': newStock}),
      fromJson: (_) {}, // خروجی مهم نیست
    );
  }

}