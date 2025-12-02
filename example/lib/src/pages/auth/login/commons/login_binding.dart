import 'package:get/get.dart';

import '../controllers/login_controllr.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginControllr());
  }
}
