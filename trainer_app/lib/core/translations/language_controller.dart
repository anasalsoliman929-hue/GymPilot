import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/storage_keys.dart';

/// Supported app languages. Add new locales here.
class AppLanguage {
  final String code;
  final String label; // shown in the language picker, in its own language
  final bool isRtl;
  const AppLanguage(this.code, this.label, {this.isRtl = false});
}

const List<AppLanguage> kSupportedLanguages = [
  AppLanguage('ar', 'العربية', isRtl: true),
  AppLanguage('en', 'English'),
  AppLanguage('fr', 'Français'),
];

/// Controls the app's active language and persists it via GetStorage.
class LanguageController extends GetxController {
  final _box = GetStorage();

  final RxString languageCode = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    languageCode.value = _box.read<String>(StorageKeys.language) ?? 'ar';
  }

  AppLanguage get current =>
      kSupportedLanguages.firstWhere((l) => l.code == languageCode.value,
          orElse: () => kSupportedLanguages.first);

  void changeLanguage(String code) {
    languageCode.value = code;
    _box.write(StorageKeys.language, code);
    Get.updateLocale(Locale(code));
  }
}
