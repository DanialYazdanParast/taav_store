import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:taav_store/src/infrastructure/network/failure.dart';
import 'package:taav_store/src/infrastructure/network/base_repository.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';

abstract class ISellerAddRepository {
  Future<Either<Failure, ProductModel>> addProduct(FormData data);
}

class SellerAddRepository extends BaseRepository
    implements ISellerAddRepository {
  final NetworkService _network;

  SellerAddRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, ProductModel>> addProduct(FormData data) {
    return safeCall<ProductModel>(
      request: () => _network.post('/products', data: data),
      fromJson: (json) {
        return ProductModel.fromJson(json);
      },
    );
  }
}
