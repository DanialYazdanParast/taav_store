
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerProductsController extends GetxController {

  var isSearching = false.obs;


  late TextEditingController searchController;
  late FocusNode searchFocusNode;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;

    if (isSearching.value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!searchFocusNode.hasPrimaryFocus) {
          searchFocusNode.requestFocus();
        }
      });
    } else {
      searchController.clear();
      searchFocusNode.unfocus();
    }
  }

  void deleteProduct(int index) {
    Get.snackbar(
      'حذف محصول',
      'محصول شماره $index حذف شد',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void editProduct(int index) {
    // لاجیک ویرایش
  }
}