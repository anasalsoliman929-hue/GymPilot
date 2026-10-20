import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/progress_model.dart';

class ProgressRepository {
  final ApiClient _client;
  ProgressRepository(this._client);

  /// GET /member/progress?filter=week|month|all
  Future<ProgressHistoryModel> getHistory({String filter = 'all'}) async {
    final res = await _client.get(
      ApiConstants.memberProgress,
      query: {'filter': filter},
    );
    return ProgressHistoryModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// POST /member/progress
  Future<ProgressEntryModel> addEntry(ProgressEntryModel entry) async {
    final res = await _client.post(
      ApiConstants.memberProgress,
      data: entry.toRequestJson(),
    );
    return ProgressEntryModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
