import 'package:either_dart/either.dart';
import 'package:taav_store/src/commons/models/failure.dart';
import 'package:taav_store/src/commons/services/base_repository.dart';
import 'package:taav_store/src/commons/services/network_service.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';
import 'package:taav_store/src/pages/shared/models/cart_item_model.dart';

abstract class ISellerProductsRepository {
  Future<Either<Failure, List<ProductModel>>> getSellerProducts(
    String sellerId, {
    String? query,
  });

  Future<Either<Failure, void>> deleteProduct(String productId);

  Future<Either<Failure, List<CartItemModel>>> getCartItemsBySeller(
    String sellerId,
  );
}

class SellerProductsRepository extends BaseRepository
    implements ISellerProductsRepository {
  final NetworkService _network;

  SellerProductsRepository({required NetworkService network})
    : _network = network;

  @override
  Future<Either<Failure, List<ProductModel>>> getSellerProducts(
    String sellerId, {
    String? query,
  }) {
    final Map<String, dynamic> params = {'sellerId': sellerId};

    if (query != null && query.isNotEmpty) {
      params['q'] = query;
    }

    return safeCall<List<ProductModel>>(
      request: () => _network.get('/products', queryParameters: params),
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => ProductModel.fromJson(e)).toList();
        }
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

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItemsBySeller(
    String sellerId,
  ) {
    return safeCall<List<CartItemModel>>(
      request:
          () => _network.get('/cart', queryParameters: {'sellerId': sellerId}),
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => CartItemModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }
}
