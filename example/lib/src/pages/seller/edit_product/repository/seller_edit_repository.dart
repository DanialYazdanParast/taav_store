import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/shared/models/product_model.dart';

abstract class ISellerEditRepository {
  Future<Either<Failure, ProductModel>> updateProduct(String id, FormData data);

  Future<Either<Failure, ProductModel>> getProduct(String id);
}

class SellerEditRepository extends BaseRepository implements ISellerEditRepository {
  final NetworkService _network;

  SellerEditRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, ProductModel>> updateProduct(String id, FormData data) {
    return safeCall<ProductModel>(
      request: () => _network.put('/products/$id', data: data),
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }

  @override
  Future<Either<Failure, ProductModel>> getProduct(String id) {
    return safeCall<ProductModel>(
      request: () => _network.get('/products/$id'),
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }
}