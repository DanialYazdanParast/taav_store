import 'dart:convert';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:taav_store/src/infrastructure/services/auth_service.dart';
import 'package:taav_store/src/infrastructure/services/metadata_service.dart';
import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:taav_store/src/pages/seller/main/controllers/main_seller_controller.dart';
import 'package:taav_store/src/pages/shared/models/product_model.dart';
import 'package:taav_store/src/pages/shared/controllers/mixin_dialog_controller.dart';
import 'package:taav_store/src/infrastructure/utils/toast_util.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:taav_store/src/pages/shared/models/color_model.dart';
import 'package:taav_store/src/pages/shared/models/tag_model.dart';
import '../repository/seller_add_repository.dart';

class SellerAddProductController extends GetxController
    with MixinDialogController {
  final ISellerAddRepository addRepo;

  AuthService get _authService => Get.find<AuthService>();

  MetadataService get metadataService => Get.find<MetadataService>();

  SellerAddProductController({required this.addRepo});

  // ─── Text Controllers ────────────────────────────────────────────────────────
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

  //  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Rx<AutovalidateMode> avmAdd;

  // ─── State Management ──────────────────
  final Rx<CurrentState> pageState = CurrentState.idle.obs;
  final Rx<CurrentState> submitState = CurrentState.idle.obs;

  // ─── Image Handling ───────────────────────
  @override
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  // ─── Color Logic ────────────────────────────
  @override
  final RxList<ColorModel> availableColors = <ColorModel>[].obs;
  @override
  final RxList<String> selectedColor = <String>[].obs;
  @override
  final RxBool isAddingColor = false.obs;

  // ─── Tag Logic ────────────────────────
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

  @override
  bool get showAddButton {
    if (tagQuery.value.isEmpty) return false;
    return !availableTags.any(
      (tag) => tag.name.toLowerCase() == tagQuery.value.toLowerCase(),
    );
  }

  final ScrollController leftScrollController = ScrollController();

  // ─── Lifecycle Methods ─────────────────────
  @override
  void onInit() {
    avmAdd = AutovalidateMode.disabled.obs;
    _initControllers();
    super.onInit();
    _syncWithMetadataService();
  }

  @override
  void onClose() {
    leftScrollController.dispose();
    //  _disposeControllers();
    super.onClose();
  }

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

  // void _disposeControllers() {
  //   titleController.dispose();
  //   descController.dispose();
  //   countController.dispose();
  //   priceController.dispose();
  //   discountPriceController.dispose();
  //   tagSearchController.dispose();
  //
  //   titleFocus.dispose();
  //   descFocus.dispose();
  //   priceFocus.dispose();
  //   countFocus.dispose();
  //   discountFocus.dispose();
  //   tagSearchFocusNode.dispose();
  // }

  void _syncWithMetadataService() {
    try {
      pageState.value = CurrentState.loading;

      if (!Get.isRegistered<MetadataService>()) {
        debugPrint("Warning: MetadataService not found.");
        pageState.value = CurrentState.success;
        return;
      }

      availableColors.assignAll(metadataService.colors);
      availableTags.assignAll(metadataService.tags);

      ever(metadataService.colors, (data) => availableColors.assignAll(data));
      ever(metadataService.tags, (data) => availableTags.assignAll(data));

      pageState.value = CurrentState.success;
    } catch (e) {
      debugPrint("Error syncing metadata: $e");
      pageState.value = CurrentState.error;
    }
  }

  // ─── Image Logic ───────────────────────────
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
      if (image != null) selectedImage.value = image;
    } catch (e) {
      if (e.toString().contains('permission')) {
        ToastUtil.show(TKeys.permissionDenied.tr, type: ToastType.warning);
      } else {
        ToastUtil.show(TKeys.errorSelectingImage.tr, type: ToastType.error);
      }
    }
  }

  @override
  void removeImage() => selectedImage.value = null;

  // ─── Color Logic ───────────────────────────
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
      ToastUtil.show(TKeys.errorAddingColor.tr, type: ToastType.error);
    } finally {
      isAddingColor.value = false;
    }
  }

  // ─── Tag Logic ─────────────────────────────────────────────────────────────
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
    if (!selectedTagNames.contains(tagName)) {
      selectedTagNames.add(tagName);
    }
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

        ToastUtil.show(TKeys.newTagAdded.tr, type: ToastType.success);

        tagSearchController.clear();
        tagQuery.value = '';
        filteredTags.clear();
      }
    } catch (e) {
      ToastUtil.show(TKeys.errorAddingTag.tr, type: ToastType.error);
    } finally {
      isAddingTag.value = false;
    }
  }

  // ─── Submit Logic ────────────────────────
  Future<void> submitProduct(GlobalKey<FormState> formKey) async {
    if (submitState.value == CurrentState.loading) return;

    if (!formKey.currentState!.validate()) {
      avmAdd.value = AutovalidateMode.always;
      ToastUtil.show(TKeys.pleaseFixFormErrors.tr, type: ToastType.warning);
      return;
    }

    if (selectedImage.value == null) {
      ToastUtil.show(
        TKeys.pleaseSelectProductImage.tr,
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

      final formData = dio.FormData.fromMap({
        'title': titleController.text,
        'description': descController.text,
        'price': int.tryParse(cleanPrice) ?? 0,
        'quantity': int.tryParse(cleanCount) ?? 0,
        'discountPrice': int.tryParse(cleanDiscount) ?? 0,
        'sellerId': _authService.userId.value,
        'colors': jsonEncode(selectedColor),
        'tags': jsonEncode(selectedTagNames),
        'image':
            kIsWeb
                ? dio.MultipartFile.fromBytes(
                  await selectedImage.value!.readAsBytes(),
                  filename: selectedImage.value!.name,
                )
                : await dio.MultipartFile.fromFile(
                  selectedImage.value!.path,
                  filename: selectedImage.value!.name,
                ),
      });

      final result = await addRepo.addProduct(formData);

      result.fold(
        (failure) {
          submitState.value = CurrentState.error;
          ToastUtil.show(failure.message, type: ToastType.error);
        },
        (newProduct) {
          submitState.value = CurrentState.success;
          ToastUtil.show(
            TKeys.productAddedSuccessfully.tr,
            type: ToastType.success,
          );

          _updateMainListLocally(newProduct);

          if (Responsive.isDesktop) {
            _resetForm();
            if (Get.isRegistered<MainSellerController>()) {
              Get.find<MainSellerController>().changeTab(0);
            }
          } else {
            Get.back();
          }
        },
      );
    } catch (e) {
      submitState.value = CurrentState.error;
      debugPrint("Submit Error: $e");
      ToastUtil.show(TKeys.unexpectedError.tr, type: ToastType.error);
    } finally {
      if (submitState.value != CurrentState.success) {
        submitState.value = CurrentState.idle;
      }
    }
  }

  void _resetForm() {
    titleController.clear();
    descController.clear();
    countController.clear();
    priceController.clear();
    discountPriceController.clear();
    tagSearchController.clear();
    selectedImage.value = null;
    selectedColor.clear();
    selectedTagNames.clear();
    filteredTags.clear();
    tagQuery.value = '';
    // formKey.currentState?.reset();
    // avmAdd.value = AutovalidateMode.disabled;
    // submitState.value = CurrentState.idle;
  }

  void _updateMainListLocally(ProductModel newProduct) {
    if (Get.isRegistered<SellerProductsController>()) {
      final productsCtrl = Get.find<SellerProductsController>();
      productsCtrl.products.insert(0, newProduct);
      productsCtrl.calculatePriceLimits(productsCtrl.products);
      productsCtrl.clearAllFilters();
    }
  }
}
