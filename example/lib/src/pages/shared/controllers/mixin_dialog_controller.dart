import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/color_model.dart';
import '../models/tag_model.dart';

mixin MixinDialogController {
  // Tags
  RxList<TagModel> get availableTags;

  RxList<TagModel> get filteredTags;

  RxList<String> get selectedTagNames;

  TextEditingController get tagSearchController;

  RxString get tagQuery;

  RxBool get isAddingTag;

  bool get showAddButton;

  void onTagSearchChanged(String val);

  void selectTag(String tagName);

  void removeTag(String tagName);

  Future<void> addNewTag();

  // Colors
  RxList<ColorModel> get availableColors;

  RxList<String> get selectedColorNames;

  RxBool get isAddingColor;

  void toggleColor(String colorName);

  Future<void> addNewColor(String name, String hexCode);

  // Image
  Rx<XFile?> get selectedImage;

  void pickImageFromCamera();

  void pickImageFromGallery();

  void removeImage();
}