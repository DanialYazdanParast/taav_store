import 'package:taav_store/src/commons/utils/formatters/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:taav_store/src/commons/constants/app_size.dart';
import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/commons/widgets/text/app_text_field.dart';
import 'package:taav_store/src/commons/utils/input/validation_util.dart';

class ProductPricingSection extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController countController;
  final TextEditingController discountController;
  final FocusNode priceFocus;
  final FocusNode countFocus;
  final FocusNode discountFocus;
  final AutovalidateMode autoValidateMode;

  const ProductPricingSection({
    super.key,
    required this.priceController,
    required this.countController,
    required this.discountController,
    required this.priceFocus,
    required this.countFocus,
    required this.discountFocus,
    required this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: AppTextField(
                hintText: TKeys.priceTomanHint.tr,
                controller: priceController,
                keyboardType: TextInputType.number,
                prefixWidget: const Icon(Icons.attach_money_rounded, size: 20),
                maxLength: 15,
                counterText: '',
                inputFormatters: [ThousandsFormatter()],
                validator:
                    (value) =>
                        ValidationUtil().number(value, TKeys.priceLabel.tr),
                autoValidateMode: autoValidateMode,
                focusNode: priceFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted:
                    (_) => FocusScope.of(context).requestFocus(countFocus),
              ),
            ),
            AppSize.p12.width,
            Expanded(
              flex: 1,
              child: AppTextField(
                hintText: TKeys.quantity.tr,
                controller: countController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 5,
                counterText: '',
                inputFormatters: [ThousandsFormatter()],
                validator:
                    (value) =>
                        ValidationUtil().number(value, TKeys.quantity.tr),
                autoValidateMode: autoValidateMode,
                focusNode: countFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted:
                    (_) => FocusScope.of(context).requestFocus(discountFocus),
              ),
            ),
          ],
        ),
        AppSize.p16.height,
        AppTextField(
          hintText: TKeys.discountPriceHint.tr,
          controller: discountController,
          keyboardType: TextInputType.number,
          prefixWidget: const Icon(Icons.discount_outlined, size: 20),
          maxLength: 15,
          counterText: '',
          inputFormatters: [ThousandsFormatter()],
          validator:
              (value) =>
                  ValidationUtil().discountPrice(value, priceController.text),
          autoValidateMode: autoValidateMode,
          focusNode: discountFocus,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}
