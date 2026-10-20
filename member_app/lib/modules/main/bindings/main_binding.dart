import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../nutrition/controllers/nutrition_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../progress/controllers/progress_controller.dart';
import '../../workout/controllers/workout_controller.dart';
import '../controllers/main_controller.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../subscriptions/controllers/subscriptions_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';

/// يسجّل كل الكنترولرز الخاصة بتبويبات الشريط السفلي دفعة واحدة
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => WorkoutController());
    Get.lazyPut(() => NutritionController());
    Get.lazyPut(() => ProgressController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => WalletController());
    Get.lazyPut(() => SubscriptionsController());
    Get.lazyPut(() => NotificationsController());
  }
}
