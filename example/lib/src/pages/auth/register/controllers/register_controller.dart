import 'package:example/src/commons/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  // ═══ TextControllers ═══
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ═══ State ═══
  final userType = UserType.buyer.obs;
  final acceptTerms = false.obs;
  final isLoading = false.obs;

  // ═══ Form Key ═══
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();

    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
