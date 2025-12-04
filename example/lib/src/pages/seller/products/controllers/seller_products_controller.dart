import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../repository/seller_products_repository.dart';

class SellerProductsController extends GetxController {
  final ISellerProductsRepository repository;

  SellerProductsController({required this.repository});

  final AuthService _authService = Get.find<AuthService>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<CurrentState> productsState = CurrentState.idle.obs;

  final RxBool isSearching = false.obs;
  final RxString query = ''.obs;

  final RxBool isHidden = false.obs;

  late TextEditingController searchController;
  late FocusNode searchFocusNode;

  @override
  void onInit() {
    super.onInit();

    searchController = TextEditingController();
    searchFocusNode = FocusNode();

    searchController.addListener(() {
      query.value = searchController.text.trim().toLowerCase();
    });

    debounce(query, (_) {}, time: Duration(milliseconds: 250));

    fetchProducts();
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
        searchFocusNode.requestFocus();
      });
    } else {
      searchController.clear();
      searchFocusNode.unfocus();
    }
  }

  Future<void> fetchProducts() async {
    productsState.value = CurrentState.loading;

    await Future.delayed(const Duration(milliseconds: 1000));

    final result = await repository.getSellerProducts(
      _authService.userId.value,
    );

    result.fold(
      (failure) {
        productsState.value = CurrentState.error;
        ToastUtil.show(
          failure.message ?? 'خطا در دریافت محصولات',
          type: ToastType.error,
        );
      },
      (fetchedProducts) {
        products.assignAll(fetchedProducts);
        productsState.value = CurrentState.success;
      },
    );
  }

  List<ProductModel> get filteredProducts {
    if (query.isEmpty) {
      return products;
    }

    final lowerQuery = query.value.toLowerCase();

    return products.where((product) {
      final matchesTitle = product.title.toLowerCase().contains(lowerQuery);

      final matchesTags = product.tags.any((tagId) {
        return tagId.toLowerCase().contains(lowerQuery);
      });

      return matchesTitle || matchesTags;
    }).toList();
  }

  void toggleVisibility() => isHidden.value = !isHidden.value;
}
