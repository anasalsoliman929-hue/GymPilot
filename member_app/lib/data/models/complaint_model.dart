class ComplaintModel {
  final int id;
  final int memberId;
  final String subject;
  final String message;
  final String status; // pending | reviewed | resolved ...
  final String? adminResponse;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ComplaintModel({
    required this.id,
    required this.memberId,
    required this.subject,
    required this.message,
    required this.status,
    this.adminResponse,
    this.createdAt,
    this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id:            json['id'] as int? ?? 0,
      memberId:      json['member_id'] as int? ?? 0,
      subject:       json['subject']?.toString() ?? '',
      message:       json['message']?.toString() ?? '',
      status:        json['status']?.toString() ?? 'pending',
      adminResponse: json['admin_response']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}
