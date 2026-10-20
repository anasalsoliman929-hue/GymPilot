// import 'package:flutter/material.dart';

// import '../theme/app_colors.dart';
// import '../../core/theme/app_colors_context.dart';

// /// مؤشر تحميل بسيط يُستخدم بمنتصف الشاشة
// class AppLoading extends StatelessWidget {
//   const AppLoading({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: CircularProgressIndicator(color: AppColors.primary),
//     );
//   }
// }

// /// شاشة خطأ موحّدة مع زر إعادة المحاولة
// class AppErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const AppErrorView({super.key, required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, color: Colors.redAccent, size: 56),
//             const SizedBox(height: 16),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 15),
//             ),
//             const SizedBox(height: 20),
//             OutlinedButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh),
//               label: const Text('إعادة المحاولة'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// حالة "لا توجد بيانات" موحّدة (مثلاً لا توجد خطة تمرين بعد)
// class AppEmptyState extends StatelessWidget {
//   final String message;
//   final IconData icon;
//   final Widget? action;

//   const AppEmptyState({
//     super.key,
//     required this.message,
//     this.icon = Icons.inbox_outlined,
//     this.action,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 64, color: context.textSecondary),
//             const SizedBox(height: 16),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 15, color: context.textSecondary),
//             ),
//             if (action != null) ...[
//               const SizedBox(height: 20),
//               action!,
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
