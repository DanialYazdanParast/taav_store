// فایل: src/pages/buyer/orders/repository/order_repository.dart

import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import '../models/order_model.dart';

abstract class IOrderRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders(String userId);
}

class OrderRepository extends BaseRepository implements IOrderRepository {
  final NetworkService _network;

  OrderRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders(String userId) {
    return safeCall<List<OrderModel>>(
      request: () => _network.get('/orders?buyerId=$userId'),
      fromJson:
          (json) =>
              (json as List).map((item) => OrderModel.fromJson(item)).toList(),
    );
  }
}
