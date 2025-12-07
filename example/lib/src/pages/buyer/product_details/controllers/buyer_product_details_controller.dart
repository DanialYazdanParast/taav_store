import 'package:example/src/commons/enums/enums.dart';
import 'package:get/get.dart';
import 'package:example/src/pages/shared/models/product_model.dart';
import '../repository/buyer_product_details_repository.dart';

class BuyerProductDetailsController extends GetxController {
  final IBuyerProductDetailsRepository detailsRepo;
  BuyerProductDetailsController({required this.detailsRepo});

  // ─── State Variables ───────────────────────────────────────────────────────
  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final Rx<CurrentState> productState = CurrentState.idle.obs;


  final RxInt selectedQuantity = 0.obs;
  final RxInt totalCartCount = 2.obs;

  final RxString selectedColor = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final String? productId = Get.arguments as String?;
    if (productId != null) {
      fetchProductDetails(productId);
    }
  }

  Future<void> fetchProductDetails(String productId) async {
    productState.value = CurrentState.loading;
    final result = await detailsRepo.getProductById(productId);
    result.fold(
          (failure) => productState.value = CurrentState.error,
          (fetchedProduct) {
        product.value = fetchedProduct;
        productState.value = CurrentState.success;

        if (fetchedProduct.colors.isNotEmpty) {
          selectedColor.value = fetchedProduct.colors.first;
        }

        selectedQuantity.value = 0;
      },
    );
  }

  void increaseQuantity() {
    final currentProduct = product.value;
    if (currentProduct != null && selectedQuantity.value < currentProduct.quantity) {
      selectedQuantity.value++;
      totalCartCount.value++;
    }
  }

  void decreaseQuantity() {
    if (selectedQuantity.value > 0) {
      selectedQuantity.value--;
      if(totalCartCount.value > 0) totalCartCount.value--;
    }
  }

  // متد انتخاب رنگ
  void selectColor(String colorHex) => selectedColor.value = colorHex;

  // ویژگی‌های محاسباتی
  double get effectivePrice {
    if (product.value == null) return 0;
    return (product.value!.discountPrice > 0 && product.value!.discountPrice < product.value!.price)
        ? product.value!.discountPrice.toDouble()
        : product.value!.price.toDouble();
  }

  bool get hasDiscount => product.value != null && product.value!.discountPrice > 0;

  int get discountPercentage {
    if (!hasDiscount || product.value == null) return 0;
    return ((product.value!.price - product.value!.discountPrice) / product.value!.price * 100).round();
  }

  bool get isAvailable => product.value != null && product.value!.quantity > 0;
}