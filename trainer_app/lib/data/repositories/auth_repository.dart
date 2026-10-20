import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

/// نتيجة تسجيل الدخول / التحقق من OTP
class AuthResult {
  final String token;
  final UserModel user;
  AuthResult({required this.token, required this.user});
}

class AuthRepository {
  final ApiClient _client;
  AuthRepository(this._client);

  /// POST /auth/login
  /// ملاحظة: المدرب لا ينشئ حساباً — يسجّل دخوله بالإيميل المسجّل لدى
  /// الأدمن مع كلمة المرور المؤقتة التي أعطاه إياها، ثم يُطالَب بتغييرها
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.post(ApiConstants.login, data: {
      'email': email,
      'password': password,
    });
    final data = res['data'] as Map<String, dynamic>;
    return AuthResult(
      token: data['token'].toString(),
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  /// POST /auth/forgot-password
  Future<void> forgotPassword({required String email}) async {
    await _client.post(ApiConstants.forgotPassword, data: {'email': email});
  }

  /// POST /auth/resend-otp
  Future<void> resendOtp({required String email}) async {
    await _client.post(ApiConstants.resendOtp, data: {'email': email});
  }

  /// POST /auth/verify-otp — يرجع توكن وحساب مباشرة (تسجيل دخول ضمني)
  Future<AuthResult> verifyOtp({required String email, required String code}) async {
    final res = await _client.post(ApiConstants.verifyOtp, data: {
      'email': email,
      'otp': code,
    });
    final data = res['data'] as Map<String, dynamic>;
    return AuthResult(
      token: data['token'].toString(),
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  /// GET /auth/me
  Future<UserModel> me() async {
    final res = await _client.get(ApiConstants.me);
    return UserModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// POST /auth/change-password
  /// الباك إند يحذف كل التوكنات بعد النجاح -> لازم إعادة تسجيل الدخول
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.post(ApiConstants.changePassword, data: {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': newPassword,
    });
  }

  /// POST /auth/logout
  Future<void> logout() async {
    await _client.post(ApiConstants.logout);
  }
}
