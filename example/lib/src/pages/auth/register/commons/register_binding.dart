
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../repository/register_repository.dart';
import 'package:example/src/commons/services/network_service.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<IRegisterRepository>(
      () => RegisterRepository(network: Get.find<NetworkService>()),
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(
        registerRepository: Get.find<IRegisterRepository>(),
      ),
    );
  }
}
