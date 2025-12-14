import 'package:either_dart/either.dart';
import 'package:taav_store/src/infrastructure/network/failure.dart';
import 'package:taav_store/src/infrastructure/network/base_repository.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';
import '../models/edit_product_dto.dart';

abstract class ISellerEditRepository {
  Future<Either<Failure, ProductModel>> updateProduct(String id, EditProductDto dto);

  Future<Either<Failure, ProductModel>> getProduct(String id);
}

class SellerEditRepository extends BaseRepository implements ISellerEditRepository {
  final NetworkService _network;

  SellerEditRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, ProductModel>> updateProduct(String id, EditProductDto dto) {
    return safeCall<ProductModel>(
      request: () => _network.put('/products/$id', data: dto.toJson()),
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