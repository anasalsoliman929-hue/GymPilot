import 'package:flutter/material.dart';

import '../modules/auth/views/change_password_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/otp_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/members/views/member_details_view.dart';
import '../modules/members/views/members_view.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/nutrition_plan/views/meal_form_view.dart';
import '../modules/nutrition_plan/views/nutrition_plan_details_view.dart';
import '../modules/nutrition_plan/views/nutrition_plan_form_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/training_plan/views/exercise_form_view.dart';
import '../modules/training_plan/views/training_plan_details_view.dart';
import '../modules/training_plan/views/training_plan_form_view.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashView(), arguments: settings.arguments);

      case AppRoutes.login:
        return _buildRoute(const LoginView(), up: true);

      case AppRoutes.forgotPassword:
        return _buildRoute(const ForgotPasswordView(), up: true, arguments: settings.arguments);

      case AppRoutes.otp:
        return _buildRoute(const OtpView(), arguments: settings.arguments);

      case AppRoutes.forceChangePassword:
        return _buildRoute(const ChangePasswordView(), up: true);

      case AppRoutes.changePassword:
        return _buildRoute(const ChangePasswordView(), arguments: settings.arguments);

      case AppRoutes.main:
        return _buildScaleRoute(
          const MainView(),
          onInit: () => MainBinding().dependencies(),
        );

      case AppRoutes.members:
        return _buildRoute(const MembersView(), arguments: settings.arguments);

      case AppRoutes.memberDetails:
        return _buildRoute(const MemberDetailsView(), arguments: settings.arguments);

      case AppRoutes.trainingPlanCreate:
        return _buildRoute(const TrainingPlanFormView(), up: true, arguments: settings.arguments);

      case AppRoutes.trainingPlanDetails:
        return _buildRoute(const TrainingPlanDetailsView(), arguments: settings.arguments);

      case AppRoutes.exerciseForm:
        return _buildRoute(const ExerciseFormView(), up: true, arguments: settings.arguments);

      case AppRoutes.nutritionPlanCreate:
        return _buildRoute(const NutritionPlanFormView(), up: true, arguments: settings.arguments);

      case AppRoutes.nutritionPlanDetails:
        return _buildRoute(const NutritionPlanDetailsView(), arguments: settings.arguments);

      case AppRoutes.mealForm:
        return _buildRoute(const MealFormView(), up: true, arguments: settings.arguments);

      case AppRoutes.notifications:
        return _buildRoute(const NotificationsView(), arguments: settings.arguments);

      case AppRoutes.profile:
        return _buildRoute(const ProfileView(), arguments: settings.arguments);

      case AppRoutes.editProfile:
        return _buildRoute(const EditProfileView(), up: true);

      default:
        return _buildRoute(const LoginView(), up: true);
    }
  }

  // ─── Slide + Fade Route ───────────────────────────────────
  static PageRouteBuilder _buildRoute(Widget page, {bool up = false, Object? arguments}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: page.runtimeType.toString(),arguments: arguments),
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
  static PageRouteBuilder _buildScaleRoute(Widget page, {VoidCallback? onInit}) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        onInit?.call();
        return page;
      },
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
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
