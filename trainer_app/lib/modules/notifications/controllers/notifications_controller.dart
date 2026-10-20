import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notifications_repository.dart';

class NotificationsController extends GetxController {
  final NotificationsRepository _repo = Get.find<NotificationsRepository>();

  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  String? error;

  RxList<NotificationModel> items = <NotificationModel>[].obs;
  int _currentPage = 1;
  int _lastPage = 1;

  bool get hasMore => _currentPage < _lastPage;
  int get unreadCount => items.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    _currentPage = 1;
    try {
      final page = await _repo.getNotifications(page: 1);
      items.assignAll(page.items);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'تعذّر تحميل الإشعارات';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final page = await _repo.getNotifications(page: _currentPage + 1);
      items.addAll(page.items);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
    } catch (_) {
      // تجاهل بصمت أثناء التحميل الإضافي
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// تعليم إشعار واحد كمقروء — تحديث فوري بالواجهة (optimistic) قبل رد السيرفر
  Future<void> markAsRead(NotificationModel n) async {
    if (n.isRead) return;
    final index = items.indexWhere((e) => e.id == n.id);
    if (index != -1) items[index] = n.copyWith(isRead: true);

    try {
      await _repo.markAsRead(n.id);
    } catch (_) {
      // رجّع الحالة القديمة لو فشل الطلب
      if (index != -1) items[index] = n;
      AppSnackbar.error('تعذّر تحديث حالة الإشعار');
    }
  }

  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;
    final backup = items.toList();
    items.assignAll(items.map((n) => n.copyWith(isRead: true)).toList());

    try {
      await _repo.markAllAsRead();
      AppSnackbar.success('تم تعليم كل الإشعارات كمقروءة');
    } on ApiException catch (e) {
      items.assignAll(backup);
      AppSnackbar.error(e.firstError);
      print(e.firstError);
    } catch (_) {
      items.assignAll(backup);
      AppSnackbar.error('تعذّر تعليم الإشعارات كمقروءة');
    }
  }
}
