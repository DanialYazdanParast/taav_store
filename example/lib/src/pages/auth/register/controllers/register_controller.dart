
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/auth/register/models/user_model.dart';
import 'package:example/src/pages/auth/register/repository/register_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final RegisterRepository registerRepository;
  RegisterController({ required this.registerRepository});
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

  // ═══ Form Key ═══
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

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



  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<UserModel> filteredList = <UserModel>[].obs;
  Rx<CurrentState> userState = CurrentState.idle.obs;

  /// متد fetchUsers
  Future<void> fetchUsers() async {
    userState.value = CurrentState.loading;
    final result = await registerRepository.getUsers();
    result.fold(
      (failure) {
        userState.value = CurrentState.error;
      },
      (users) {
        userList.assignAll(users);
        userState.value = CurrentState.success;
      },
    );
  }
}

