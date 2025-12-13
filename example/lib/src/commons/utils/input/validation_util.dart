import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:get/get.dart';
import 'regex_util.dart';

class ValidationUtil {

  String? password(final String? value) {
    if (value == null || value.isEmpty) {
      return TKeys.validationPasswordEmpty.tr;
    }
    if (value.length < 8) {
      return TKeys.validationPasswordMinLength.tr;
    }
    if (value.length > 60) {
      return TKeys.validationPasswordMaxLength.tr;
    }
    if (!RegexpUtil.password.hasMatch(value)) {
      return TKeys.validationPasswordRequirements.tr;
    }

    return null;
  }

  String? passwordConfirm(final String? value, final String mainPassword) {
    if (value == null || value.isEmpty) {
      return TKeys.validationPasswordConfirmEmpty.tr;
    }
    if (value != mainPassword) {
      return TKeys.validationPasswordMismatch.tr;
    }
    return null;
  }

  String? username(final String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return TKeys.validationUsernameEmpty.tr;
    }

    if (trimmedValue.length < 4) {
      return TKeys.validationUsernameMinLength.tr;
    }

    if (trimmedValue.length > 30) {
      return TKeys.validationUsernameMaxLength.tr;
    }

    if (!RegexpUtil.validUsername.hasMatch(trimmedValue)) {
      return TKeys.validationUsernameInvalidChars.tr;
    }

    if (trimmedValue.contains(' ')) {
      return TKeys.validationUsernameNoSpaces.tr;
    }

    return null;
  }

  String? loginPassword(final String? value) {
    if (value == null || value.isEmpty) {
      return TKeys.validationLoginPasswordEmpty.tr;
    }

    if (value.length < 8) {
      return TKeys.validationLoginPasswordMinLength.tr;
    }

    if (!RegexpUtil.allowedPasswordChars.hasMatch(value)) {
      return TKeys.validationLoginPasswordEnglishOnly.tr;
    }

    return null;
  }

  String? requiredField(final String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${TKeys.validationCannotBeEmpty.tr}';
    }
    if (value.length < 3) {
      return '$fieldName ${TKeys.validationMinThreeChars.tr}';
    }
    return null;
  }

  String? number(final String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName ${TKeys.validationEnterValue.tr}';
    }

    final cleanValue = value.replaceAll(',', '');

    final number = int.tryParse(cleanValue);
    if (number == null) {
      return TKeys.validationNumberInvalid.tr;
    }
    if (number < 0) {
      return '$fieldName ${TKeys.validationCannotBeNegative.tr}';
    }
    return null;
  }

  String? discountPrice(final String? discountVal, final String? originalPriceVal) {
    if (discountVal == null || discountVal.isEmpty) return null;

    final cleanDiscount = discountVal.replaceAll(',', '');
    final cleanOriginal = (originalPriceVal ?? '0').replaceAll(',', '');

    final discount = int.tryParse(cleanDiscount);
    final original = int.tryParse(cleanOriginal);

    if (discount == null) {
      return TKeys.validationDiscountPriceInvalid.tr;
    }

    if (original == null) {
      return null;
    }

    if (discount > original) {
      return TKeys.validationDiscountPriceExceedsOriginal.tr;
    }

    return null;
  }
}