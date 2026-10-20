import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _client;
  AuthRepository(this._client);

  Future<({String token, UserModel user})> login({
    required String email,
    required String password,
  }) async {
    final res = await _client
        .post(ApiConstants.login, data: {'email': email, 'password': password});
    final data = res['data'] as Map<String, dynamic>;
    return (
      token: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>)
    );
  }

  Future<String> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String dateOfBirth,
    required String gender,
    double? height,
    double? initialWeight,
    String? goal,
  }) async {
    await _client.post(ApiConstants.register, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      if (height != null) 'height': height,
      if (initialWeight != null) 'initial_weight': initialWeight,
      if (goal != null && goal.isNotEmpty) 'goal': goal,
    });
    return email;
  }

  Future<({String token, UserModel user})> verifyOtp({
    required String email,
    required String code,
  }) async {
    final res = await _client.post(
      ApiConstants.verifyOtp,
      data: {'email': email, 'code': code},
    );
    final data = res['data'] as Map<String, dynamic>;
    return (
      token: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>)
    );
  }

  Future<void> resendOtp({required String email}) async {
    await _client.post(ApiConstants.resendOtp, data: {'email': email});
  }

  Future<UserModel> me() async {
    final res = await _client.get(ApiConstants.me);
    final raw = res['data'];
    if (raw is Map<String, dynamic> && raw.containsKey('user')) {
      return UserModel.fromJson(raw['user'] as Map<String, dynamic>);
    }
    return UserModel.fromJson(raw as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _client.post(ApiConstants.logout);
    } catch (_) {}
  }

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
}
