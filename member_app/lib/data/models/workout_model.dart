import 'package:get/get.dart';

class TodayWorkoutModel {
  final bool isRestDay;
  final int? day;
  final Map<String, dynamic>? plan;
  final List<ExerciseModel> exercises;

  TodayWorkoutModel({
    required this.isRestDay,
    this.day,
    this.plan,
    required this.exercises,
  });

  factory TodayWorkoutModel.fromJson(Map<String, dynamic> json) {
    return TodayWorkoutModel(
      isRestDay: json['is_rest_day'] == true,
      day:       json['day'] as int?,
      plan:      json['plan'] as Map<String, dynamic>?,
      exercises: (json['exercises'] as List? ?? [])
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WorkoutPlanModel {
  final Map<String, dynamic> plan;
  final Map<String, List<ExerciseModel>> exercisesByDay;

  WorkoutPlanModel({required this.plan, required this.exercisesByDay});

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    final rawByDay = json['exercises_by_day'] as Map<String, dynamic>? ?? {};
    final byDay = rawByDay.map((key, value) {
      final list = (value as List)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return MapEntry(key, list);
    });
    return WorkoutPlanModel(
      plan:           json['plan'] as Map<String, dynamic>? ?? {},
      exercisesByDay: byDay,
    );
  }
}

class ExerciseModel {
  final int id;
  final String name;
  final int sets;
  final int reps;
  final int? restSeconds;
  final String? notes;
  final int? dayOfWeek;
  final String? equipmentName;
  bool completed;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    this.restSeconds,
    this.notes,
    this.dayOfWeek,
    this.equipmentName,
    this.completed = false,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id:            json['id'] as int,
      name:          json['name']?.toString() ?? '',
      sets:          json['sets'] as int? ?? 0,
      reps:          json['reps'] as int? ?? 0,
      restSeconds:   json['rest_seconds'] as int?,
      notes:         json['notes']?.toString(),
      dayOfWeek:     json['day_of_week'] as int?,
      equipmentName: (json['equipment'] as Map?)?['name']?.toString(),
    );
  }

  String get details =>
      '$sets ${'sets_label'.tr} • $reps ${'reps_label'.tr}${restSeconds != null ? ' • ${'rest_seconds_label'.tr.replaceAll('@s', '$restSeconds')}' : ''}';
}

Map<int, String> get dayNames => {
  1: 'day_mon'.tr, 2: 'day_tue'.tr, 3: 'day_wed'.tr,
  4: 'day_thu'.tr, 5: 'day_fri'.tr, 6: 'day_sat'.tr, 7: 'day_sun'.tr,
};