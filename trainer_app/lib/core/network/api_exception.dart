/// استثناء موحّد لكل أخطاء الـ API
///
/// الباك إند (GymFlow) يرجّع دايماً نفس الشكل عند الخطأ:
/// { "success": false, "message": "...", "errors": { "field": ["..."] } }
/// هاي الكلاس بتلخّص هاذا الشكل بطريقة سهلة الاستخدام بالـ UI
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? errors;
  final String? action;

  ApiException({required this.message, this.statusCode, this.errors, this.action});

  /// المدرب يسجّل دخوله بكلمة مرور مؤقتة يعطيه إياها الأدمن —
  /// أي طلب لمسارات /trainer/* قبل تغييرها يرجع هاذا الـ action
  bool get mustChangePassword => action == 'change_password';

  /// أول رسالة خطأ تفصيلية (لو موجودة) وإلا الرسالة العامة
  String get firstError {
    if (errors != null && errors!.isNotEmpty) {
      final firstField = errors!.values.first;
      if (firstField.isNotEmpty) return firstField.first;
    }
    return message;
  }

  bool get isUnauthorized => statusCode == 401;

  bool get isValidationError => statusCode == 422;

  bool get isConflict => statusCode == 409;

  bool get isNotFound => statusCode == 404;

  @override
  String toString() => message;
}
