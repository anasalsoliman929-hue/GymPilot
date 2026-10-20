import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/storage_keys.dart';

/// Controls the app's theme mode (light / dark / system) and persists
/// the user's choice across app restarts using GetStorage.
class ThemeController extends GetxController {
  final _box = GetStorage();

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read<String>(StorageKeys.themeMode);
    themeMode.value = _fromString(saved);
  }

  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.mediaQuery.platformBrightness == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _box.write(StorageKeys.themeMode, _toString(mode));
    Get.forceAppUpdate();
  }

  void toggleTheme() {
    setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  ThemeMode _fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
