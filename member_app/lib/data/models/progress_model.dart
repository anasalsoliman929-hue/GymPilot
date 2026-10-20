class ProgressEntryModel {
  final int? id;
  final String? createdAt;
  final double? weight;
  final double? bodyFatPercentage;
  final double? chestCircumference;
  final double? waistCircumference;
  final double? armCircumference;
  final String? notes;

  const ProgressEntryModel({
    this.id,
    this.createdAt,
    this.weight,
    this.bodyFatPercentage,
    this.chestCircumference,
    this.waistCircumference,
    this.armCircumference,
    this.notes,
  });

  /// يحوّل القيمة إلى double بغض النظر عن كونها رقماً أو نصاً
  /// (الـ API يُرجع هذه الحقول كنص "85.00" عند القراءة (GET)
  /// وكرقم 78.5 عند الإنشاء (POST) — لذا لا يمكن الاعتماد على `as num?`)
  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory ProgressEntryModel.fromJson(Map<String, dynamic> json) {
    return ProgressEntryModel(
      id:                  json['id'] as int?,
      createdAt:           json['created_at']?.toString(),
      weight:              _toDouble(json['weight']),
      bodyFatPercentage:   _toDouble(json['body_fat_percentage']),
      chestCircumference:  _toDouble(json['chest_circumference']),
      waistCircumference:  _toDouble(json['waist_circumference']),
      armCircumference:    _toDouble(json['arm_circumference']),
      notes:               json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toRequestJson() {
    final map = <String, dynamic>{};
    if (weight != null)              map['weight']              = weight;
    if (bodyFatPercentage != null)   map['body_fat_percentage'] = bodyFatPercentage;
    if (chestCircumference != null)  map['chest_circumference'] = chestCircumference;
    if (waistCircumference != null)  map['waist_circumference'] = waistCircumference;
    if (armCircumference != null)    map['arm_circumference']   = armCircumference;
    if (notes != null && notes!.isNotEmpty) map['notes']        = notes;
    return map;
  }
}

class ProgressHistoryModel {
  final String filter;
  final List<ProgressEntryModel> records;

  const ProgressHistoryModel({
    required this.filter,
    required this.records,
  });

  factory ProgressHistoryModel.fromJson(Map<String, dynamic> json) {
    return ProgressHistoryModel(
      filter:  json['filter']?.toString() ?? 'all',
      records: (json['records'] as List? ?? [])
          .map((e) => ProgressEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}