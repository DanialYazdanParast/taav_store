import 'regex_util.dart';

class ValidationUtil {


  String? password(final String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور نمی‌تواند خالی باشد';
    }
    if (value.length < 8) {
      return 'رمز عبور باید حداقل ۸ کاراکتر باشد';
    }
    if (value.length > 60) {
      return 'رمز عبور باید حداکثر ۶۰ کاراکتر باشد';
    }
    if (!RegexpUtil.password.hasMatch(value)) {
      return 'رمز عبور باید شامل حداقل یک حرف بزرگ، یک حرف کوچک، یک عدد و یک کاراکتر خاص باشد';
    }

    return null;
  }

  String? passwordConfirm(final String? value, final String mainPassword) {
    if (value == null || value.isEmpty) {
      return 'لطفاً رمز عبور را تأیید کنید';
    }
    if (value != mainPassword) {
      return 'رمزهای عبور مطابقت ندارند';
    }
    return null;
  }

  ///--------------------------------------
  ///class ValidationUtil {

  // ... (سایر متدها) ...

  String? username(final String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'نام کاربری نمی‌تواند خالی باشد';
    }

    if (trimmedValue.length < 4) {
      return 'نام کاربری باید حداقل ۴ کاراکتر باشد';
    }

    if (trimmedValue.length > 30) {
      return 'نام کاربری نمی‌تواند بیشتر از ۳۰ کاراکتر باشد';
    }

    if (!RegexpUtil.validUsername.hasMatch(trimmedValue)) {
      return 'نام کاربری فقط می‌تواند شامل حروف انگلیسی، اعداد و _ باشد';
    }

    if (trimmedValue.contains(' ')) {
      return 'نام کاربری نمی‌تواند شامل فاصله باشد';
    }

    return null;
  }

  String? loginPassword(final String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور نمی‌تواند خالی باشد';
    }

    if (value.length < 8) {
      return 'رمز عبور باید حداقل ۸ کاراکتر باشد';
    }

    if (!RegexpUtil.allowedPasswordChars.hasMatch(value)) {
      return 'رمز عبور باید با حروف انگلیسی وارد شود';
    }

    return null;
  }


  String? requiredField(final String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName نمی‌تواند خالی باشد';
    }
    if (value.length < 3) {
      return '$fieldName باید حداقل ۳ کاراکتر باشد';
    }
    return null;
  }

  String? number(final String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName را وارد کنید';
    }

    // حذف ویرگول‌ها برای تبدیل صحیح به عدد
    final cleanValue = value.replaceAll(',', '');

    final number = int.tryParse(cleanValue);
    if (number == null) {
      return 'لطفاً عدد معتبر وارد کنید';
    }
    if (number < 0) {
      return '$fieldName نمی‌تواند منفی باشد';
    }
    return null;
  }

  // ✅ اصلاح شده: حذف ویرگول برای مقایسه قیمت‌ها
  String? discountPrice(final String? discountVal, final String? originalPriceVal) {

    if (discountVal == null || discountVal.isEmpty) return null;

    final cleanDiscount = discountVal.replaceAll(',', '');
    final cleanOriginal = (originalPriceVal ?? '0').replaceAll(',', '');

    final discount = int.tryParse(cleanDiscount);
    final original = int.tryParse(cleanOriginal);

    if (discount == null) {
      return 'قیمت تخفیف باید عدد باشد';
    }

    if (original == null) {
      return null;
    }

    if (discount >= original) {
      return 'قیمت با تخفیف باید کمتر از قیمت اصلی باشد';
    }

    return null;
  }
}
