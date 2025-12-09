import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/shared/models/order_model.dart';

import '../models/seller_sales_stat_model.dart';

abstract class ISellerStatsRepository {
  Future<Either<Failure, List<SellerSalesStatModel>>> getBestSellers(
      String sellerId,
      );
}

class SellerStatsRepository extends BaseRepository
    implements ISellerStatsRepository {
  final NetworkService _network;

  SellerStatsRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, List<SellerSalesStatModel>>> getBestSellers(
      String sellerId,
      ) {
    return safeCall<List<SellerSalesStatModel>>(
      request: () => _network.get('/orders'),

      fromJson: (json) {
        final allOrders =
        (json as List).map((e) => OrderModel.fromJson(e)).toList();

        final Map<String, SellerSalesStatModel> aggregatedMap = {};

        for (var order in allOrders) {
          for (var item in order.items) {

            if (item.sellerId != sellerId) continue;

            if (aggregatedMap.containsKey(item.productId)) {
              final existing = aggregatedMap[item.productId]!;
              aggregatedMap[item.productId] = SellerSalesStatModel(
                productId: existing.productId,
                title: existing.title,
                image: existing.image,
                totalQuantitySold: existing.totalQuantitySold + item.quantity,
                totalRevenue:
                existing.totalRevenue + (item.price * item.quantity),
              );
            } else {
              aggregatedMap[item.productId] = SellerSalesStatModel(
                productId: item.productId,
                title: item.productTitle,
                image: item.image,
                totalQuantitySold: item.quantity,
                totalRevenue: item.price * item.quantity,
              );
            }
          }
        }

        final resultList = aggregatedMap.values.toList();

        // مرتب‌سازی بر اساس بیشترین تعداد فروش
        resultList.sort(
              (a, b) => b.totalQuantitySold.compareTo(a.totalQuantitySold),
        );

        return resultList;
      },
    );
  }
}