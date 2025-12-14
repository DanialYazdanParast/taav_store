import 'dart:math';
import 'package:taav_store/src/infrastructure/services/metadata_service.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/services/auth_service.dart';
import 'package:taav_store/src/infrastructure/utils/toast_util.dart';

import '../../../shared/models/product_model.dart';
import '../../../shared/models/color_model.dart';
import '../../../shared/models/tag_model.dart';
import '../repository/seller_products_repository.dart';

import 'package:taav_store/src/pages/seller/stats/repository/seller_stats_repository.dart';

class SellerProductsController extends GetxController {
  final ISellerProductsRepository productRepo;
  final ISellerStatsRepository statsRepo;
  final MetadataService metadataService = Get.find<MetadataService>();
  final AuthService _authService = Get.find<AuthService>();

  SellerProductsController({
    required this.productRepo,
    required this.statsRepo,
  });

  // ─── State Variables (Products List) ────────────────
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<CurrentState> productsState = CurrentState.idle.obs;

  // ─── State Variables (Statistics) ────────────────
  final RxInt totalSalesCount = 0.obs;
  final RxInt totalRevenueAmount = 0.obs;
  final Rx<CurrentState> statsState = CurrentState.idle.obs;

  final RxInt totalItemsInCart = 0.obs;
  final Rx<CurrentState> cartStatsState = CurrentState.idle.obs;

  // ─── Filter & Search Variables ───────────────────
  final RxList<ColorModel> availableColors = <ColorModel>[].obs;
  final RxList<TagModel> availableTags = <TagModel>[].obs;

  final RxDouble minPriceLimit = 0.0.obs;
  final RxDouble maxPriceLimit = 10000000.0.obs;

  final Rx<RangeValues> appliedPriceRange = const RangeValues(0, 10000000).obs;
  final RxList<String> appliedColorHexes = <String>[].obs;
  final RxList<String> appliedTagNames = <String>[].obs;
  final RxBool appliedOnlyAvailable = false.obs;

  final Rx<RangeValues> tempPriceRange = const RangeValues(0, 10000000).obs;
  final RxList<String> tempColorHexes = <String>[].obs;
  final RxList<String> tempTagNames = <String>[].obs;
  final RxBool tempOnlyAvailable = false.obs;

  final RxBool isSearching = false.obs;
  final RxString query = ''.obs;
  final RxBool isHidden = false.obs;

  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  Worker? _searchWorker;

  // ─── Lifecycle ─────────────────────
  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();

    ever(_authService.userId, (String? newId) {
      if (newId != null && newId.isNotEmpty) {
        products.clear();
        totalSalesCount.value = 0;
        totalRevenueAmount.value = 0;
        fetchProducts();
        fetchTotalStats();
        fetchInCartStats();
      }
    });

    searchController.addListener(() {
      query.value = searchController.text.trim().toLowerCase();
    });

    _searchWorker = debounce(query, (_) {
      if (query.value.isEmpty || query.value.length >= 3) {
        fetchProducts();
      }
    }, time: const Duration(milliseconds: 400));

    _syncFiltersWithService();

    fetchProducts();
    fetchTotalStats();
    fetchInCartStats();
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
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

  // ─── 1. Fetch Products Logic ──────────────────
  Future<void> fetchProducts() async {
    productsState.value = CurrentState.loading;

    final searchString = query.value.isNotEmpty ? query.value : null;

    final result = await productRepo.getSellerProducts(
      _authService.userId.value,
      query: searchString,
    );

    result.fold(
      (failure) {
        productsState.value = CurrentState.error;
        ToastUtil.show(failure.message, type: ToastType.error);
      },
      (fetchedProducts) {
        products.assignAll(fetchedProducts.reversed.toList());
        productsState.value = CurrentState.success;

        _calculateAndResetPriceLimits(fetchedProducts);
      },
    );
  }

  void _calculateAndResetPriceLimits(List<ProductModel> items) {
    if (items.isEmpty) {
      minPriceLimit.value = 0.0;
      maxPriceLimit.value = 10000000.0;
      appliedPriceRange.value = RangeValues(0.0, 10000000.0);
      tempPriceRange.value = RangeValues(0.0, 10000000.0);
      return;
    }

    final List<double> effectivePrices =
        items.map((p) {
          return (p.discountPrice > 0 && p.discountPrice < p.price)
              ? p.discountPrice.toDouble()
              : p.price.toDouble();
        }).toList();

    double minP = effectivePrices.reduce(min);
    double maxP = effectivePrices.reduce(max);

    if (minP == maxP) {
      minP = (minP - 10000 < 0) ? 0 : minP;
      maxP = maxP;
    }

    minPriceLimit.value = minP;
    maxPriceLimit.value = maxP;

    appliedPriceRange.value = RangeValues(minP, maxP);
    tempPriceRange.value = RangeValues(minP, maxP);
  }

  void recalculateAndResetFilters() {
    if (products.isEmpty) {
      minPriceLimit.value = 0.0;
      maxPriceLimit.value = 10000000.0;
      appliedPriceRange.value = RangeValues(0.0, 10000000.0);
      tempPriceRange.value = RangeValues(0.0, 10000000.0);
      return;
    }

    final List<double> effectivePrices =
        products.map((p) {
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

    appliedPriceRange.value = RangeValues(minP, maxP);
    tempPriceRange.value = RangeValues(minP, maxP);

    appliedColorHexes.clear();
    tempColorHexes.clear();
    appliedTagNames.clear();
    tempTagNames.clear();
    appliedOnlyAvailable.value = false;
    tempOnlyAvailable.value = false;
  }

  // ─── 2. Fetch Total Sales & Revenue Logic ───────────
  Future<void> fetchTotalStats() async {
    statsState.value = CurrentState.loading;
    final result = await statsRepo.getBestSellers(_authService.userId.value);

    result.fold(
      (failure) {
        statsState.value = CurrentState.error;
      },
      (statsList) {
        int totalQty = 0;
        int totalRev = 0;

        for (var item in statsList) {
          totalQty += item.totalQuantitySold;
          totalRev += item.totalRevenue;
        }

        totalSalesCount.value = totalQty;
        totalRevenueAmount.value = totalRev;

        statsState.value = CurrentState.success;
      },
    );
  }

  // ─── 3. Fetch Items in Customers' Carts Logic ───────────────────────────────
  Future<void> fetchInCartStats() async {
    cartStatsState.value = CurrentState.loading;
    final result = await productRepo.getCartItemsBySeller(
      _authService.userId.value,
    );

    result.fold(
      (failure) {
        cartStatsState.value = CurrentState.error;
      },
      (cartItems) {
        int count = cartItems.fold(0, (sum, item) => sum + item.quantity);

        totalItemsInCart.value = count;
        cartStatsState.value = CurrentState.success;
      },
    );
  }

  // ─── Actions (Delete) ───────────────────────────────────────────────────────
  Future<void> deleteProduct(String productId) async {
    final result = await productRepo.deleteProduct(productId);

    result.fold(
      (failure) {
        ToastUtil.show(failure.message, type: ToastType.error);
      },
      (success) {
        products.removeWhere((element) => element.id == productId);

        if (products.isNotEmpty) {
          recalculateAndResetFilters();
        } else {
          _calculateAndResetPriceLimits([]);
        }

        ToastUtil.show(
          LocaleKeys.productDeletedSuccessfully.tr,
          type: ToastType.success,
        );
        if (Get.isDialogOpen == true) Get.back();
      },
    );
  }

  // ─── Filter Logic ──────────────────────────────────────────────

  void calculatePriceLimits(List<ProductModel> items) {
    _calculateAndResetPriceLimits(items);
  }

  void initTempFilters() {
    tempPriceRange.value = appliedPriceRange.value;
    tempColorHexes.assignAll(appliedColorHexes);
    tempTagNames.assignAll(appliedTagNames);
    tempOnlyAvailable.value = appliedOnlyAvailable.value;
  }

  void applyFilters() {
    appliedPriceRange.value = tempPriceRange.value;
    appliedColorHexes.assignAll(tempColorHexes);
    appliedTagNames.assignAll(tempTagNames);
    appliedOnlyAvailable.value = tempOnlyAvailable.value;
    Get.back();
  }

  void clearTempFilters() {
    tempPriceRange.value = RangeValues(
      minPriceLimit.value,
      maxPriceLimit.value,
    );

    tempColorHexes.clear();
    tempTagNames.clear();
    tempOnlyAvailable.value = false;
  }

  void clearAllFilters() {
    final fullMin = minPriceLimit.value;
    final fullMax = maxPriceLimit.value;

    tempPriceRange.value = RangeValues(fullMin, fullMax);
    appliedPriceRange.value = RangeValues(fullMin, fullMax);

    appliedColorHexes.clear();
    tempColorHexes.clear();
    appliedTagNames.clear();
    tempTagNames.clear();
    appliedOnlyAvailable.value = false;
    tempOnlyAvailable.value = false;
  }

  void updateTempPriceRange(RangeValues values) =>
      tempPriceRange.value = values;

  void toggleTempColor(String colorHex) {
    if (tempColorHexes.contains(colorHex)) {
      tempColorHexes.remove(colorHex);
    } else {
      tempColorHexes.add(colorHex);
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

    if (appliedColorHexes.isNotEmpty) {
      result =
          result.where((p) {
            return appliedColorHexes.every(
              (selectedHex) => p.colors.contains(selectedHex),
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
    count += tempColorHexes.length;
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
    count += appliedColorHexes.length;
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
      query.value = '';

      _resetNonPriceFilters();

      fetchProducts();
    }
  }

  void toggleVisibility() => isHidden.value = !isHidden.value;

  void closeSearch() {
    if (isSearching.value) {
      isSearching.value = false;
      searchController.clear();
      query.value = '';
      searchFocusNode.unfocus();

      _resetNonPriceFilters();

      fetchProducts();
    }
  }

  void _resetNonPriceFilters() {
    appliedColorHexes.clear();
    tempColorHexes.clear();
    appliedTagNames.clear();
    tempTagNames.clear();
    appliedOnlyAvailable.value = false;
    tempOnlyAvailable.value = false;
  }
}
