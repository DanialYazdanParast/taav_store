import 'package:either_dart/either.dart';
import 'package:taav_store/src/infrastructure/network/failure.dart';
import 'package:taav_store/src/infrastructure/network/base_repository.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';

import 'package:taav_store/src/pages/shared/models/product_model.dart';

abstract class IBuyerProductsRepository {
  Future<Either<Failure, List<ProductModel>>> getAllProducts({String? query});
}

class BuyerProductsRepository extends BaseRepository
    implements IBuyerProductsRepository {
  final NetworkService _network;

  BuyerProductsRepository({required NetworkService network})
    : _network = network;

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts({String? query}) {
    final Map<String, dynamic> params = {};
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
}
