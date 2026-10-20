import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/bindings/initial_binding.dart';
import 'core/theme/app_theme.dart';
import 'core/langs/LanguageController.dart';
import 'core/langs/app_translations.dart';
import 'core/theme/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  final languageController = Get.put(LanguageController(), permanent: true);
  final themeController = Get.put(ThemeController(), permanent: true);

  runApp(GymPilotApp(
    languageController: languageController,
    themeController: themeController,
  ));
}

class GymPilotApp extends StatelessWidget {
  final LanguageController languageController;
  final ThemeController themeController;

  const GymPilotApp({
    super.key,
    required this.languageController,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GymPilot',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppPages.onGenerateRoute,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.theme,
      translations: AppTranslations(),
      locale: languageController.locale,
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
