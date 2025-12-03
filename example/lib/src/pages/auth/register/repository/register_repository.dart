import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/auth/register/models/dto.dart';
import 'package:example/src/pages/auth/register/models/user_model.dart';

abstract class IRegisterRepository {
  Future<Either<Failure, UserModel>> createUser(CreateUserDto user);

  Future<Either<Failure, bool>> checkUserExists(String username);
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
