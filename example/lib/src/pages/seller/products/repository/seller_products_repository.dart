import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';

import '../models/color_model.dart';
import '../models/product_model.dart';
import '../models/tag_model.dart';

abstract class ISellerProductsRepository {
  Future<Either<Failure, List<ProductModel>>> getSellerProducts(String sellerId);
  Future<Either<Failure, List<ColorModel>>> getColors();
  Future<Either<Failure, List<TagModel>>> getTags();
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
        throw AppException('هیچ محصولی پیدا نشد');
      },
    );
  }

  @override
  Future<Either<Failure, List<ColorModel>>> getColors() {
    return safeCall<List<ColorModel>>(
      request: () => _network.get('/colors'),
      fromJson: (json) {
        if (json is List) return json.map((e) => ColorModel.fromJson(e)).toList();
        return [];
      },
    );
  }

  @override
  Future<Either<Failure, List<TagModel>>> getTags() {
    return safeCall<List<TagModel>>(
      request: () => _network.get('/tags'),
      fromJson: (json) {
        if (json is List) return json.map((e) => TagModel.fromJson(e)).toList();
        return [];
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) {
    return safeCall<void>(
      request: () => _network.delete('/products/$productId'),
      fromJson: (_) {
        return;
      },
    );
  }
}