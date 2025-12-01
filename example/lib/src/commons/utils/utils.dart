import 'package:get/get.dart';

class AppUtils {
  // جلوگیری از نمونه‌سازی
  AppUtils._();

  /// بستن کیبورد (به روش ایمن)
  static void hideKeyboard() {
    if (Get.focusScope != null && Get.focusScope!.hasFocus) {
      Get.focusScope!.unfocus();
    }
  }

  /// بستن دیالوگ باز (اگر وجود داشته باشد)
  static void closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }
}
