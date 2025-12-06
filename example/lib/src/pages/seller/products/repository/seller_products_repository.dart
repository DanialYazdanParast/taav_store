// src/pages/seller/products/repository/seller_products_repository.dart

import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/seller/products/models/product_model.dart';

abstract class ISellerProductsRepository {
  Future<Either<Failure, List<ProductModel>>> getSellerProducts(String sellerId);
  Future<Either<Failure, void>> deleteProduct(String productId);
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

}