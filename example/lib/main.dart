import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'src/infoStructure/languages/localization_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LocalizationController(), permanent: true);
  runApp(const App());
}
