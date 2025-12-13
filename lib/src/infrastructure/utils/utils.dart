import 'package:get/get.dart';

class AppUtils {
  AppUtils._();

  static void hideKeyboard() {
    if (Get.focusScope != null && Get.focusScope!.hasFocus) {
      Get.focusScope!.unfocus();
    }
  }

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
