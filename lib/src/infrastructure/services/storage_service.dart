import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  T? read<T>(final String key) {
    return _box.read<T>(key);
  }

  void write(final String key, final dynamic value) {
    _box.write(key, value);
  }

  void remove(final String key) {
    _box.remove(key);
  }

  void clearAll() {
    _box.erase();
  }
}
