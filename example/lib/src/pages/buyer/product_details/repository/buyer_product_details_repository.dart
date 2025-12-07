
import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/shared/models/product_model.dart';

abstract class IBuyerProductDetailsRepository {
  Future<Either<Failure, ProductModel>> getProductById(String productId);
}

class BuyerProductDetailsRepository extends BaseRepository
    implements IBuyerProductDetailsRepository {
  final NetworkService _network;

  BuyerProductDetailsRepository({required NetworkService network})
      : _network = network;

  @override
  Future<Either<Failure, ProductModel>> getProductById(String productId) {
    return safeCall<ProductModel>(
      request: () => _network.get('/products/$productId'),
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }
}