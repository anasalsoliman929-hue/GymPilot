import 'training_plan_model.dart';
import 'nutrition_plan_model.dart';

/// عضو ضمن قائمة أعضاء المدرب
/// GET /trainer/members , GET /trainer/members/{id}
class MemberModel {
  final int id;
  final int userId;
  final String? dateOfBirth;
  final String? gender;
  final double? height;
  final double? initialWeight;
  final String? goal;
  final String? medicalNotes;
  final String? qrToken;
  final bool isVerified;
  final MemberUserModel? user;
  final SubscriptionModel? activeSubscription;
  final TrainingPlanModel? activeTrainingPlan;
  final NutritionPlanModel? activeNutritionPlan;

  /// شكل عناصر هاي القوائم لسا غير موثّق من الباك إند (رجعت فاضية بالتجربة)
  /// فبتنعرض بشكل عام حسب المفاتيح الموجودة بكل عنصر
  final List<Map<String, dynamic>> progressTracking;
  final List<Map<String, dynamic>> attendance;

  MemberModel({
    required this.id,
    required this.userId,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.initialWeight,
    this.goal,
    this.medicalNotes,
    this.qrToken,
    required this.isVerified,
    this.user,
    this.activeSubscription,
    this.activeTrainingPlan,
    this.activeNutritionPlan,
    this.progressTracking = const [],
    this.attendance = const [],
  });

  String get name => user?.name ?? 'عضو #$id';

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId:        json['user_id'] as int? ?? 0,
      dateOfBirth:   json['date_of_birth']?.toString(),
      gender:        json['gender']?.toString(),
      height:        double.tryParse(json['height']?.toString() ?? ''),
      initialWeight: double.tryParse(json['initial_weight']?.toString() ?? ''),
      goal:          json['goal']?.toString(),
      medicalNotes:  json['medical_notes']?.toString(),
      qrToken:       json['qr_token']?.toString(),
      isVerified:    json['is_verified'] == true,
      user: json['user'] is Map
          ? MemberUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      activeSubscription: json['active_subscription'] is Map
          ? SubscriptionModel.fromJson(json['active_subscription'] as Map<String, dynamic>)
          : null,
      activeTrainingPlan: json['active_training_plan'] is Map
          ? TrainingPlanModel.fromJson(json['active_training_plan'] as Map<String, dynamic>)
          : null,
      activeNutritionPlan: json['active_nutrition_plan'] is Map
          ? NutritionPlanModel.fromJson(json['active_nutrition_plan'] as Map<String, dynamic>)
          : null,
      progressTracking: (json['progress_tracking'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      attendance: (json['attendance'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }
}

/// حساب المستخدم الأساسي التابع للعضو (اسم، بريد، هاتف)
class MemberUserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final bool isActive;

  MemberUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.isActive,
  });

  factory MemberUserModel.fromJson(Map<String, dynamic> json) {
    return MemberUserModel(
      id:       json['id'] as int,
      name:     json['name']?.toString() ?? '',
      email:    json['email']?.toString() ?? '',
      phone:    json['phone']?.toString(),
      isActive: json['is_active'] == true,
    );
  }
}

/// اشتراك العضو النشط — للاطلاع فقط من طرف المدرب
class SubscriptionModel {
  final int id;
  final String trainingType;
  final List<int> trainingDays;
  final String startDate;
  final String endDate;
  final String status;
  final SubscriptionTypeModel? subscriptionType;

  SubscriptionModel({
    required this.id,
    required this.trainingType,
    required this.trainingDays,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.subscriptionType,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id:           json['id'] as int,
      trainingType: json['training_type']?.toString() ?? '',
      trainingDays: (json['training_days'] as List?)?.map((d) => d as int).toList() ?? [],
      startDate:    json['start_date']?.toString() ?? '',
      endDate:      json['end_date']?.toString() ?? '',
      status:       json['status']?.toString() ?? '',
      subscriptionType: json['subscription_type'] is Map
          ? SubscriptionTypeModel.fromJson(json['subscription_type'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SubscriptionTypeModel {
  final int id;
  final String name;
  final int durationMonths;
  final double price;

  SubscriptionTypeModel({
    required this.id,
    required this.name,
    required this.durationMonths,
    required this.price,
  });

  factory SubscriptionTypeModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionTypeModel(
      id:             json['id'] as int,
      name:           json['name']?.toString() ?? '',
      durationMonths: json['duration_months'] as int? ?? 0,
      price:          double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
    );
  }
}
