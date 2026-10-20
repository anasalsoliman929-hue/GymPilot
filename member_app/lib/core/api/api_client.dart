import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class ApiClient {
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: AppStrings.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }



  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return _dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppStrings.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: AppStrings.tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: AppStrings.tokenKey);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;

  factory ApiException.fromDioError(DioException e) {
    String message = 'حدث خطأ ما، يرجى المحاولة مجدداً';
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = 'انتهت مهلة الاتصال، تحقق من الإنترنت';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'تعذر الاتصال بالخادم';
    }
    return ApiException(
      message: message,
      statusCode: e.response?.statusCode,
    );
  }
}
