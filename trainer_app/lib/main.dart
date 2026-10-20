import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/bindings/initial_binding.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/translations/app_translations.dart';
import 'core/translations/language_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // These are set up before runApp so they're ready the instant the
  // root widget (theme/locale) is first built.
  final themeController = Get.put(ThemeController(), permanent: true);
  final languageController = Get.put(LanguageController(), permanent: true);

  runApp(GymPilotTrainerApp(
    themeController: themeController,
    languageController: languageController,
  ));
}

class GymPilotTrainerApp extends StatelessWidget {
  final ThemeController themeController;
  final LanguageController languageController;

  const GymPilotTrainerApp({
    super.key,
    required this.themeController,
    required this.languageController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Rebuilds the whole app whenever the theme or language changes.
      final locale = Locale(languageController.languageCode.value);
      final isRtl = kSupportedLanguages
          .firstWhere((l) => l.code == locale.languageCode,
              orElse: () => kSupportedLanguages.first)
          .isRtl;

      return GetMaterialApp(
        title: 'GymPilot Trainer',
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppPages.onGenerateRoute,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        translations: AppTranslations(),
        locale: locale,
        fallbackLocale: const Locale('ar'),
        supportedLocales:
            kSupportedLanguages.map((l) => Locale(l.code)).toList(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    });
  }
}
