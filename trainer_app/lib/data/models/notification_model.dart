/// إشعار المدرب — GET /trainer/notifications (Laravel pagination)
class NotificationModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.data,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId:  int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      title:   json['title']?.toString() ?? '',
      body:    json['body']?.toString() ?? '',
      type:    json['type']?.toString() ?? 'system',
      isRead:  json['is_read'] == true,
      data:    json['data'] is Map ? Map<String, dynamic>.from(json['data'] as Map) : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      isRead: isRead ?? this.isRead,
      data: data,
      createdAt: createdAt,
    );
  }
}