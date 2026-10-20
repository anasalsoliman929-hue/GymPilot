import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/training_period_model.dart';

class MemberRepository {
  final ApiClient _client;
  MemberRepository(this._client);

  /// GET /member/qr-token — يرجع الـ token الخام لرسم QR في Flutter
  Future<String> getQrToken() async {
    final res = await _client.get(ApiConstants.memberQrToken);
    final data = res['data'] as Map<String, dynamic>;
    return data['qr_token'] as String;
  }

  /// GET /member/attendance/history
  Future<Map<String, dynamic>> getAttendanceHistory() async {
    final res = await _client.get(ApiConstants.memberAttendanceHistory);
    return res['data'] as Map<String, dynamic>;
  }
/// POST /member/wallet/topup
Future<void> requestTopup({
  required String amount,
  required String transactionNumber,
  String? receiptPath,
}) async {
  // نستخدم Dio مباشرة لإرسال form-data
  final formData = {
    'amount':             amount,
    'transaction_number': transactionNumber,
  };

  await _client.postFormData(
    ApiConstants.memberWalletTopup,
    data: formData,
    filePath: receiptPath,
    fileField: 'receipt',
  );
}

  /// GET /member/wallet
  Future<Map<String, dynamic>> getWallet() async {
  final res = await _client.get(ApiConstants.memberWallet);
  final data = res['data'] as Map<String, dynamic>;
  // تحويل balance من String إلى double
  if (data['balance'] != null) {
    data['balance'] = double.tryParse(data['balance'].toString()) ?? 0.0;
  }
  return data;
}
  /// GET /member/wallet/payments
  Future<List<dynamic>> getPayments() async {
  final res  = await _client.get(ApiConstants.memberPayments);
  final data = res['data'];
  // الباك إند يرجع pagination: data.data
  if (data is Map && data.containsKey('data')) {
    return data['data'] as List;
  }
  if (data is List) return data;
  return [];
}

  /// GET /member/subscriptions/active
  Future<Map<String, dynamic>?> getActiveSubscription() async {
    final res = await _client.get(ApiConstants.memberActiveSubscription);
    return res['data'] as Map<String, dynamic>?;
  }

  /// PUT /member/notifications/read-all
  Future<void> markAllNotificationsRead() async {
    await _client.put(ApiConstants.memberNotificationsReadAll);
  }

  /// PUT /member/notifications/{id}/read
  Future<void> markNotificationRead(int id) async {
    await _client.put(ApiConstants.memberNotificationRead(id));
  }
  /// GET /member/wallet/topups
Future<List<dynamic>> getTopupHistory() async {
  final res  = await _client.get(ApiConstants.memberTopupHistory);
  final data = res['data'];
  if (data is Map && data.containsKey('data')) return data['data'] as List;
  if (data is List) return data;
  return [];
}
/// GET /member/notifications
Future<Map<String, dynamic>> getNotifications() async {
  final res = await _client.get(ApiConstants.memberNotifications);
  return res['data'] as Map<String, dynamic>;
}

/// PUT /member/notifications/read-all
Future<void> markAllRead() async {
  await _client.put(ApiConstants.memberNotificationsReadAll);
}

/// PUT /member/notifications/{id}/read
Future<void> markRead(int id) async {
  await _client.put(ApiConstants.memberNotificationRead(id));
}

/// GET /member/my-period — فترة تدريب اللاعب مع بيانات المدرب
Future<TrainingPeriodModel> getMyPeriod() async {
  final res = await _client.get(ApiConstants.memberMyPeriod);
  return TrainingPeriodModel.fromJson(res['data'] as Map<String, dynamic>);
}
}
