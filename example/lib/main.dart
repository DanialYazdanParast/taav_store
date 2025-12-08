import 'package:example/src/infoStructure/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  usePathUrlStrategy();
  runApp(const App());
}
