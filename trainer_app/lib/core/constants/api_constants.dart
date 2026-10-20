class ApiConstants {
  // ⚠️ غيّر هذا للرابط الفعلي للسيرفر
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // ─── Auth (مشتركة مع تطبيق المستخدم) ──────────────────────
  static const String login          = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp      = '/auth/verify-otp';
  static const String resendOtp      = '/auth/resend-otp';
  static const String me             = '/auth/me';
  static const String changePassword = '/auth/change-password';
  static const String logout         = '/auth/logout';

  // ─── Public (مشتركة — للاطلاع فقط، المدرب لا يشترك) ───────
  static const String gymInfo           = '/public/gym-info';
  static const String subscriptionTypes = '/public/subscription-types';

  // ─── Trainer: Profile ──────────────────────────────────────
  static const String trainerProfile = '/trainer/profile';

  // ─── Trainer: Members ───────────────────────────────────────
  static const String trainerMembers = '/trainer/members';
  static String trainerMemberDetails(int id) => '/trainer/members/$id';
  static String trainerMemberProgress(int id) => '/trainer/members/$id/progress';

  // ─── Trainer: Training Plans ─────────────────────────────────
  static const String trainerTrainingPlans = '/trainer/training-plans';
  static String trainerTrainingPlanDetails(int id) => '/trainer/training-plans/$id';
  static String trainerTrainingPlanExercises(int planId) =>
      '/trainer/training-plans/$planId/exercises';
  static String trainerExercise(int exerciseId) => '/trainer/exercises/$exerciseId';

  // ─── Trainer: Nutrition Plans ─────────────────────────────────
  static const String trainerNutritionPlans = '/trainer/nutrition-plans';
  static String trainerNutritionPlanDetails(int id) => '/trainer/nutrition-plans/$id';
  static String trainerNutritionPlanMeals(int planId) =>
      '/trainer/nutrition-plans/$planId/meals';
  static String trainerMeal(int mealId) => '/trainer/meals/$mealId';

  // ─── Trainer: Notifications ───────────────────────────────────
  static const String trainerNotifications = '/trainer/notifications';
  static String trainerNotificationRead(int id) => '/trainer/notifications/$id/read';
  static const String trainerNotificationsReadAll = '/trainer/notifications/read-all';
}

class AppStrings {
  static const String appName  = 'GymPilot Trainer';
  static const String tokenKey = 'auth_token';
  static const String userKey  = 'user_data';
}
