import 'package:either_dart/either.dart';
import 'package:taav_store/src/infrastructure/network/failure.dart';
import 'package:taav_store/src/infrastructure/network/base_repository.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';

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
