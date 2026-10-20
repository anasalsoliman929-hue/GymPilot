// يطابق response الباك إند من AuthController.login / verifyOtp / me
// response shape: { data: { token: "...", user: { id, name, email, role, phone, is_active, member: {..., wallet: {...}} } } }
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final bool isActive;
  final bool isTempPassword;
  final MemberModel? member;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    required this.isActive,
    this.isTempPassword = false,
    this.member,
  });

  bool get isMember  => role == 'member';
  bool get isTrainer => role == 'trainer';
  bool get isAdmin   => role == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:              json['id'] as int,
      name:            json['name']?.toString() ?? '',
      email:           json['email']?.toString() ?? '',
      role:            json['role']?.toString() ?? '',
      phone:           json['phone']?.toString(),
      isActive:        json['is_active'] == true,
      isTempPassword:  json['is_temp_password'] == true,
      member: json['member'] is Map
          ? MemberModel.fromJson(json['member'] as Map<String, dynamic>)
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
    'member':           member?.toJson(),
  };
}
class MemberModel {
  final int id;
  final String? gender;
  final String? dateOfBirth;
  final double? height;
  final double? initialWeight;
  final String? goal;
  final bool isVerified;
  final String? qrToken;
  final WalletModel? wallet;

  MemberModel({
    required this.id,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.initialWeight,
    this.goal,
    required this.isVerified,
    this.qrToken,
    this.wallet,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id:            json['id'] as int,
      gender:        json['gender']?.toString(),
      dateOfBirth:   json['date_of_birth']?.toString(),
      height:        double.tryParse(json['height']?.toString() ?? ''),
      initialWeight: double.tryParse(json['initial_weight']?.toString() ?? ''),
      goal:          json['goal']?.toString(),
      isVerified:    json['is_verified'] == true,
      qrToken:       json['qr_token']?.toString(),
      wallet: json['wallet'] is Map
          ? WalletModel.fromJson(json['wallet'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':             id,
    'gender':         gender,
    'date_of_birth':  dateOfBirth,
    'height':         height,
    'initial_weight': initialWeight,
    'goal':           goal,
    'is_verified':    isVerified,
    'qr_token':       qrToken,
    'wallet':         wallet?.toJson(),
  };
}

class WalletModel {
  final int id;
  final double balance;

  WalletModel({required this.id, required this.balance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id:      json['id'] as int,
      balance: double.tryParse(json['balance']?.toString() ?? '') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':      id,
    'balance': balance,
  };
}