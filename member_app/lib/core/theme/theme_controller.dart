import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();

  /// 0 = system, 1 = light, 2 = dark
  RxInt themeMode = 0.obs;

  @override
  void onInit() {
    super.onInit();

    themeMode.value = _box.read('themeMode') ?? 0;
  }

  ThemeMode get theme {
    switch (themeMode.value) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setThemeMode(int mode) {
    themeMode.value = mode;
    _box.write('themeMode', mode);

    Get.changeThemeMode(theme);
  }
}