// يطابق response الباك إند من AuthController.login / me / trainer/profile
// response shape: { data: { token: "...", user: { id, name, email, role, phone,
//   is_active, is_temp_password, trainer: { id, monthly_salary, max_members, specialties: [...] } } } }
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final bool isActive;
  final bool isTempPassword;
  final TrainerModel? trainer;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    required this.isActive,
    this.isTempPassword = false,
    this.trainer,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name:           json['name']?.toString() ?? '',
      email:          json['email']?.toString() ?? '',
      role:           json['role']?.toString() ?? '',
      phone:          json['phone']?.toString(),
      isActive:       json['is_active'] == true,
      isTempPassword: json['is_temp_password'] == true,
      trainer: json['trainer'] is Map
          ? TrainerModel.fromJson(json['trainer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':               id,
    'name':             name,
    'email':            email,
    'role':             role,
    'phone':            phone,
    'is_active':        isActive,
    'is_temp_password': isTempPassword,
    'trainer':          trainer?.toJson(),
  };
}

class TrainerModel {
  final int id;
  final int userId;
  final double monthlySalary;
  final int maxMembers;
  final List<String> specialties;

  TrainerModel({
    required this.id,
    required this.userId,
    required this.monthlySalary,
    required this.maxMembers,
    this.specialties = const [],
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    final rawSpecialties = json['specialties'];
    return TrainerModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId:        int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      monthlySalary: double.tryParse(json['monthly_salary']?.toString() ?? '') ?? 0.0,
      maxMembers:    int.tryParse(json['max_members']?.toString() ?? '') ?? 0,
      specialties: rawSpecialties is List
          ? rawSpecialties
              .map((s) => (s as Map)['specialty']?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList()
          : <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'id':             id,
    'user_id':        userId,
    'monthly_salary': monthlySalary,
    'max_members':    maxMembers,
    'specialties':    specialties.map((s) => {'specialty': s}).toList(),
  };
}