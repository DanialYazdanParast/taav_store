import 'package:example/src/commons/services/metadata_service.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/buyer/account/controllers/buyer_account_controller.dart';
import 'package:example/src/pages/buyer/products/controllers/buyer_products_controller.dart';
import 'package:example/src/pages/buyer/products/repository/buyer_products_repository.dart'; // 💡 مخزن خریدار
import 'package:example/src/pages/shared/repositories/metadata_repository.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';

class MainBuyerBinding extends Bindings {
  @override
  void dependencies() {
    // 💡 وابستگی مشترک NetworkService را پیدا می‌کنیم
    final network = Get.find<NetworkService>();

    // ─── ۱. ثبت مخازن (Repositories) ──────────────────────────────────────────

    // مخزن Metadata (اگر قبلاً در Global Binding ثبت نشده باشد، اینجا می‌آید)
    Get.lazyPut<IMetadataRepository>(
          () => MetadataRepository(network: network),
      fenix: true,
    );

    // 🔑 مخزن محصولات خریدار
    Get.lazyPut<IBuyerProductsRepository>(
          () => BuyerProductsRepository(network: network),
      fenix: true,
    );

    // 💡 (اگر BuyerAddRepository وجود داشته باشد، در اینجا اضافه می‌شود)

    // ─── ۲. ثبت سرویس‌های عمومی (Shared/Permanent Services) ────────────────────

    // سرویس Metadata: باید Permanent باشد تا داده‌های مشترک را نگه دارد.
    // اگر قبلاً در Global Binding ثبت شده است، این بخش اختیاری است و می‌توانید آن را حذف کنید.
    if (!Get.isRegistered<MetadataService>()) {
      Get.put(
        MetadataService(repository: Get.find<IMetadataRepository>()),
        permanent: true,
      );
    }

    // ─── ۳. ثبت کنترلرها (Controllers) ────────────────────────────────────────

    // کنترلر اصلی (MainBuyerController)
    Get.lazyPut<MainBuyerController>(() => MainBuyerController());

    // 🔑 کنترلر محصولات خریدار
    Get.lazyPut<BuyerProductsController>(
          () => BuyerProductsController(
        productRepo: Get.find<IBuyerProductsRepository>(), // تزریق مخزن خریدار
      ),
      fenix: true,
    );

    // کنترلر حساب کاربری خریدار
    Get.lazyPut<BuyerAccountController>(
          () => BuyerAccountController(),
      fenix: true,
    );
  }
}