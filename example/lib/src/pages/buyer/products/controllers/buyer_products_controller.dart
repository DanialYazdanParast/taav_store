import 'dart:math';
import 'package:example/src/commons/services/metadata_service.dart';
import 'package:example/src/pages/shared/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/utils/toast_util.dart';

import '../../../shared/models/color_model.dart';
import '../../../shared/models/tag_model.dart';
import '../repository/buyer_products_repository.dart';

class BuyerProductsController extends GetxController {
  final IBuyerProductsRepository productRepo;

  final MetadataService metadataService = Get.find<MetadataService>();

  BuyerProductsController({required this.productRepo});

  // ─── State Variables ───────────────
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<CurrentState> productsState = CurrentState.idle.obs;

  final RxList<ColorModel> availableColors = <ColorModel>[].obs;
  final RxList<TagModel> availableTags = <TagModel>[].obs;

  // ─── Filter Logic Variables ──────────────
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

  // ─── Search Variables ─────────────────
  final RxBool isSearching = false.obs;
  final RxString query = ''.obs;

  late TextEditingController searchController;
  late FocusNode searchFocusNode;

  // ─── Lifecycle ────────────────────
  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();

    searchController.addListener(() {
      query.value = searchController.text.trim().toLowerCase();
    });

    debounce(query, (_) {}, time: const Duration(milliseconds: 250));

    _syncFiltersWithService();

    fetchProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void _syncFiltersWithService() {
    availableColors.assignAll(metadataService.colors);
    availableTags.assignAll(metadataService.tags);
    ever(metadataService.colors, (data) => availableColors.assignAll(data));
    ever(metadataService.tags, (data) => availableTags.assignAll(data));
  }

  Future<void> fetchProducts() async {
    productsState.value = CurrentState.loading;
    final result = await productRepo.getAllProducts();
    result.fold(
      (failure) {
        productsState.value = CurrentState.error;
        ToastUtil.show(
          failure.message,
          type: ToastType.error,
        );
      },
      (fetchedProducts) {
        products.assignAll(fetchedProducts.reversed.toList());
        productsState.value = CurrentState.success;
        calculatePriceLimits(products);
      },
    );
  }

  // ─── Filter Logic  ─────────
  void calculatePriceLimits(List<ProductModel> items) {
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

  void updateTempPriceRange(RangeValues values) =>
      tempPriceRange.value = values;

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
            return appliedColorNames.any(
              (selectedColor) => p.colors.contains(selectedColor),
            );
          }).toList();
    }

    if (appliedTagNames.isNotEmpty) {
      result =
          result.where((p) {
            return appliedTagNames.any(
              (selectedTag) => p.tags.contains(selectedTag),
            );
          }).toList();
    }

    return result;
  }

  // ─── Filter Count Logic ─────────────

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

  // ─── UI Actions ──────────────────────────────

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

  void closeSearch() {
    if (isSearching.value) {
      isSearching.value = false;
      searchController.clear();
      query.value = '';
      searchFocusNode.unfocus();
    }
  }
}
