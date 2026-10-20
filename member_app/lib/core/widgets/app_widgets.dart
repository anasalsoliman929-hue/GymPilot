import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../../core/theme/app_colors_context.dart';
import 'app_animations.dart';

// ─── Loading ───────────────────────────────────────────────
/// هيكل تحميل عصري (shimmer) بدل الحلقة الدوارة — يُستخدم كبديل
/// عام لأي شاشة تعرض بطاقة رأسية + قائمة عناصر أثناء التحميل
class AppLoading extends StatelessWidget {
  final int itemCount;
  const AppLoading({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ShimmerBox(height: 120, radius: 18),
        const SizedBox(height: 20),
        ShimmerBox(width: 140, height: 14, radius: 6),
        const SizedBox(height: 14),
        ...List.generate(
          itemCount,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ShimmerBox(height: 78, radius: 16),
          ),
        ),
      ],
    );
  }
}

// ─── Error ─────────────────────────────────────────────────
class AppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const AppErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 56),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty ──────────────────────────────────────────────────
class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action;
  const AppEmptyState({super.key, required this.message, this.icon = Icons.inbox_outlined, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: context.textSecondary),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: context.textSecondary)),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

// ─── Gradient card (header) ─────────────────────────────────
class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

// ─── Dark surface card ──────────────────────────────────────
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double radius;
  const SurfaceCard({super.key, required this.child, this.padding, this.onTap, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: context.borderColor),
        ),
        child: child,
      ),
    );
  }
}

// ─── Primary button (full width) ────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? color;
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: context.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: context.textPrimary),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
                  Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}

// ─── Input field wrapper ─────────────────────────────────────
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final String? suffixText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscure = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.maxLines = 1,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style: const TextStyle(
                  color: Color(0xFFCCCCCC), fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          maxLines: maxLines,
          style: TextStyle(color: context.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: context.textSecondary) : null,
            suffixIcon: suffix,
            suffixText: suffixText,
            suffixStyle: TextStyle(color: context.textSecondary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

// ─── Section label ───────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text,
            style: TextStyle(
                color: context.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
      );
}

// ─── Stat mini widget ────────────────────────────────────────
class MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const MiniStat({super.key, required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
        Text(label, style: TextStyle(color: context.textSecondary, fontSize: 11)),
      ],
    );
  }
}

// ─── Progress bar ────────────────────────────────────────────
class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 - 1.0
  const AppProgressBar({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        backgroundColor: context.borderColor,
        color: AppColors.primary,
        minHeight: 7,
      ),
    );
  }
}


