import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/complaint_model.dart';

class ComplaintRepository {
  final ApiClient _client;
  ComplaintRepository(this._client);

  /// GET /member/complaints — pagination: data.data
  Future<List<ComplaintModel>> getComplaints() async {
    final res = await _client.get(ApiConstants.memberComplaints);
    final data = res['data'];
    final list = (data is Map && data.containsKey('data'))
        ? data['data'] as List
        : (data is List ? data : <dynamic>[]);
    return list
        .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /member/complaints/{id}
  Future<ComplaintModel> getComplaint(int id) async {
    final res = await _client.get(ApiConstants.memberComplaint(id));
    return ComplaintModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// POST /member/complaints
  Future<ComplaintModel> submitComplaint({
    required String subject,
    required String message,
  }) async {
    final res = await _client.post(
      ApiConstants.memberComplaints,
      data: {'subject': subject, 'message': message},
    );
    return ComplaintModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
