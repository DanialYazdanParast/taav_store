import 'package:either_dart/either.dart';
import 'package:taav_store/src/infrastructure/network/base_repository.dart';
import 'package:taav_store/src/infrastructure/network/failure.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/pages/shared/models/user_model.dart';
import 'package:get/get.dart';

abstract class ILoginRepository {
  Future<Either<Failure, UserModel>> login(String username, String password);
}

class LoginRepository extends BaseRepository implements ILoginRepository {
  final NetworkService _network;

  LoginRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, UserModel>> login(String username, String password) {
    return safeCall<UserModel>(
      request:
          () => _network.get(
            '/users',
            queryParameters: {'username': username, 'password': password},
          ),
      fromJson: (json) {
        if (json is List && json.isNotEmpty) {
          return UserModel.fromJson(json.first);
        }
        throw AppException(LocaleKeys.authInvalidCredentials.tr);
      },
    );
  }
}
