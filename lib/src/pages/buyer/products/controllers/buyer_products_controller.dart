import 'dart:math';
import 'package:taav_store/src/commons/services/metadata_service.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/buyer/cart/controllers/cart_controller.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/commons/enums/enums.dart';
import 'package:taav_store/src/commons/utils/toast_util.dart';

import '../../../shared/models/color_model.dart';
import '../../../shared/models/tag_model.dart';
import '../repository/buyer_products_repository.dart';

class BuyerProductsController extends GetxController {
  final IBuyerProductsRepository productRepo;
  final MetadataService metadataService = Get.find<MetadataService>();

  BuyerProductsController({required this.productRepo});

  late final CartController cartController;

  // ─── State Variables ───────────────
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final Rx<CurrentState> productsState = CurrentState.idle.obs;

  final RxList<ColorModel> availableColors = <ColorModel>[].obs;
  final RxList<TagModel> availableTags = <TagModel>[].obs;

  // ─── Color Selection for Each Product ───────────────
  final RxMap<String, String> selectedColorsMap = <String, String>{}.obs;

  // ─── Filter Logic Variables ──────────────
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

  // ─── Search Variables ─────────────────
  final RxBool isSearching = false.obs;
  final RxString query = ''.obs;

  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    cartController = Get.find<CartController>();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();

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

  Future<void> fetchProducts() async {
    productsState.value = CurrentState.loading;

    final searchString = query.value.isNotEmpty ? query.value : '';

    final result = await productRepo.getAllProducts(query: searchString);

    result.fold(
      (failure) {
        productsState.value = CurrentState.error;
        ToastUtil.show(failure.message, type: ToastType.error);
      },
      (fetchedProducts) {
        products.assignAll(fetchedProducts.reversed.toList());
        productsState.value = CurrentState.success;

        _calculateAndResetPriceLimits(fetchedProducts);

        _initializeProductColors(fetchedProducts);
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

  // ─── Initialize Colors for Products ─────────
  void _initializeProductColors(List<ProductModel> fetchedProducts) {
    for (var product in fetchedProducts) {
      if (product.colors.isNotEmpty &&
          !selectedColorsMap.containsKey(product.id)) {
        selectedColorsMap[product.id] = product.colors.first;
      }
    }
  }

  // ─── Product Card Logic ─────────
  String getSelectedColor(String productId, List<String> colors) {
    if (colors.isEmpty) return '';
    return selectedColorsMap[productId] ?? colors.first;
  }

  void initializeProductColor(String productId, List<String> colors) {
    if (colors.isNotEmpty && !selectedColorsMap.containsKey(productId)) {
      selectedColorsMap[productId] = colors.first;
    }
  }

  void selectColorForProduct(String productId, String colorHex) {
    selectedColorsMap[productId] = colorHex;
  }

  int getTotalQuantityInCart(String productId) {
    return cartController.cartItems
        .where((item) => item.productId == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  int getRemainingStock(String productId, int productQuantity) {
    return productQuantity - getTotalQuantityInCart(productId);
  }

  int getCurrentQuantityForSelectedColor(
    String productId,
    List<String> colors,
  ) {
    if (colors.isEmpty) {
      return getTotalQuantityInCart(productId);
    }

    final selectedColor = getSelectedColor(productId, colors);

    final item = cartController.cartItems.firstWhereOrNull(
      (element) =>
          element.productId == productId && element.colorHex == selectedColor,
    );
    return item?.quantity ?? 0;
  }

  String getAddToCartButtonLabel(int productQuantity, int remainingStock) {
    if (productQuantity == 0) {
      return TKeys.outOfStock.tr;
    } else if (remainingStock <= 0) {
      return TKeys.soldOut.tr;
    }
    return TKeys.addToCart.tr;
  }

  bool isAddToCartDisabled(int productQuantity, int remainingStock) {
    return productQuantity == 0 || remainingStock <= 0;
  }

  void addProductToCart(
    ProductModel product,
    String selectedColor,
    int totalQuantityInCart,
  ) {
    if (totalQuantityInCart < product.quantity) {
      cartController.addToCart(product, 1, selectedColor);
    } else {
      ToastUtil.show(TKeys.stockFinishedWarning.tr, type: ToastType.warning);
    }
  }

  void decreaseProductFromCart(String productId, String selectedColor) {
    final item = cartController.cartItems.firstWhereOrNull(
      (element) =>
          element.productId == productId && element.colorHex == selectedColor,
    );
    if (item != null) {
      cartController.decrementItem(item);
    }
  }

  void updateProductStockAfterCheckout(
    String productId,
    int purchasedQuantity,
  ) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final oldProduct = products[index];
    final newQty = (oldProduct.quantity - purchasedQuantity).clamp(0, 1 << 31);
    final updatedProduct = oldProduct.copyWith(quantity: newQty);
    products[index] = updatedProduct;
  }

  // ─── Filter Logic ─────────

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
      query.value = '';

      _resetNonPriceFilters();

      fetchProducts();
    }
  }

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
