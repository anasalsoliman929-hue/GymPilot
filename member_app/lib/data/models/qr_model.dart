// الباك إند يرجع qr_token كـ String مباشرة
// لا حاجة لكلاس منفصل — نستخدم String مباشرة في MemberRepository
// هذا الملف محفوظ للتوافق مع الـ imports القديمة

class QrDataModel {
  final String qrToken;
  QrDataModel({required this.qrToken});
  factory QrDataModel.fromJson(Map<String, dynamic> json) =>
      QrDataModel(qrToken: json['qr_token']?.toString() ?? '');
}
