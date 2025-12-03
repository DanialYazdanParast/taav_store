import 'package:example/src/commons/enums/enums.dart'; // فرض بر این است که CurrentState اینجا تعریف شده
import 'package:example/src/commons/utils/toast_util.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';// مسیر احتمالی ریپازیتوری
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/login_repository.dart';

class LoginController extends GetxController {
  // اینجکشن ریپازیتوری (ترجیحاً از اینترفیس استفاده کنید)
  final ILoginRepository loginRepository;

  LoginController({required this.loginRepository});

  // تعریف FocusNode ها برای مدیریت فوکوس فیلدها
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  // تعریف کنترلرها
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  // متغیرهای وضعیت
  final RxBool rememberMe = false.obs; // برای چک‌باکس "مرا به خاطر بسپار"
  final Rx<CurrentState> loginState = CurrentState.idle.obs;

  // کلید فرم و حالت اعتبارسنجی
  final GlobalKey<FormState> fkLogin = GlobalKey<FormState>();
  late Rx<AutovalidateMode> avmLogin;

  @override
  void onInit() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    avmLogin = AutovalidateMode.disabled.obs;
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();

    usernameFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }

  Future<void> login() async {
    // بستن کیبورد قبل از شروع عملیات
    usernameFocus.unfocus();
    passwordFocus.unfocus();

    if (!fkLogin.currentState!.validate()) {
      avmLogin.value = AutovalidateMode.always;
      return;
    }

    loginState.value = CurrentState.loading;
    await Future.delayed(const Duration(seconds: 1));
    final username = usernameController.text.trim();
    final password = passwordController.text;

    final result = await loginRepository.login(username, password);

    result.fold(
          (failure) {
        loginState.value = CurrentState.error;
        ToastUtil.show(
          failure.message ?? 'نام کاربری یا رمز عبور اشتباه است',
          type: ToastType.error,
        );
      },
          (user) {
        loginState.value = CurrentState.success;

        ToastUtil.show(
          'ورود با موفقیت انجام شد. خوش آمدید ${user.username ?? ''}',
          type: ToastType.success,
        );
        if (rememberMe.value) {
          // saveToken logic...
        }

        Get.offAllNamed(AppRoutes.sellerProducts);
      },
    );
  }
}