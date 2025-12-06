import 'dart:convert';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/pages/seller/main/controllers/main_seller_controller.dart';
import 'package:example/src/pages/shared/controllers/mixin_dialog_controller.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:example/src/commons/utils/toast_util.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/shared/models/color_model.dart';
import 'package:example/src/pages/shared/models/tag_model.dart';
import 'package:example/src/pages/shared/repositories/metadata_repository.dart';

import '../repository/seller_add_repository.dart';

class SellerAddProductController extends GetxController
    with MixinDialogController {
  // ─── Dependencies ────────────────────────────────────────────────────────────
  final ISellerAddRepository addRepo;
  final IMetadataRepository metadataRepo;
  final AuthService _authService = Get.find<AuthService>();

  SellerAddProductController({
    required this.addRepo,
    required this.metadataRepo,
  });

  // ─── Text Controllers & Focus Nodes ──────────────────────────────────────────
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
  late Rx<AutovalidateMode> avmAdd;

  // ─── State Management ────────────────────────────────────────────────────────
  // Replaces isLoadingPage
  final Rx<CurrentState> pageState = CurrentState.idle.obs;
  // Replaces isSubmitting
  final Rx<CurrentState> submitState = CurrentState.idle.obs;

  // ─── Image Handling ──────────────────────────────────────────────────────────
  @override
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  // ─── Color Logic ─────────────────────────────────────────────────────────────
  @override
  final RxList<ColorModel> availableColors = <ColorModel>[].obs;
  @override
  final RxList<String> selectedColorNames = <String>[].obs;
  @override
  final RxBool isAddingColor = false.obs;

  // ─── Tag Logic ───────────────────────────────────────────────────────────────
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

  // ─── Lifecycle Methods ───────────────────────────────────────────────────────
  @override
  void onInit() {
    avmAdd = AutovalidateMode.disabled.obs;
    _initControllers();
    super.onInit();
    fetchInitialData();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  // ─── Helper Methods ──────────────────────────────────────────────────────────
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

  // ─── Data Fetching ───────────────────────────────────────────────────────────
  Future<void> fetchInitialData() async {
    pageState.value = CurrentState.loading;


    try {
      await Future.wait([_getColors(), _getTags()]);
      pageState.value = CurrentState.success;
    } catch (e) {
      pageState.value = CurrentState.error;
      ToastUtil.show("خطا در دریافت اطلاعات اولیه", type: ToastType.error);
    }
  }

  Future<void> _getColors() async {
    final result = await metadataRepo.getColors();
    result.fold(
          (failure) {
        ToastUtil.show("خطا در بارگذاری رنگ‌ها", type: ToastType.error);
      },
          (data) => availableColors.assignAll(data),
    );
  }

  Future<void> _getTags() async {
    final result = await metadataRepo.getTags();
    result.fold(
          (failure) =>
          ToastUtil.show("خطا در بارگذاری تگ‌ها", type: ToastType.error),
          (data) {
        availableTags.assignAll(data);
        filteredTags.clear();
      },
    );
  }

  // ─── Image Logic ─────────────────────────────────────────────────────────────
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
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        ToastUtil.show("دسترسی لازم داده نشد", type: ToastType.warning);
      } else {
        ToastUtil.show("خطا در انتخاب تصویر", type: ToastType.error);
      }
    }
  }

  @override
  void removeImage() => selectedImage.value = null;

  // ─── Color Logic ─────────────────────────────────────────────────────────────
  @override
  void toggleColor(String colorName) {
    if (selectedColorNames.contains(colorName)) {
      selectedColorNames.remove(colorName);
    } else {
      selectedColorNames.add(colorName);
    }
  }

  @override
  Future<void> addNewColor(String name, String hexCode) async {
    isAddingColor.value = true;
    final cleanHex = hexCode.replaceAll('#', '');

    final result = await metadataRepo.createNewColor(name, cleanHex);

    result.fold(
          (failure) => ToastUtil.show("خطا در افزودن رنگ", type: ToastType.error),
          (newColor) {
        availableColors.add(newColor);
        toggleColor(newColor.name);
        Get.back();
      },
    );
    isAddingColor.value = false;
  }

  // ─── Tag Logic ───────────────────────────────────────────────────────────────
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
    final result = await metadataRepo.createNewTag(newTagName);

    result.fold(
          (failure) => ToastUtil.show("خطا در ایجاد تگ", type: ToastType.error),
          (newTag) {
        availableTags.add(newTag);
        selectTag(newTag.name);
        ToastUtil.show("تگ جدید اضافه شد", type: ToastType.success);

        tagSearchController.clear();
        tagQuery.value = '';
        filteredTags.clear();
      },
    );
    isAddingTag.value = false;
  }

  // ─── Submit Logic ────────────────────────────────────────────────────────────
  Future<void> submitProduct() async {
    if (submitState.value == CurrentState.loading) return;

    if (!formKey.currentState!.validate()) {
      avmAdd.value = AutovalidateMode.always;
      ToastUtil.show("لطفا خطاهای فرم را برطرف کنید", type: ToastType.warning);
      return;
    }

    if (selectedImage.value == null) {
      ToastUtil.show(
        "لطفا یک تصویر برای محصول انتخاب کنید",
        type: ToastType.warning,
      );
      return;
    }

    submitState.value = CurrentState.loading;

    try {
      final cleanPrice = priceController.text.replaceAll(',', '');
      final cleanCount = countController.text.replaceAll(',', '');
      String cleanDiscount;
      if (discountPriceController.text.trim().isEmpty) {
        cleanDiscount = cleanPrice;
      } else {
        cleanDiscount = discountPriceController.text.replaceAll(',', '');
      }

      final formData = dio.FormData.fromMap({
        'title': titleController.text,
        'description': descController.text,
        'price': int.tryParse(cleanPrice) ?? 0,
        'quantity': int.tryParse(cleanCount) ?? 0,
        'discountPrice': int.tryParse(cleanDiscount) ?? 0,
        'sellerId': _authService.userId.value,
        'colors': jsonEncode(selectedColorNames),
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
          ToastUtil.show(
            failure.message ?? "خطا در ثبت محصول",
            type: ToastType.error,
          );
        },
            (newProduct) {
          submitState.value = CurrentState.success;
          ToastUtil.show("محصول با موفقیت ثبت شد", type: ToastType.success);
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
      ToastUtil.show("خطای غیرمنتظره رخ داد", type: ToastType.error);
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
    selectedColorNames.clear();
    selectedTagNames.clear();
    filteredTags.clear();
    tagQuery.value = '';

    formKey.currentState?.reset();
    avmAdd.value = AutovalidateMode.disabled;

    submitState.value = CurrentState.idle;

  }

  void _updateMainListLocally(dynamic newProduct) {
    if (Get.isRegistered<SellerProductsController>()) {
      final productsController = Get.find<SellerProductsController>();
      productsController.products.insert(0, newProduct);
      productsController.calculatePriceLimits(productsController.products);
      productsController.fetchFilterOptions();
    }
  }
}