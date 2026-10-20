import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../constants/api_constants.dart';
import '../network/api_client.dart';
import 'storage_service.dart';

/// Handler الخلفية — لازم يكون top-level (مو داخل كلاس) ومعلّم بـ
/// @pragma حتى يشتغل لما يوصل إشعار والتطبيق مغلق تماماً
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // لا حاجة لأي منطق هنا حالياً — نظام التشغيل نفسه بيعرض
  // الإشعار تلقائياً لما يكون التطبيق بالخلفية/مغلق طالما
  // فيه "notification" payload (مو data-only)
}

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'gympilot_default_channel', // id
    'إشعارات GymPilot', // اسم يظهر بإعدادات النظام
    description: 'إشعارات عامة من تطبيق GymPilot',
    importance: Importance.high,
  );

  Future<void> init() async {
    try {
      // 1) تهيئة الإشعارات المحلية (لعرضها لما التطبيق بالمقدمة)
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _localNotifications.initialize(
        const InitializationSettings(android: androidInit),
      );

           final AndroidFlutterLocalNotificationsPlugin? androidImpl =
          _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        await androidImpl.createNotificationChannel(_channel);
      }

      // 2) طلب صلاحية الإشعارات (أندرويد 13+ / iOS)
      await _messaging.requestPermission();

      // 3) تسجيل الـ handler الخاص بحالة "التطبيق مغلق تماماً"
      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

      // 4) التطبيق بالمقدمة — نعرض الإشعار يدوياً عبر flutter_local_notifications
      FirebaseMessaging.onMessage.listen(_showLocalNotification);

      // 5) المستخدم ضغط على الإشعار (التطبيق بالخلفية) — هون تقدر
      // تضيف لاحقاً توجيه (Navigation) حسب نوع الإشعار
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // TODO: توجيه حسب message.data لو حبيت لاحقاً
      });

      // 6) إرسال الـ Token الحالي، والاستماع لأي تحديث مستقبلي له
      await _registerToken();
      _messaging.onTokenRefresh.listen((_) => _registerToken());
    } catch (e) {
      // أي فشل بتهيئة FCM (مثلاً جهاز/محاكي بدون Google Play Services)
      // ما لازم يوقف التطبيق نهائياً — نكمل بدون إشعارات فقط
      print('=== PUSH NOTIFICATION INIT FAILED (non-fatal): $e ===');
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// يُستدعى من LoginController بعد نجاح تسجيل الدخول مباشرة
  /// (init() نفسها استُدعيت مسبقاً مرة وحدة عند إقلاع التطبيق بـ InitialBinding)
  Future<void> registerTokenAfterLogin() => _registerToken();

  /// يُستدعى بعد أي تسجيل دخول ناجح، وأيضاً تلقائياً عند تجدّد التوكن
  Future<void> _registerToken() async {
    try {
      final storage = Get.find<StorageService>();
      if (!storage.isLoggedIn) return; // ما في فايدة نرسله قبل تسجيل الدخول

      String? fcmToken;
      try {
        fcmToken = await _messaging.getToken();
      } catch (_) {
        // فشل جلب FCM token (مثلاً محاكي بدون Google Play Services)
        return;
      }
      if (fcmToken == null) return;

      final client = Get.find<ApiClient>();
      await client.post(ApiConstants.deviceToken, data: {'device_token': fcmToken});
    } catch (e) {
      // فشل إرسال التوكن ما لازم يوقف التطبيق أو يظهر خطأ للمستخدم
    }
  }
}