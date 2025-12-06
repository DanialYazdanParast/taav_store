import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';

import 'package:example/src/pages/shared/models/product_model.dart';

abstract class IBuyerProductsRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
}

class BuyerProductsRepository extends BaseRepository
    implements IBuyerProductsRepository {
  final NetworkService _network;

  BuyerProductsRepository({required NetworkService network})
    : _network = network;

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() {
    return safeCall<List<ProductModel>>(
      request: () => _network.get('/products'),
      fromJson: (json) {
        if (json is List)
          return json.map((e) => ProductModel.fromJson(e)).toList();
        return [];
      },
    );
  }
}
