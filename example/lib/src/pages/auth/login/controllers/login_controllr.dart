import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginControllr extends GetxController {
  RxBool rememberMe = false.obs;

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  void onClose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}
