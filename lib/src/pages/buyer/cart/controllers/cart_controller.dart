import 'package:taav_store/src/infrastructure/services/auth_service.dart';
import 'package:taav_store/src/pages/buyer/cart/models/cart_item_dto.dart';
import 'package:taav_store/src/pages/buyer/products/controllers/buyer_products_controller.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';
import 'package:taav_store/src/infrastructure/utils/toast_util.dart';
import 'package:taav_store/generated/locales.g.dart';

import '../../../shared/models/cart_item_model.dart';
import '../repository/cart_repository.dart';

class CartController extends GetxController {
  final ICartRepository _repo;
  final AuthService _authService = Get.find<AuthService>();

  CartController({required ICartRepository repo}) : _repo = repo;

  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final Rx<CurrentState> cartState = CurrentState.idle.obs;
  final Rx<CurrentState> cartCheckout = CurrentState.idle.obs;

  String get currentUserId => _authService.userId.value;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    cartState.value = CurrentState.loading;
    final result = await _repo.getCartItems(currentUserId);

    result.fold(
      (failure) {
        cartState.value = CurrentState.error;
      },
      (items) {
        cartItems.assignAll(items);
        cartState.value = CurrentState.success;
      },
    );
  }

  Future<void> addToCart(
    ProductModel product,
    int quantity,
    String colorHex,
  ) async {
    final existingItem = cartItems.firstWhereOrNull(
      (item) => item.productId == product.id && item.colorHex == colorHex,
    );

    if (existingItem != null && existingItem.id != null) {
      final newQty = existingItem.quantity + quantity;

      existingItem.quantity = newQty;
      cartItems.refresh();

      final result = await _repo.updateQuantity(existingItem.id!, newQty);
      result.fold((failure) {
        existingItem.quantity -= quantity;
        cartItems.refresh();

        ToastUtil.show(LocaleKeys.cartUpdateFailed.tr, type: ToastType.error);
      }, (_) => null);
    } else {
      int finalPrice =
          (product.discountPrice > 0 && product.discountPrice < product.price)
              ? product.discountPrice
              : product.price;

      final newItemDTO = CartItemDTO(
        productId: product.id,
        productTitle: product.title,
        productImage: product.image,
        sellerId: product.sellerId,
        userId: currentUserId,
        colorHex: colorHex,
        quantity: quantity,
        price: finalPrice,
        originalPrice: product.price,
        maxStock: product.quantity,
      );

      final result = await _repo.addToCart(newItemDTO);

      result.fold(
        (failure) {
          ToastUtil.show(LocaleKeys.addToCartFailed.tr, type: ToastType.error);
        },
        (addedItem) {
          cartItems.add(addedItem);
          ToastUtil.show(
            LocaleKeys.addedToCartSuccess.tr,
            type: ToastType.success,
          );
        },
      );
    }
  }

  Future<void> decrementItem(CartItemModel item) async {
    if (item.id == null) return;

    if (item.quantity > 1) {
      final newQty = item.quantity - 1;
      item.quantity = newQty;
      cartItems.refresh();

      final result = await _repo.updateQuantity(item.id!, newQty);
      result.fold((failure) {
        item.quantity += 1;
        cartItems.refresh();
      }, (_) => null);
    } else {
      final index = cartItems.indexOf(item);
      cartItems.remove(item);

      final result = await _repo.deleteItem(item.id!);

      result.fold((failure) {
        cartItems.insert(index, item);
        ToastUtil.show(LocaleKeys.itemDeleteFailed.tr, type: ToastType.error);
      }, (_) => null);
    }
  }

  Future<void> incrementItem(CartItemModel item) async {
    if (item.id == null) return;

    final newQty = item.quantity + 1;
    item.quantity = newQty;
    cartItems.refresh();

    final result = await _repo.updateQuantity(item.id!, newQty);

    result.fold((failure) {
      item.quantity -= 1;
      cartItems.refresh();
    }, (_) => null);
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) return;
    cartCheckout.value = CurrentState.loading;

    final orderData = {
      "buyerId": currentUserId,
      "totalPrice": totalPayablePrice,
      "date": DateTime.now().toIso8601String(),
      "items":
          cartItems
              .map(
                (item) => {
                  "productId": item.productId,
                  "productTitle": item.productTitle,
                  "sellerId": item.sellerId,
                  "color": item.colorHex,
                  "quantity": item.quantity,
                  "price": item.price,
                  "originalPrice": item.originalPrice,

                  "image": item.productImage,
                },
              )
              .toList(),
    };

    final result = await _repo.submitOrder(orderData);

    result.fold(
      (failure) {
        cartCheckout.value = CurrentState.error;
        ToastUtil.show(LocaleKeys.orderSubmitFailed.tr, type: ToastType.error);
      },
      (_) async {
        // 1. یک کپی از آیتم‌های سبد خرید بگیرید *قبل از پاکسازی*
        final List<CartItemModel> itemsToUpdateStock = List.from(cartItems);

        // 2. موجودی محصول را در دیتابیس به‌روز کنید
        await Future.wait(
          itemsToUpdateStock.map((item) {
            int newStock = item.maxStock - item.quantity;
            if (newStock < 0) newStock = 0;
            return _repo.updateProductStock(item.productId, newStock);
          }),
        );

        // 3. آیتم‌ها را از سبد خرید در دیتابیس حذف کنید
        for (var item in itemsToUpdateStock) {
          if (item.id != null) await _repo.deleteItem(item.id!);
        }

        cartItems.clear();

        final BuyerProductsController productsController =
            Get.find<BuyerProductsController>();
        for (var item in itemsToUpdateStock) {
          productsController.updateProductStockAfterCheckout(
            item.productId,
            item.quantity,
          );
        }

        final successMsg =
            '${LocaleKeys.orderSubmitSuccess.tr} ${LocaleKeys.stockUpdateSuccess.tr}';
        cartCheckout.value = CurrentState.success;
        ToastUtil.show(successMsg, type: ToastType.success);
      },
    );
  }

  // --- Getters & Helpers ---

  int get totalCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get totalOriginalPrice => cartItems.fold(
    0,
    (sum, item) => sum + (item.originalPrice * item.quantity),
  );

  int get totalPayablePrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get totalProfit => totalOriginalPrice - totalPayablePrice;

  bool get hasDiscount => totalProfit > 0;

  int getMaxAllowedQuantity(CartItemModel targetItem) {
    int totalUsedForThisProduct = cartItems
        .where((element) => element.productId == targetItem.productId)
        .fold(0, (sum, element) => sum + element.quantity);

    int remainingStock = targetItem.maxStock - totalUsedForThisProduct;
    int dynamicMax = targetItem.quantity + remainingStock;
    return dynamicMax > targetItem.quantity ? dynamicMax : targetItem.quantity;
  }
}
