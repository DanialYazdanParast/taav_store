import 'regex_util.dart';

class ValidationUtil {
  String? email(final String? value) {
    if (value == null || value.isEmpty) {
      return 'ایمیل نمی‌تواند خالی باشد';
    }
    if (value.length > 60) {
      return 'حداکثر ۶۰ کاراکتر وارد کنید';
    }
    if (RegexpUtil.email.hasMatch(value)) {
      return null;
    } else {
      return 'ایمیل صحیح وارد کنید';
    }
  }

  String? mobileIran(final String? value) {
    if (value == null || value.isEmpty) {
      return 'شماره تماس نمی‌تواند خالی باشد';
    } else if (RegexpUtil.mobileIran.hasMatch(value)) {
      return null;
    } else {
      return 'شماره تماس صحیح وارد کنید';
    }
  }

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
    // 1. حذف فاصله‌های اضافی
    final trimmedValue = value?.trim();

    // 2. چک کردن خالی بودن
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'نام کاربری نمی‌تواند خالی باشد';
    }

    // 3. چک کردن طول (استاندارد معمولاً حداقل 3 یا 4 کاراکتر است)
    if (trimmedValue.length < 4) {
      return 'نام کاربری باید حداقل ۴ کاراکتر باشد';
    }

    if (trimmedValue.length > 30) {
      return 'نام کاربری نمی‌تواند بیشتر از ۳۰ کاراکتر باشد';
    }

    // 4. چک کردن وجود کاراکتر فارسی
    // اگر مچ پیدا شود، یعنی کاراکتر فارسی دارد -> پس خطاست
    if (!RegexpUtil.validUsername.hasMatch(trimmedValue)) {
      return 'نام کاربری فقط می‌تواند شامل حروف انگلیسی، اعداد و _ باشد';
    }

    // اگر بخواهید خیلی سخت‌گیر باشید که مثلاً اسپیس وسط کلمات هم نداشته باشد:
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
}
