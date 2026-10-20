import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/app_version_model.dart';
import '../models/gym_info_model.dart';
import '../models/legal_document_model.dart';

class PublicRepository {
  final ApiClient _client;
  PublicRepository(this._client);

  /// GET /public/app-version?platform=&version= — لا يحتاج توكن
  Future<AppVersionModel> checkAppVersion({
    required String platform,
    required String version,
  }) async {
    final res = await _client.get(
      ApiConstants.appVersion,
      query: {'platform': platform, 'version': version},
    );
    return AppVersionModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// GET /public/gym-info — لا يحتاج توكن
  Future<GymInfoModel> getGymInfo() async {
    final res = await _client.get(ApiConstants.gymInfo);
    return GymInfoModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  /// GET /public/legal-documents — قائمة المستندات (بدون محتوى كامل)
  Future<List<LegalDocumentSummary>> getLegalDocuments() async {
    final res = await _client.get(ApiConstants.legalDocuments);
    final list = res['data'] as List;
    return list
        .map((e) => LegalDocumentSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /public/legal-documents/{key} — محتوى مستند واحد كامل
  Future<LegalDocumentModel> getLegalDocument(String key) async {
    final res = await _client.get(ApiConstants.legalDocument(key));
    return LegalDocumentModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
