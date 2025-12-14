import 'package:taav_store/generated/locales.g.dart';
import 'package:get/get.dart';
import 'regex_util.dart';

class ValidationUtil {
  String? password(final String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validationPasswordEmpty.tr;
    }
    if (value.length < 8) {
      return LocaleKeys.validationPasswordMinLength.tr;
    }
    if (value.length > 60) {
      return LocaleKeys.validationPasswordMaxLength.tr;
    }
    if (!RegexpUtil.password.hasMatch(value)) {
      return LocaleKeys.validationPasswordRequirements.tr;
    }

    return null;
  }

  String? passwordConfirm(final String? value, final String mainPassword) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validationPasswordConfirmEmpty.tr;
    }
    if (value != mainPassword) {
      return LocaleKeys.validationPasswordMismatch.tr;
    }
    return null;
  }

  String? username(final String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return LocaleKeys.validationUsernameEmpty.tr;
    }

    if (trimmedValue.length < 4) {
      return LocaleKeys.validationUsernameMinLength.tr;
    }

    if (trimmedValue.length > 30) {
      return LocaleKeys.validationUsernameMaxLength.tr;
    }

    if (!RegexpUtil.validUsername.hasMatch(trimmedValue)) {
      return LocaleKeys.validationUsernameInvalidChars.tr;
    }

    if (trimmedValue.contains(' ')) {
      return LocaleKeys.validationUsernameNoSpaces.tr;
    }

    return null;
  }

  String? loginPassword(final String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validationLoginPasswordEmpty.tr;
    }

    if (value.length < 8) {
      return LocaleKeys.validationLoginPasswordMinLength.tr;
    }

    if (!RegexpUtil.allowedPasswordChars.hasMatch(value)) {
      return LocaleKeys.validationLoginPasswordEnglishOnly.tr;
    }

    return null;
  }

  String? requiredField(final String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${LocaleKeys.validationCannotBeEmpty.tr}';
    }
    if (value.length < 3) {
      return '$fieldName ${LocaleKeys.validationMinThreeChars.tr}';
    }
    return null;
  }

  String? number(final String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName ${LocaleKeys.validationEnterValue.tr}';
    }

    final cleanValue = value.replaceAll(',', '');

    final number = int.tryParse(cleanValue);
    if (number == null) {
      return LocaleKeys.validationNumberInvalid.tr;
    }
    if (number < 0) {
      return '$fieldName ${LocaleKeys.validationCannotBeNegative.tr}';
    }
    return null;
  }

  String? discountPrice(
    final String? discountVal,
    final String? originalPriceVal,
  ) {
    if (discountVal == null || discountVal.isEmpty) return null;

    final cleanDiscount = discountVal.replaceAll(',', '');
    final cleanOriginal = (originalPriceVal ?? '0').replaceAll(',', '');

    final discount = int.tryParse(cleanDiscount);
    final original = int.tryParse(cleanOriginal);

    if (discount == null) {
      return LocaleKeys.validationDiscountPriceInvalid.tr;
    }

    if (original == null) {
      return null;
    }

    if (discount > original) {
      return LocaleKeys.validationDiscountPriceExceedsOriginal.tr;
    }

    return null;
  }
}
