import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/utils/toast_util.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/login_repository.dart';

class LoginController extends GetxController {
  final ILoginRepository loginRepository;
  final AuthService authService;

  LoginController({required this.loginRepository, required this.authService});

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  final RxBool rememberMe = false.obs;
  final Rx<CurrentState> loginState = CurrentState.idle.obs;

  final GlobalKey<FormState> fkLogin = GlobalKey<FormState>();
  late final Rx<AutovalidateMode> avmLogin;

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

        final successMessage =
            '${TKeys.loginSuccess.tr} ${TKeys.welcomeMessage.tr} ${user.username}';
        ToastUtil.show(successMessage, type: ToastType.success);

        authService.saveUserData(
          remember: rememberMe.value,
          uname: user.username,
          id: user.id,
          type: user.userType,
        );

        final userType = userTypeFromString(user.userType);

        switch (userType) {
          case UserType.seller:
            Get.offAllNamed(AppRoutes.sellerProducts);
            break;

          case UserType.buyer:
            Get.offAllNamed(AppRoutes.buyerProducts);
            break;
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
