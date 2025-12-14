import 'package:taav_store/src/infrastructure/utils/toast_util.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';
import 'package:taav_store/src/pages/buyer/cart/controllers/cart_controller.dart';
import 'package:taav_store/generated/locales.g.dart'; // Import added
import '../repository/buyer_product_details_repository.dart';

class BuyerProductDetailsController extends GetxController {
  final IBuyerProductDetailsRepository detailsRepo;
  final CartController cartController = Get.find<CartController>();

  BuyerProductDetailsController({required this.detailsRepo});

  String? productId;
  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final Rx<CurrentState> productState = CurrentState.idle.obs;
  final RxString selectedColor = ''.obs;

  @override
  void onInit() {
    final routeParams = Get.parameters;
    productId = routeParams['id'];

    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      productId = args;
    }

    if (productId == null || productId!.isEmpty) {
      ToastUtil.show(LocaleKeys.invalidProductId.tr, type: ToastType.error);
      Get.offNamed(AppRoutes.buyer);
      return;
    }

    super.onInit();

    if (productId != null) fetchProductDetails(productId!);
  }

  Future<void> fetchProductDetails(String productId) async {
    productState.value = CurrentState.loading;
    final result = await detailsRepo.getProductById(productId);
    result.fold(
      (failure) {
        productState.value = CurrentState.error;
        ToastUtil.show(
          LocaleKeys.fetchProductDetailsError.tr,
          type: ToastType.error,
        );
      },
      (fetchedProduct) {
        product.value = fetchedProduct;
        productState.value = CurrentState.success;
        if (fetchedProduct.colors.isNotEmpty) {
          selectedColor.value = fetchedProduct.colors.first;
        }
      },
    );
  }

  void selectColor(String colorHex) => selectedColor.value = colorHex;

  int get quantityInCartForSelectedColor {
    if (product.value == null) return 0;

    final item = cartController.cartItems.firstWhereOrNull(
      (element) =>
          element.productId == product.value!.id &&
          element.colorHex == selectedColor.value,
    );
    return item?.quantity ?? 0;
  }

  int get totalQuantityInCartForThisProduct {
    if (product.value == null) return 0;

    return cartController.cartItems
        .where((element) => element.productId == product.value!.id)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  int get remainingStock {
    if (product.value == null) return 0;
    return product.value!.quantity - totalQuantityInCartForThisProduct;
  }

  void onAddOrIncrease() {
    if (product.value == null) return;

    if (totalQuantityInCartForThisProduct < product.value!.quantity) {
      cartController.addToCart(product.value!, 1, selectedColor.value);
    } else {
      ToastUtil.show(
        LocaleKeys.stockFinishedWarning.tr,
        type: ToastType.warning,
      );
    }
  }

  void onDecrease() {
    if (product.value == null) return;

    final item = cartController.cartItems.firstWhereOrNull(
      (element) =>
          element.productId == product.value!.id &&
          element.colorHex == selectedColor.value,
    );

    if (item != null) {
      cartController.decrementItem(item);
    }
  }

  double get effectivePrice {
    if (product.value == null) return 0;
    return (product.value!.discountPrice > 0 &&
            product.value!.discountPrice < product.value!.price)
        ? product.value!.discountPrice.toDouble()
        : product.value!.price.toDouble();
  }

  int get discountPercentage {
    if (!hasDiscount || product.value == null) return 0;
    return ((product.value!.price - product.value!.discountPrice) /
            product.value!.price *
            100)
        .round();
  }

  bool get hasDiscount =>
      product.value != null &&
      product.value!.discountPrice > 0 &&
      product.value!.discountPrice < product.value!.price;

  bool get isAvailable =>
      product.value != null &&
      product.value!.quantity > 0 &&
      remainingStock > 0;
}
