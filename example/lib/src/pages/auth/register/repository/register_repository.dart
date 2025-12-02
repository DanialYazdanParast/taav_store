import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/auth/register/models/dto.dart';
import 'package:example/src/pages/auth/register/models/user_model.dart';

abstract class IRegisterRepository {
  Future<Either<Failure, List<UserModel>>> getUsers();

  Future<Either<Failure, UserModel>> getUserById(String id);

  Future<Either<Failure, UserModel>> createUser(CreateUserDto user);
}

class RegisterRepository extends BaseRepository implements IRegisterRepository {
  final NetworkService _network;

  RegisterRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() {
    return safeCall<List<UserModel>>(
      request: () => _network.get('/users'),
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => UserModel.fromJson(e)).toList();
        }
        return <UserModel>[];
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(String id) {
    return safeCall<UserModel>(
      request: () => _network.get('/users/$id'),
      fromJson: (json) => UserModel.fromJson(json),
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
