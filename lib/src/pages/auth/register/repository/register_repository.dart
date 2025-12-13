import 'package:either_dart/either.dart';
import 'package:taav_store/src/infrastructure/network/failure.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';
import 'package:taav_store/src/infrastructure/network/base_repository.dart';
import 'package:taav_store/src/pages/auth/register/models/dto.dart';
import 'package:taav_store/src/pages/shared/models/user_model.dart';

abstract class IRegisterRepository {
  Future<Either<Failure, bool>> checkUserExists(String username);

  Future<Either<Failure, UserModel>> createUser(CreateUserDto user);
}

class RegisterRepository extends BaseRepository implements IRegisterRepository {
  final NetworkService _network;

  RegisterRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, bool>> checkUserExists(String username) {
    return safeCall<bool>(
      request:
          () => _network.get('/users', queryParameters: {'username': username}),
      fromJson: (json) {
        if (json is List) {
          return json.isNotEmpty;
        }
        return false;
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> createUser(CreateUserDto user) {
    return safeCall<UserModel>(
      request: () => _network.post('/users', data: user.toJson()),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }
}
