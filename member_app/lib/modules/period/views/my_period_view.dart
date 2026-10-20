import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_colors_context.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/my_period_controller.dart';

class MyPeriodView extends StatelessWidget {
  const MyPeriodView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyPeriodController());

    return Scaffold(
      appBar: AppBar(title: Text('my_period_title'.tr)),
      body: Obx(() {
        if (c.isLoading.value) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ShimmerBox(height: 140, radius: 18),
              const SizedBox(height: 16),
              ShimmerBox(height: 100, radius: 18),
            ],
          );
        }

        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }

        final period = c.period.value;
        if (period == null) {
          return AppEmptyState(
            icon: Icons.schedule_outlined,
            message: 'no_period_assigned'.tr,
          );
        }

        final trainer = period.trainer;

        return RefreshIndicator(
          onRefresh: c.load,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Period card ───────────────────────────
              FadeSlideIn(
                child: GradientCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.schedule, color: Colors.white, size: 26),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              period.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoChip(
                              icon: Icons.play_circle_outline,
                              label: 'start_time_label'.tr,
                              value: _formatTime(period.startTime),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoChip(
                              icon: Icons.stop_circle_outlined,
                              label: 'end_time_label'.tr,
                              value: _formatTime(period.endTime),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoChip(
                              icon: period.genderPolicy == 'female'
                                  ? Icons.female
                                  : (period.genderPolicy == 'male'
                                      ? Icons.male
                                      : Icons.people_outline),
                              label: 'gender_label'.tr,
                              value: _genderLabel(period.genderPolicy),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoChip(
                              icon: Icons.groups_outlined,
                              label: 'max_capacity_label'.tr,
                              value: '${period.maxCapacity}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Trainer card ──────────────────────────
              if (trainer != null) ...[
                SectionLabel('trainer_info_title'.tr),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 120),
                  child: SurfaceCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trainer.name,
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'trainer_role_label'.tr,
                                style: TextStyle(color: context.textSecondary, fontSize: 12),
                              ),
                              if (trainer.phone.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.phone_outlined, size: 14, color: context.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(trainer.phone,
                                        style: TextStyle(color: context.textSecondary, fontSize: 13)),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  String _genderLabel(String policy) {
    switch (policy) {
      case 'male':
        return 'male'.tr;
      case 'female':
        return 'female'.tr;
      default:
        return 'mixed_gender'.tr;
    }
  }

  String _formatTime(String raw) {
    // "12:00:00" -> "12:00"
    final parts = raw.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return raw;
  }

}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: Colors.white70),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
