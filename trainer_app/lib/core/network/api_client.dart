import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../constants/api_constants.dart';
import '../network/api_exception.dart';
import '../services/storage_service.dart';

/// عميل API واحد لكل التطبيق — مبني فوق Dio
///
/// مسؤول عن:
///  - إرفاق Authorization header تلقائياً مع كل طلب
///  - تحويل أي خطأ من السيرفر إلى [ApiException] موحّد
///  - تسجيل خروج المدرب تلقائياً عند انتهاء صلاحية التوكن (401)
///  - إعادة توجيهه تلقائياً لشاشة تغيير كلمة المرور المؤقتة
///    عندما يرجع الباك إند { success: false, action: "change_password" }
class ApiClient {
  late final Dio _dio;
  final StorageService _storage = Get.find<StorageService>();

  /// يُستدعى عند تسجيل الخروج التلقائي (401) لتنظيف الجلسة
  /// والرجوع لشاشة تسجيل الدخول من أي مكان بالتطبيق
  void Function()? onUnauthorized;

  /// يُستدعى عندما يكتشف أي طلب أن المدرب مازال يستخدم
  /// كلمة المرور المؤقتة ولم يغيّرها بعد
  void Function()? onMustChangePassword;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // التوكن انتهى أو غير صالح — ننظف الجلسة وننادي الـ callback
            _storage.clearSession();
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  // ─── HTTP Verbs ──────────────────────────────────────────
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _request(() => _dio.get(path, queryParameters: query));

  Future<Map<String, dynamic>> post(String path, {dynamic data}) =>
      _request(() => _dio.post(path, data: data));

  Future<Map<String, dynamic>> put(String path, {dynamic data}) =>
      _request(() => _dio.put(path, data: data));

  Future<Map<String, dynamic>> patch(String path, {dynamic data}) =>
      _request(() => _dio.patch(path, data: data));

  Future<Map<String, dynamic>> delete(String path) =>
      _request(() => _dio.delete(path));

  // ─── Core request wrapper ────────────────────────────────
  Future<Map<String, dynamic>> _request(
    Future<Response> Function() call,
  ) async {
    try {
      final response = await call();
      final body = response.data;

      if (body is Map<String, dynamic>) {
        // بعض مسارات /trainer/* ترجع 200 مع success:false
        // عندما يكون المدرب لسا عم يستخدم كلمة المرور المؤقتة
        if (body['success'] == false) {
          final action = body['action']?.toString();
          if (action == 'change_password') {
            onMustChangePassword?.call();
          }
          throw ApiException(
            message: body['message']?.toString() ?? 'حدث خطأ، حاول مرة أخرى',
            statusCode: response.statusCode,
            action: action,
          );
        }
        return body;
      }
      return {'success': true, 'data': body};
    } on DioException catch (e) {
      throw _mapError(e);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'حدث خطأ غير متوقع: $e');
    }
  }

  ApiException _mapError(DioException e) {
    final response = e.response;

    if (response == null) {
      // لا يوجد اتصال بالسيرفر أصلاً
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return ApiException(
          message:
              'تعذّر الوصول إلى السيرفر. تأكد من اتصالك بالإنترنت وأن السيرفر يعمل.',
        );
      }
      return ApiException(message: 'حدث خطأ في الاتصال بالسيرفر');
    }

    final data = response.data;
    String message = 'حدث خطأ، حاول مرة أخرى';
    String? action;
    Map<String, List<String>>? errors;

    if (data is Map<String, dynamic>) {
      message = data['message']?.toString() ?? message;
      action = data['action']?.toString();
      final rawErrors = data['errors'];
      if (rawErrors is Map) {
        errors = rawErrors.map(
          (key, value) => MapEntry(
            key.toString(),
            (value as List).map((e) => e.toString()).toList(),
          ),
        );
      }
    }

    if (action == 'change_password') {
      onMustChangePassword?.call();
    }

    return ApiException(
      message: message,
      statusCode: response.statusCode,
      errors: errors,
      action: action,
    );
  }
}
