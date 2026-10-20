/// خطة تمرين يُنشئها المدرب لعضو معيّن
/// GET|POST /trainer/training-plans , GET /trainer/training-plans/{id}
class TrainingPlanModel {
  final int id;
  final int memberId;
  final int trainerId;
  final String title;
  final List<int> trainingDays; // 1..7 (أيام الأسبوع)
  final bool isActive;
  final DateTime? createdAt;
  final List<ExerciseModel> exercises;

  TrainingPlanModel({
    required this.id,
    required this.memberId,
    required this.trainerId,
    required this.title,
    required this.trainingDays,
    required this.isActive,
    this.createdAt,
    this.exercises = const [],
  });

  factory TrainingPlanModel.fromJson(Map<String, dynamic> json) {
    return TrainingPlanModel(
      id:        int.tryParse(json['id'].toString()) ?? 0,
      memberId:  int.tryParse(json['member_id']?.toString() ?? '') ?? 0,
      trainerId: int.tryParse(json['trainer_id']?.toString() ?? '') ?? 0,
      title:     json['title']?.toString() ?? '',
      trainingDays: (json['training_days'] as List?)
              ?.map((d) => int.tryParse(d.toString()) ?? 0)
              .toList() ??
          [],
      isActive: json['is_active'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      exercises: (json['exercises'] as List?)
              ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// تمرين ضمن خطة تمرين
/// POST /trainer/training-plans/{id}/exercises , PUT|DELETE /trainer/exercises/{id}
class ExerciseModel {
  final int id;
  final int trainingPlanId;
  final int? equipmentId;
  final String name;
  final int dayOfWeek;
  final int sets;
  final int reps;
  final int restSeconds;
  final String? notes;
  final EquipmentModel? equipment;

  ExerciseModel({
    required this.id,
    required this.trainingPlanId,
    this.equipmentId,
    required this.name,
    required this.dayOfWeek,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.notes,
    this.equipment,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id:             int.tryParse(json['id'].toString()) ?? 0,
      trainingPlanId: int.tryParse(json['training_plan_id']?.toString() ?? '') ?? 0,
      equipmentId:    json['equipment_id'] != null ? int.tryParse(json['equipment_id'].toString()) : null,
      name:           json['name']?.toString() ?? '',
      dayOfWeek:      int.tryParse(json['day_of_week']?.toString() ?? '') ?? 1,
      sets:           int.tryParse(json['sets']?.toString() ?? '') ?? 0,
      reps:           int.tryParse(json['reps']?.toString() ?? '') ?? 0,
      restSeconds:    int.tryParse(json['rest_seconds']?.toString() ?? '') ?? 0,
      notes:          json['notes']?.toString(),
      equipment: json['equipment'] is Map
          ? EquipmentModel.fromJson(json['equipment'] as Map<String, dynamic>)
          : null,
    );
  }
}

class EquipmentModel {
  final int id;
  final String name;
  final String? description;
  final String status;

  EquipmentModel({
    required this.id,
    required this.name,
    this.description,
    required this.status,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id:          int.tryParse(json['id'].toString()) ?? 0,
      name:        json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      status:      json['status']?.toString() ?? '',
    );
  }
}