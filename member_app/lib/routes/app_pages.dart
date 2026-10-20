import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gympilot_member/modules/nutrition/views/nutrition_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../modules/auth/views/otp_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/profile/views/change_password_view.dart';
import '../modules/profile/views/qr_code_view.dart';
import '../modules/progress/views/add_progress_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscriptions/views/subscriptions_view.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../modules/workout/views/workout_plan_view.dart';
import 'app_routes.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/complaints/views/complaints_view.dart';
import '../modules/period/views/my_period_view.dart';
import '../modules/legal/views/legal_document_view.dart';

class AppPages {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashView());

      case AppRoutes.login:
        return _buildRoute(const LoginView(), up: true);

      case AppRoutes.welcome:
        return _buildRoute(const WelcomeView());

      case AppRoutes.register:
        return _buildRoute(const RegisterView(), arguments: settings.arguments);

      case AppRoutes.otp:
        return _buildRoute(const OtpView(), arguments: settings.arguments);

      case AppRoutes.onboarding:
        return _buildScaleRoute(const OnboardingView());

      case AppRoutes.forgotPassword:
        return _buildRoute(const ForgotPasswordView(), up: true);

      case AppRoutes.subscriptions:
        return _buildRoute(const SubscriptionsView(), up: true);

      case AppRoutes.main:
        return _buildScaleRoute(
          const MainView(),
          onInit: () => MainBinding().dependencies(),
        );

      case AppRoutes.qrCode:
        return _buildRoute(const QrCodeView(), up: true);

      case AppRoutes.changePassword:
        return _buildRoute(const ChangePasswordView());

      case AppRoutes.settings:
        return _buildRoute(const SettingsView());

      case AppRoutes.addProgress:
        return _buildRoute(const AddProgressView(), up: true);

      case AppRoutes.workoutPlanFull:
        return _buildRoute(const WorkoutPlanView());

      case AppRoutes.wallet:
        return _buildRoute(const WalletView(), up: true);
      case AppRoutes.notifications:
        return _buildRoute(const NotificationsView());
      case AppRoutes.nutrition:
        return _buildRoute(const NutritionView(), up: true);

      case AppRoutes.complaints:
        return _buildRoute(const ComplaintsView(), up: true);

      case AppRoutes.myPeriod:
        return _buildRoute(const MyPeriodView(), up: true);

      case AppRoutes.privacyPolicy:
        return _buildRoute(
          LegalDocumentView(
            documentKey: 'privacy_policy',
            fallbackTitle: 'privacy_policy_title'.tr,
          ),
          up: true,
        );

      case AppRoutes.termsOfUse:
        return _buildRoute(
          LegalDocumentView(
            documentKey: 'terms_of_use',
            fallbackTitle: 'terms_of_use_title'.tr,
          ),
          up: true,
        );

      default:
        return _buildRoute(const LoginView(), up: true);
    }
  }

  // ─── Slide + Fade Route ───────────────────────────────────
  static PageRouteBuilder _buildRoute(Widget page,
      {bool up = false, Object? arguments}) {
    return PageRouteBuilder(
      settings: RouteSettings(
          name: page.runtimeType.toString(), arguments: arguments),
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final begin = up ? const Offset(0, 1.0) : const Offset(1.0, 0);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: begin, end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  // ─── Scale + Fade Route ───────────────────────────────────
  static PageRouteBuilder _buildScaleRoute(Widget page,
      {VoidCallback? onInit}) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        onInit?.call();
        return page;
      },
      transitionsBuilder: (_, animation, __, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween(begin: 0.88, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
