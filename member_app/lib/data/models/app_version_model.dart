class AppVersionModel {
  final bool updateRequired;
  final bool updateAvailable;
  final bool forceUpdate;
  final String? message;

  AppVersionModel({
    required this.updateRequired,
    required this.updateAvailable,
    required this.forceUpdate,
    this.message,
  });

  /// true إذا كان في تحديث (اختياري أو إجباري) يستحق إشعار المستخدم
  bool get hasUpdate => updateAvailable || updateRequired || forceUpdate;

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      updateRequired:  json['update_required'] == true,
      updateAvailable: json['update_available'] == true,
      forceUpdate:     json['force_update'] == true,
      message:         json['message']?.toString(),
    );
  }
}
