import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/utils/toast_util.dart';

import '../models/product_model.dart';
import '../models/color_model.dart';
import '../models/tag_model.dart';
import '../repository/seller_products_repository.dart';

class SellerProductsController extends GetxController {
  final ISellerProductsRepository repository;

  SellerProductsController({required this.repository});

  final AuthService _authService = Get.find<AuthService>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<CurrentState> productsState = CurrentState.idle.obs;

  final RxList<ColorModel> availableColors = <ColorModel>[].obs;
  final RxList<TagModel> availableTags = <TagModel>[].obs;

  final RxDouble minPriceLimit = 0.0.obs;
  final RxDouble maxPriceLimit = 10000000.0.obs;

  final Rx<RangeValues> appliedPriceRange = const RangeValues(0, 10000000).obs;
  final RxList<String> appliedColorNames = <String>[].obs;
  final RxList<String> appliedTagNames = <String>[].obs;
  final RxBool appliedOnlyAvailable = false.obs;

  final Rx<RangeValues> tempPriceRange = const RangeValues(0, 10000000).obs;
  final RxList<String> tempColorNames = <String>[].obs;
  final RxList<String> tempTagNames = <String>[].obs;
  final RxBool tempOnlyAvailable = false.obs;

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

    debounce(query, (_) {}, time: const Duration(milliseconds: 250));

    fetchProducts();
    fetchFilterOptions();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchProducts() async {
    productsState.value = CurrentState.loading;

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
        _calculatePriceLimits(fetchedProducts);
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    final result = await repository.deleteProduct(productId);

    result.fold(
      (failure) {
        ToastUtil.show(
          failure.message ?? 'خطا در حذف محصول',
          type: ToastType.error,
        );
      },
      (success) {
        products.removeWhere((element) => element.id == productId);

        if (products.isEmpty) {
        } else {
          _calculatePriceLimits(products);
        }

        ToastUtil.show('محصول با موفقیت حذف شد', type: ToastType.success);

        if (Get.isDialogOpen == true) {
          Get.back();
        }
      },
    );
  }

  void _calculatePriceLimits(List<ProductModel> items) {
    if (items.isNotEmpty) {
      final List<double> effectivePrices =
          items.map((p) {
            return (p.discountPrice > 0 && p.discountPrice < p.price)
                ? p.discountPrice.toDouble()
                : p.price.toDouble();
          }).toList();

      double minP = effectivePrices.reduce(min);
      double maxP = effectivePrices.reduce(max);

      if (minP == maxP) {
        minP = (minP - 10000 < 0) ? 0 : minP - 10000;
        maxP = maxP + 10000;
      }

      minPriceLimit.value = minP;
      maxPriceLimit.value = maxP;

      if (appliedPriceRange.value.start < minP ||
          appliedPriceRange.value.end > maxP) {
        appliedPriceRange.value = RangeValues(minP, maxP);
        tempPriceRange.value = RangeValues(minP, maxP);
      }
    }
  }

  Future<void> fetchFilterOptions() async {
    final colorsResult = await repository.getColors();
    colorsResult.fold((l) {}, (r) => availableColors.assignAll(r));

    final tagsResult = await repository.getTags();
    tagsResult.fold((l) {}, (r) => availableTags.assignAll(r));
  }

  void initTempFilters() {
    tempPriceRange.value = appliedPriceRange.value;
    tempColorNames.assignAll(appliedColorNames);
    tempTagNames.assignAll(appliedTagNames);
    tempOnlyAvailable.value = appliedOnlyAvailable.value;
  }

  void applyFilters() {
    appliedPriceRange.value = tempPriceRange.value;
    appliedColorNames.assignAll(tempColorNames);
    appliedTagNames.assignAll(tempTagNames);
    appliedOnlyAvailable.value = tempOnlyAvailable.value;

    Get.back();
  }

  void clearTempFilters() {
    tempPriceRange.value = RangeValues(
      minPriceLimit.value,
      maxPriceLimit.value,
    );
    tempColorNames.clear();
    tempTagNames.clear();
    tempOnlyAvailable.value = false;
  }

  void clearAllFilters() {
    clearTempFilters();

    appliedPriceRange.value = RangeValues(
      minPriceLimit.value,
      maxPriceLimit.value,
    );
    appliedColorNames.clear();
    appliedTagNames.clear();
    appliedOnlyAvailable.value = false;
  }

  void updateTempPriceRange(RangeValues values) {
    tempPriceRange.value = values;
  }

  void toggleTempColor(String colorName) {
    if (tempColorNames.contains(colorName)) {
      tempColorNames.remove(colorName);
    } else {
      tempColorNames.add(colorName);
    }
  }

  void toggleTempTag(String tagName) {
    if (tempTagNames.contains(tagName)) {
      tempTagNames.remove(tagName);
    } else {
      tempTagNames.add(tagName);
    }
  }

  List<ProductModel> get filteredProducts {
    List<ProductModel> result = products.toList();

    if (query.value.isNotEmpty) {
      final lowerQuery = query.value.toLowerCase();
      result =
          result.where((p) {
            final matchesTitle = p.title.toLowerCase().contains(lowerQuery);
            final matchesTags = p.tags.any(
              (tag) => tag.toLowerCase().contains(lowerQuery),
            );
            return matchesTitle || matchesTags;
          }).toList();
    }

    result =
        result.where((p) {
          final effectivePrice =
              (p.discountPrice > 0 && p.discountPrice < p.price)
                  ? p.discountPrice
                  : p.price;
          return effectivePrice >= appliedPriceRange.value.start &&
              effectivePrice <= appliedPriceRange.value.end;
        }).toList();

    if (appliedOnlyAvailable.value) {
      result = result.where((p) => p.quantity > 0).toList();
    }

    if (appliedColorNames.isNotEmpty) {
      result =
          result.where((p) {
            return appliedColorNames.every(
              (selectedColor) => p.colors.contains(selectedColor),
            );
          }).toList();
    }

    if (appliedTagNames.isNotEmpty) {
      result =
          result.where((p) {
            return appliedTagNames.every(
              (selectedTag) => p.tags.contains(selectedTag),
            );
          }).toList();
    }

    return result;
  }

  int get totalTempFilters {
    int count = 0;
    bool isPriceChanged =
        (tempPriceRange.value.start - minPriceLimit.value).abs() > 1 ||
        (maxPriceLimit.value - tempPriceRange.value.end).abs() > 1;

    if (isPriceChanged) count++;
    count += tempColorNames.length;
    count += tempTagNames.length;
    if (tempOnlyAvailable.value) count++;

    return count;
  }

  int get totalAppliedFilters {
    int count = 0;

    bool isPriceChanged =
        (appliedPriceRange.value.start - minPriceLimit.value).abs() > 1 ||
        (maxPriceLimit.value - appliedPriceRange.value.end).abs() > 1;

    if (isPriceChanged) count++;
    count += appliedColorNames.length;
    count += appliedTagNames.length;
    if (appliedOnlyAvailable.value) count++;

    return count;
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

  void toggleVisibility() => isHidden.value = !isHidden.value;
}
