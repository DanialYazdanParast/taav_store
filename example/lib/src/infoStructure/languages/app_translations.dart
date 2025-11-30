// lib/core/localization/app_translations.dart

import 'package:get/get.dart';

import 'en_US.dart';
import 'fa_IR.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'fa_IR': faIR};
}
