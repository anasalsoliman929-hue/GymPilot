import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../members/controllers/members_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/main_controller.dart';

/// يسجّل كل الكنترولرز الخاصة بتبويبات الشريط السفلي دفعة واحدة
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MembersController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => ProfileController());
  }
}
