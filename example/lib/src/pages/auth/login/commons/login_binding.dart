import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../repository/login_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ILoginRepository>(
      () => LoginRepository(network: Get.find<NetworkService>()),
    );

    Get.lazyPut<LoginController>(
      () => LoginController(
        loginRepository: Get.find<ILoginRepository>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
