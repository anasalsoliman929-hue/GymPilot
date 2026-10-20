import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/member_repository.dart';

class NotificationsController extends GetxController {
  final MemberRepository _repo = Get.find<MemberRepository>();

  RxBool isLoading   = true.obs;
  RxList notifications = [].obs;
  RxInt unreadCount  = 0.obs;
  String? error;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      final data  = await _repo.getNotifications();
      final page  = data['notifications'] as Map<String, dynamic>;
      notifications.assignAll(page['data'] as List);
      unreadCount.value = data['unread_count'] as int? ?? 0;
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_notifications'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllRead() async {
    try {
      await _repo.markAllRead();
      // تحديث محلي
      notifications.assignAll(
        notifications.map((n) {
          final map = Map<String, dynamic>.from(n as Map);
          map['is_read'] = true;
          return map;
        }).toList(),
      );
      unreadCount.value = 0;
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    }
  }

  Future<void> markRead(int id) async {
    try {
      await _repo.markRead(id);
      final idx = notifications.indexWhere((n) => (n as Map)['id'] == id);
      if (idx != -1) {
        final map = Map<String, dynamic>.from(notifications[idx] as Map);
        map['is_read'] = true;
        notifications[idx] = map;
        if (unreadCount.value > 0) unreadCount.value--;
      }
    } catch (_) {}
  }
}