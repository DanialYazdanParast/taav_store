import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/text/app_text_field.dart';
import 'package:taav_store/src/infrastructure/utils/input/validation_util.dart';

class ProductInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final FocusNode titleFocus;
  final FocusNode descFocus;
  final AutovalidateMode autoValidateMode;

  const ProductInfoSection({
    super.key,
    required this.titleController,
    required this.descController,
    required this.titleFocus,
    required this.descFocus,
    required this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hintText: TKeys.productTitleHint.tr,
          controller: titleController,
          prefixWidget: const Icon(Icons.shopping_bag_outlined, size: 20),
          maxLength: 60,
          validator:
              (value) => ValidationUtil().requiredField(
                value,
                TKeys.productTitleLabel.tr,
              ),
          autoValidateMode: autoValidateMode,
          focusNode: titleFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted:
              (_) => FocusScope.of(context).requestFocus(descFocus),
        ),
        AppSize.p16.height,
        AppTextField(
          hintText: TKeys.productDescHint.tr,
          controller: descController,
          minLines: 4,
          maxLines: 6,
          keyboardType: TextInputType.multiline,
          contentPadding: const EdgeInsets.all(AppSize.p16),
          maxLength: 500,
          validator:
              (value) => ValidationUtil().requiredField(
                value,
                TKeys.productDescLabel.tr,
              ),
          autoValidateMode: autoValidateMode,
          focusNode: descFocus,
        ),
      ],
    );
  }
}
