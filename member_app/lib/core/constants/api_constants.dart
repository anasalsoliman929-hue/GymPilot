class ApiConstants {

  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // ─── Auth ─────────────────────────────────────────────────
  static const String login          = '/auth/login';
  static const String register       = '/auth/register';
  static const String verifyOtp      = '/auth/verify-otp';
  static const String resendOtp      = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword  = '/auth/reset-password';
  static const String me             = '/auth/me';
  static const String logout         = '/auth/logout';
  static const String changePassword = '/auth/change-password';
  static const String deviceToken    = '/auth/device-token';

  // ─── Public ───────────────────────────────────────────────
  static const String gymInfo           = '/public/gym-info';
  static const String subscriptionTypes = '/public/subscription-types';
  static const String appVersion        = '/public/app-version';
  static const String legalDocuments    = '/public/legal-documents';
  static String legalDocument(String key) => '/public/legal-documents/$key';

  // ─── Member: Subscription ─────────────────────────────────
  static const String memberSubscriptions     = '/member/subscriptions';
  static const String memberActiveSubscription = '/member/subscriptions/active';
  static const String memberAvailablePeriods  = '/member/subscriptions/available-periods';

  // ─── Member: Attendance / QR ──────────────────────────────
  // الباك إند يرجع qr_token الخام (Flutter يرسم QR بنفسه)
  static const String memberQrToken          = '/member/qr-token';
  static const String memberAttendanceHistory = '/member/attendance/history';

  // ─── Member: Wallet ───────────────────────────────────────
  static const String memberWallet      = '/member/wallet';
  static const String memberWalletTopup = '/member/wallet/topup';
  static const String memberTopupHistory = '/member/wallet/topups';
  static const String memberPayments    = '/member/wallet/payments';

  // ─── Member: Plans ────────────────────────────────────────
  static const String memberTrainingToday = '/member/training-plan/today';
  static const String memberTrainingPlan  = '/member/training-plan';
  static const String memberNutritionPlan = '/member/nutrition-plan';

  // ─── Member: Progress ─────────────────────────────────────
  static const String memberProgress = '/member/progress';

  // ─── Member: Notifications ────────────────────────────────
  static const String memberNotifications       = '/member/notifications';
  static const String memberNotificationsReadAll = '/member/notifications/read-all';
  static String memberNotificationRead(int id)  => '/member/notifications/$id/read';

  // ─── Member: Complaints ───────────────────────────────────
  static const String memberComplaints = '/member/complaints';
  static String memberComplaint(int id) => '/member/complaints/$id';

  // ─── Member: Training Period ──────────────────────────────
  static const String memberMyPeriod = '/member/my-period';
}

class AppStrings {
  static const String appName      = 'GymPilot';
  static const String tokenKey     = 'auth_token';
  static const String userKey      = 'user_data';
  static const String themeKey     = 'theme_mode';
  static const String localeKey    = 'locale';
  static const String onboardingKey = 'onboarding_done'; 


  static const String appVersion = '1.0.0';

  //   هذين الرابطين رابطي التطبيق الفعليين على المتجرين
 
  static const String androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.gympilot.member';
  static const String iosStoreUrl =
      'https://apps.apple.com/app/id0000000000';
}
