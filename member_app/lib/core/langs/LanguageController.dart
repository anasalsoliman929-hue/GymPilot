import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {

  final _box = GetStorage();

  RxString lang = "en".obs;

  static const Map<String, Locale> supportedLocales = {
    "ar": Locale('ar', 'SA'),
    "en": Locale('en', 'US'),
    "fr": Locale('fr', 'FR'),
  };

  @override
  void onInit() {
    super.onInit();

    lang.value = _box.read('lang') ?? "en";
  }

  Locale get locale => supportedLocales[lang.value] ?? supportedLocales["en"]!;

  void changeLanguage(String code) {
    if (!supportedLocales.containsKey(code)) return;

    lang.value = code;

    Get.updateLocale(supportedLocales[code]!);

    _box.write('lang', code);
  }
}
