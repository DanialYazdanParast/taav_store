import 'package:example/src/commons/constants/storage_keys.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:get/get.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  late StorageService _storage;

  final RxBool rememberMe = false.obs;
  final RxString username = ''.obs;
  final RxString userType = ''.obs;
  final RxString userId = ''.obs;

  Future<AuthService> init() async {
    _storage = Get.find<StorageService>();

    rememberMe.value = _storage.read(StorageKeys.rememberMe) ?? false;
    username.value = _storage.read(StorageKeys.username) ?? '';
    userType.value = _storage.read(StorageKeys.userType) ?? '';
    userId.value = _storage.read(StorageKeys.userId) ?? '';

    return this;
  }

  void saveUserData({
    required bool remember,
    required String uname,
    required String id,
    required String type,
  }) {
    rememberMe.value = remember;
    username.value = uname;
    userId.value = id;
    userType.value = type;

    _storage.write(StorageKeys.rememberMe, remember);
    _storage.write(StorageKeys.username, uname);
    _storage.write(StorageKeys.userId, id);
    _storage.write(StorageKeys.userType, type);
  }

  void logout() {
    _storage.remove(StorageKeys.rememberMe);
    _storage.remove(StorageKeys.username);
    _storage.remove(StorageKeys.userId);
    _storage.remove(StorageKeys.userType);

    rememberMe.value = false;
    username.value = '';
    userType.value = '';
    userId.value = '';

    Get.offAllNamed(AppRoutes.login);
  }
}
