import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/utils/toast_util.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/auth/register/models/dto.dart';
import 'package:taav_store/src/pages/auth/register/repository/register_repository.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final IRegisterRepository registerRepository;

  RegisterController({required this.registerRepository});

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final Rx<UserType> userType = UserType.buyer.obs;
  final RxBool acceptTerms = false.obs;

  final Rx<CurrentState> registerState = CurrentState.idle.obs;

  final GlobalKey<FormState> fkRegister = GlobalKey<FormState>();

  late Rx<AutovalidateMode> avmRegister;

  @override
  void onInit() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    avmRegister = AutovalidateMode.disabled.obs;
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    usernameFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.onClose();
  }

  Future<void> register() async {
    if (!fkRegister.currentState!.validate()) {
      avmRegister.value = AutovalidateMode.always;
      return;
    }
    if (!acceptTerms.value) {
      ToastUtil.show(TKeys.acceptTermsWarning.tr, type: ToastType.warning);
      return;
    }

    registerState.value = CurrentState.loading;

    final username = usernameController.text.trim();

    final canContinue = await _checkUserNotExists(username);
    if (!canContinue) return;

    await _createUser(username);
  }

  Future<bool> _checkUserNotExists(String username) async {
    final result = await registerRepository.checkUserExists(username);

    return result.fold(
      (failure) {
        registerState.value = CurrentState.error;
        ToastUtil.show(failure.message, type: ToastType.error);
        return false;
      },
      (exists) {
        if (exists) {
          registerState.value = CurrentState.error;
          ToastUtil.show(TKeys.usernameAlreadyExists.tr, type: ToastType.error);
          return false;
        }
        return true;
      },
    );
  }

  Future<void> _createUser(String username) async {
    final dto = CreateUserDto(
      username: username,
      password: passwordController.text,
      userType: userType.value.name,
    );

    final result = await registerRepository.createUser(dto);

    result.fold(
      (failure) {
        registerState.value = CurrentState.error;
        ToastUtil.show(failure.message, type: ToastType.error);
      },
      (newUser) {
        final successMsg =
            '${TKeys.registerSuccessMsg.tr} ${TKeys.loginToContinue.tr}';

        registerState.value = CurrentState.success;
        ToastUtil.show(
          successMsg,
          type: ToastType.success,
          duration: const Duration(seconds: 3),
        );

        Get.offNamed(
          AppRoutes.login,
          arguments: {
            'username': usernameController.text,
            'password': passwordController.text,
          },
        );

        _clearForm();
      },
    );
  }

  void _clearForm() {
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    userType.value = UserType.buyer;
    acceptTerms.value = false;
    avmRegister.value = AutovalidateMode.disabled;
    fkRegister.currentState?.reset();
  }
}
