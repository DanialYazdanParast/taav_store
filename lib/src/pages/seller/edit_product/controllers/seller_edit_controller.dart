import 'dart:convert';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import 'package:taav_store/src/infrastructure/services/auth_service.dart';
import 'package:taav_store/src/infrastructure/services/metadata_service.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';
import 'package:taav_store/src/pages/shared/controllers/mixin_dialog_controller.dart';
import 'package:taav_store/src/infrastructure/utils/toast_util.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:taav_store/src/pages/shared/models/color_model.dart';
import 'package:taav_store/src/pages/shared/models/tag_model.dart';

import '../repository/seller_edit_repository.dart';

class SellerEditController extends GetxController with MixinDialogController {
  final ISellerEditRepository editRepo;
  final AuthService _authService = Get.find<AuthService>();
  final MetadataService metadataService = Get.find<MetadataService>();

  ProductModel? product;
  String? productId;

  SellerEditController({required this.editRepo});

  // ─── Text Controllers ──────────────────
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController countController;
  late TextEditingController priceController;
  late TextEditingController discountPriceController;
  @override
  late TextEditingController tagSearchController;

  late FocusNode titleFocus;
  late FocusNode descFocus;
  late FocusNode priceFocus;
  late FocusNode countFocus;
  late FocusNode discountFocus;
  late FocusNode tagSearchFocusNode;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Rx<AutovalidateMode> avmEdit;

  // ─── State ────────────────────────
  final Rx<CurrentState> pageState = CurrentState.idle.obs;
  final Rx<CurrentState> submitState = CurrentState.idle.obs;

  // ─── Image & Metadata ───────
  @override
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  final RxList<ColorModel> availableColors = <ColorModel>[].obs;
  @override
  final RxList<String> selectedColor = <String>[].obs;
  @override
  final RxBool isAddingColor = false.obs;

  @override
  final RxList<TagModel> availableTags = <TagModel>[].obs;
  @override
  final RxList<TagModel> filteredTags = <TagModel>[].obs;
  @override
  final RxList<String> selectedTagNames = <String>[].obs;

  @override
  final RxString tagQuery = ''.obs;
  @override
  final RxBool isAddingTag = false.obs;

  final RxBool isImageDeleted = false.obs;

  @override
  bool get showAddButton {
    if (tagQuery.value.isEmpty) return false;
    return !availableTags.any(
      (tag) => tag.name.toLowerCase() == tagQuery.value.toLowerCase(),
    );
  }

  final ScrollController leftScrollController = ScrollController();
  // ─── Lifecycle ─────────────────────────
  @override
  void onInit() {
    avmEdit = AutovalidateMode.disabled.obs;
    _initControllers();

    final routeParams = Get.parameters;
    productId = routeParams['id'];

    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      productId = args;
    }

    if (productId == null || productId!.isEmpty) {
      ToastUtil.show(LocaleKeys.invalidProductId.tr, type: ToastType.error);
      Get.offNamed(AppRoutes.seller);
      return;
    }

    super.onInit();
    _syncWithMetadataService();
    fetchInitialData();
  }

  @override
  void onClose() {
    leftScrollController.dispose();
    _disposeControllers();
    super.onClose();
  }

  void _syncWithMetadataService() {
    try {
      availableColors.assignAll(metadataService.colors);
      availableTags.assignAll(metadataService.tags);
      ever(metadataService.colors, (data) => availableColors.assignAll(data));
      ever(metadataService.tags, (data) => availableTags.assignAll(data));
    } catch (e) {
      debugPrint("Error syncing metadata: $e");
    }
  }

  // ─── Initialization Logic ──────────────
  void _initControllers() {
    titleController = TextEditingController();
    descController = TextEditingController();
    countController = TextEditingController();
    priceController = TextEditingController();
    discountPriceController = TextEditingController();
    tagSearchController = TextEditingController();

    titleFocus = FocusNode();
    descFocus = FocusNode();
    priceFocus = FocusNode();
    countFocus = FocusNode();
    discountFocus = FocusNode();
    tagSearchFocusNode = FocusNode();
  }

  void _disposeControllers() {
    titleController.dispose();
    descController.dispose();
    countController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    tagSearchController.dispose();

    titleFocus.dispose();
    descFocus.dispose();
    priceFocus.dispose();
    countFocus.dispose();
    discountFocus.dispose();
    tagSearchFocusNode.dispose();
  }

  Future<void> fetchInitialData() async {
    pageState.value = CurrentState.loading;
    try {
      if (productId != null) {
        final result = await editRepo.getProduct(productId!);

        if (result.isLeft) {
          throw Exception(result.left.message);
        }
        product = result.right;
      }

      if (product == null) {
        throw Exception("Product data not found");
      }

      _populateFormFields();

      pageState.value = CurrentState.success;
    } catch (e) {
      debugPrint("Error fetching data: $e");
      pageState.value = CurrentState.error;
      ToastUtil.show(LocaleKeys.errorFetchingProduct.tr, type: ToastType.error);
    }
  }

  void _populateFormFields() {
    if (product == null) return;

    titleController.text = product!.title;
    descController.text = product!.description;
    countController.text = product!.quantity.toString();

    final price = product!.price;
    final discount = product!.discountPrice;

    priceController.text = price.toString();

    if (price == discount || discount == 0) {
      discountPriceController.text = '';
    } else {
      discountPriceController.text = discount.toString();
    }

    selectedColor.assignAll(product!.colors);
    selectedTagNames.assignAll(product!.tags);
  }

  // ─── Image Actions ─────────────────────
  @override
  void pickImageFromCamera() => _pickImage(ImageSource.camera);

  @override
  void pickImageFromGallery() => _pickImage(ImageSource.gallery);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 75,
      );
      if (image != null) {
        selectedImage.value = image;
        isImageDeleted.value = false;
      }
    } catch (e) {
      ToastUtil.show(LocaleKeys.errorSelectingImage.tr, type: ToastType.error);
    }
  }

  @override
  void removeImage() {
    selectedImage.value = null;
    isImageDeleted.value = true;
  }

  // ─── Color & Tag Actions ─────────────────
  @override
  void toggleColor(String hexCode) {
    if (selectedColor.contains(hexCode)) {
      selectedColor.remove(hexCode);
    } else {
      selectedColor.add(hexCode);
    }
  }

  @override
  Future<void> addNewColor(String name, String hexCode) async {
    isAddingColor.value = true;
    final cleanHex = hexCode.replaceAll('#', '');

    try {
      final success = await metadataService.addNewColor(name, cleanHex);
      if (success) {
        toggleColor(cleanHex);
        Get.back();
      }
    } catch (e) {
      ToastUtil.show(LocaleKeys.errorAddingColor.tr, type: ToastType.error);
    } finally {
      isAddingColor.value = false;
    }
  }

  @override
  void onTagSearchChanged(String val) {
    tagQuery.value = val.trim();
    if (tagQuery.value.isEmpty) {
      filteredTags.clear();
    } else {
      filteredTags.assignAll(
        availableTags
            .where(
              (tag) =>
                  tag.name.toLowerCase().contains(tagQuery.value.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  @override
  void selectTag(String tagName) {
    if (!selectedTagNames.contains(tagName)) selectedTagNames.add(tagName);
  }

  @override
  void removeTag(String tagName) => selectedTagNames.remove(tagName);

  @override
  Future<void> addNewTag() async {
    final newTagName = tagQuery.value.trim();
    if (newTagName.isEmpty) return;

    isAddingTag.value = true;

    try {
      final success = await metadataService.addNewTag(newTagName);
      if (success && metadataService.tags.isNotEmpty) {
        final newTag = metadataService.tags.last;
        selectTag(newTag.name);

        ToastUtil.show(LocaleKeys.newTagAdded.tr, type: ToastType.success);

        tagSearchController.clear();
        tagQuery.value = '';
        filteredTags.clear();
      }
    } catch (e) {
      ToastUtil.show(LocaleKeys.errorAddingTag.tr, type: ToastType.error);
    } finally {
      isAddingTag.value = false;
    }
  }

  // ─── Update Product ─────────────────────────────────────
  Future<void> updateProduct() async {
    if (submitState.value == CurrentState.loading) return;

    if (!formKey.currentState!.validate()) {
      avmEdit.value = AutovalidateMode.always;
      ToastUtil.show(
        LocaleKeys.pleaseFixFormErrors.tr,
        type: ToastType.warning,
      );
      return;
    }

    if (selectedImage.value == null &&
        (isImageDeleted.value || product?.image == null)) {
      ToastUtil.show(
        LocaleKeys.productImageRequired.tr,
        type: ToastType.warning,
      );
      return;
    }

    submitState.value = CurrentState.loading;

    try {
      final cleanPrice = priceController.text.replaceAll(',', '');
      final cleanCount = countController.text.replaceAll(',', '');
      final cleanDiscount =
          discountPriceController.text.trim().isEmpty
              ? cleanPrice
              : discountPriceController.text.replaceAll(',', '');

      final Map<String, dynamic> mapData = {
        'title': titleController.text,
        'description': descController.text,
        'price': int.tryParse(cleanPrice) ?? 0,
        'quantity': int.tryParse(cleanCount) ?? 0,
        'discountPrice': int.tryParse(cleanDiscount) ?? 0,
        'sellerId': _authService.userId.value,
        'colors': jsonEncode(selectedColor),
        'tags': jsonEncode(selectedTagNames),
      };

      if (selectedImage.value != null) {
        mapData['image'] =
            kIsWeb
                ? dio.MultipartFile.fromBytes(
                  await selectedImage.value!.readAsBytes(),
                  filename: selectedImage.value!.name,
                )
                : await dio.MultipartFile.fromFile(
                  selectedImage.value!.path,
                  filename: selectedImage.value!.name,
                );
      }

      final formData = dio.FormData.fromMap(mapData);

      final result = await editRepo.updateProduct(product!.id, formData);

      result.fold(
        (failure) {
          submitState.value = CurrentState.error;
          ToastUtil.show(failure.message, type: ToastType.error);
        },
        (updatedProduct) {
          submitState.value = CurrentState.success;
          ToastUtil.show(
            LocaleKeys.productUpdatedSuccessfully.tr,
            type: ToastType.success,
          );

          _updateMainListLocally(updatedProduct);
          Get.offAllNamed(AppRoutes.sellerProducts);
        },
      );
    } catch (e) {
      submitState.value = CurrentState.error;
      ToastUtil.show(LocaleKeys.unexpectedError.tr, type: ToastType.error);
    } finally {
      if (submitState.value != CurrentState.success) {
        submitState.value = CurrentState.idle;
      }
    }
  }

  void _updateMainListLocally(ProductModel updatedProduct) {
    if (Get.isRegistered<SellerProductsController>()) {
      final productsController = Get.find<SellerProductsController>();
      final index = productsController.products.indexWhere(
        (p) => p.id == updatedProduct.id,
      );
      if (index != -1) {
        productsController.products[index] = updatedProduct;
        productsController.products.refresh();
        productsController.clearAllFilters();
      }
    }
  }
}
