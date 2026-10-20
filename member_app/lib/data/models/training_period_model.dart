import 'user_model.dart';

class TrainerModel {
  final int id;
  final int userId;
  final double? monthlySalary;
  final int? maxMembers;
  final UserModel? user;

  TrainerModel({
    required this.id,
    required this.userId,
    this.monthlySalary,
    this.maxMembers,
    this.user,
  });

  /// اسم المدرب — من بيانات المستخدم المرتبطة
  String get name => user?.name ?? '';

  /// رقم هاتف المدرب
  String get phone => user?.phone ?? '';

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id:            json['id'] as int? ?? 0,
      userId:        json['user_id'] as int? ?? 0,
      monthlySalary: double.tryParse(json['monthly_salary']?.toString() ?? ''),
      maxMembers:    json['max_members'] as int?,
      user: json['user'] is Map
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TrainingPeriodModel {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final String genderPolicy;
  final int maxCapacity;
  final int trainerId;
  final bool isActive;
  final TrainerModel? trainer;

  TrainingPeriodModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.genderPolicy,
    required this.maxCapacity,
    required this.trainerId,
    required this.isActive,
    this.trainer,
  });

  factory TrainingPeriodModel.fromJson(Map<String, dynamic> json) {
    return TrainingPeriodModel(
      id:           json['id'] as int? ?? 0,
      name:         json['name']?.toString() ?? '',
      startTime:    json['start_time']?.toString() ?? '',
      endTime:      json['end_time']?.toString() ?? '',
      genderPolicy: json['gender_policy']?.toString() ?? '',
      maxCapacity:  json['max_capacity'] as int? ?? 0,
      trainerId:    json['trainer_id'] as int? ?? 0,
      isActive:     json['is_active'] == true,
      trainer: json['trainer'] is Map
          ? TrainerModel.fromJson(json['trainer'] as Map<String, dynamic>)
          : null,
    );
  }
}
