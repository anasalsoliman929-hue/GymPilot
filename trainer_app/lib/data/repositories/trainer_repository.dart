import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../models/member_model.dart';

class TrainerRepository {
  final ApiClient _client;
  TrainerRepository(this._client);

  /// GET /trainer/profile
  Future<UserModel> getProfile() async {
    final res = await _client.get(ApiConstants.trainerProfile);
    return UserModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// PUT /trainer/profile
  Future<UserModel> updateProfile({String? name, String? phone}) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    final res = await _client.put(ApiConstants.trainerProfile, data: body);
    return UserModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// GET /trainer/members
  Future<List<MemberModel>> getMembers() async {
    final res = await _client.get(ApiConstants.trainerMembers);
    final data = res['data'];
    if (data is! List) return [];
    return data
        .map((m) => MemberModel.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  /// GET /trainer/members/{id}
  Future<MemberModel> getMemberDetails(int id) async {
    final res = await _client.get(ApiConstants.trainerMemberDetails(id));
    return MemberModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// GET /trainer/members/{id}/progress
  Future<Map<String, dynamic>> getMemberProgress(int id) async {
    final res = await _client.get(ApiConstants.trainerMemberProgress(id));
    return res['data'] as Map<String, dynamic>;
  }
}
