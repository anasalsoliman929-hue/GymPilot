// import 'package:flutter/material.dart';

// /// زر أساسي موحّد بكل التطبيق — يدعم حالة التحميل تلقائياً
// class AppPrimaryButton extends StatelessWidget {
//   final String label;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//   final IconData? icon;
//   final Color? color;

//   const AppPrimaryButton({
//     super.key,
//     required this.label,
//     required this.onPressed,
//     this.isLoading = false,
//     this.icon,
//     this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: isLoading ? null : onPressed,
//       style: color != null
//           ? ElevatedButton.styleFrom(backgroundColor: color)
//           : null,
//       child: isLoading
//           ? const SizedBox(
//               height: 22,
//               width: 22,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.4,
//                 color: Colors.white,
//               ),
//             )
//           : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (icon != null) ...[
//                   Icon(icon, size: 20),
//                   const SizedBox(width: 8),
//                 ],
//                 Text(label),
//               ],
//             ),
//     );
//   }
// }
