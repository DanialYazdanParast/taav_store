import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/auth/register/models/user_model.dart';

abstract class ILoginRepository {
  Future<Either<Failure, UserModel>> login(String username, String password);
}

class LoginRepository extends BaseRepository implements ILoginRepository {
  final NetworkService _network;

  LoginRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, UserModel>> login(String username, String password) {
    return safeCall<UserModel>(
      request: () => _network.get(
        '/users',
        queryParameters: {
          'username': username,
          'password': password,
        },
      ),
      fromJson: (json) {
        if (json is List && json.isNotEmpty) {
          return UserModel.fromJson(json.first);
        }
       throw AppException('نام کاربری یا رمز عبور اشتباه است');
      },
    );
  }

}
