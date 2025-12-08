import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/utils/toast_util.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart'; // Import added
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/login_repository.dart';

class LoginController extends GetxController {
  final ILoginRepository loginRepository;
  final AuthService authService;

  LoginController({required this.loginRepository, required this.authService});

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  final RxBool rememberMe = false.obs;
  final Rx<CurrentState> loginState = CurrentState.idle.obs;

  final GlobalKey<FormState> fkLogin = GlobalKey<FormState>();
  late Rx<AutovalidateMode> avmLogin;

  @override
  void onInit() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    avmLogin = AutovalidateMode.disabled.obs;
    super.onInit();
  }

  Future<void> login() async {
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
        ToastUtil.show(failure.message, type: ToastType.error);
      },
          (user) {
        loginState.value = CurrentState.success;

        // ترکیب پیام موفقیت با نام کاربری
        final successMessage =
            '${TKeys.loginSuccess.tr} ${TKeys.welcomeMessage.tr} ${user.username}';

        ToastUtil.show(
          successMessage,
          type: ToastType.success,
        );

        authService.saveUserData(
          remember: rememberMe.value,
          uname: user.username,
          id: user.id,
          type: user.userType,
        );

        final userType = user.userType.toLowerCase() ?? '';

        if (userType == "seller") {
          Get.offAllNamed(AppRoutes.sellerProducts);
        } else if (userType == "buyer") {
          Get.offAllNamed(AppRoutes.buyerProducts);
        } else {
          ToastUtil.show(TKeys.invalidUserType.tr, type: ToastType.error);
          authService.logout();
          Get.offAllNamed(AppRoutes.login);
        }
      },
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();

    usernameFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}