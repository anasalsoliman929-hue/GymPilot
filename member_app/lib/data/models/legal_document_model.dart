class LegalDocumentSummary {
  final int id;
  final String key;
  final String title;
  final String version;

  LegalDocumentSummary({
    required this.id,
    required this.key,
    required this.title,
    required this.version,
  });

  factory LegalDocumentSummary.fromJson(Map<String, dynamic> json) {
    return LegalDocumentSummary(
      id:      json['id'] as int? ?? 0,
      key:     json['key']?.toString() ?? '',
      title:   json['title']?.toString() ?? '',
      version: json['version']?.toString() ?? '',
    );
  }
}

class LegalDocumentModel {
  final String key;
  final String title;
  final String content;
  final String version;

  LegalDocumentModel({
    required this.key,
    required this.title,
    required this.content,
    required this.version,
  });

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(
      key:     json['key']?.toString() ?? '',
      title:   json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      version: json['version']?.toString() ?? '',
    );
  }
}
