import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/notification_model.dart';

/// صفحة إشعارات واحدة (نمط Laravel pagination)
class NotificationsPage {
  final List<NotificationModel> items;
  final int currentPage;
  final int lastPage;

  NotificationsPage({required this.items, required this.currentPage, required this.lastPage});

  factory NotificationsPage.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List?) ?? [];
    return NotificationsPage(
      items: list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }
}

class NotificationsRepository {
  final ApiClient _client;
  NotificationsRepository(this._client);

  /// GET /trainer/notifications
  Future<NotificationsPage> getNotifications({int page = 1}) async {
    final res = await _client.get(
      ApiConstants.trainerNotifications,
      query: {'page': page},
    );
    return NotificationsPage.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// POST /trainer/notifications/{id}/read
  Future<void> markAsRead(int id) async {
    await _client.post(ApiConstants.trainerNotificationRead(id));
  }

  /// POST /trainer/notifications/read-all
  Future<void> markAllAsRead() async {
    await _client.post(ApiConstants.trainerNotificationsReadAll);
  }
}

/// بيانات عامة مشتركة مع تطبيق المستخدم — للاطلاع فقط
/// المدرب لا يشترك، فقط يشوف معلومات الصالة وأنواع الاشتراكات المتاحة لأعضائه
class PublicRepository {
  final ApiClient _client;
  PublicRepository(this._client);

  /// GET /public/gym-info
  Future<Map<String, dynamic>> getGymInfo() async {
    final res = await _client.get(ApiConstants.gymInfo);
    return res['data'] as Map<String, dynamic>;
  }

  /// GET /public/subscription-types
  Future<List<dynamic>> getSubscriptionTypes() async {
    final res = await _client.get(ApiConstants.subscriptionTypes);
    final data = res['data'];
    return data is List ? data : [];
  }
}
