import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gympilot_member/modules/home/controllers/home_controller.dart';
import 'package:gympilot_member/modules/notifications/controllers/notifications_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../../../core/theme/app_colors_context.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;
  late Animation<double> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween(begin: -30.0, end: 0.0).animate(
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr),
        automaticallyImplyLeading: false,
        actions: [
          TapScale(
            onTap: () => Navigator.pushNamed(context, AppRoutes.qrCode),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.borderColor),
                ),
                child:
                    Icon(Icons.qr_code_2, color: context.textPrimary, size: 22),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notifications),
            icon: Obx(() {
              final count =
                  Get.find<NotificationsController>().unreadCount.value;
              return Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: const Icon(Icons.notifications_outlined),
              );
            }),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async =>
            await Future.delayed(const Duration(milliseconds: 800)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─── Greeting card ───────────────────────────
            AnimatedBuilder(
              animation: _headerCtrl,
              builder: (_, child) => Opacity(
                opacity: _headerFade.value,
                child: Transform.translate(
                    offset: Offset(0, _headerSlide.value), child: child),
              ),
              child: GradientCard(
                child: Row(
                  children: [
                    TapScale(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        child:
                            Icon(Icons.person, color: context.textPrimary, size: 32),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('greeting_hi'.tr,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text(c.currentUser.value?.name ?? 'hello_fallback'.tr,
                              style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _SubStat(
                                child: AnimatedCounter(
                                    end: 18,
                                    suffix: 'days_left_suffix'.tr,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              ),
                              const SizedBox(width: 16),
                              _SubStat(
                                child: AnimatedCounter(
                                    end: 24,
                                    suffix: 'attendance_suffix'.tr,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─── Cards staggered ─────────────────────────
            // ─── Cards staggered ─────────────────────────
            FadeSlideIn(
              delay: const Duration(milliseconds: 150),
              child: TapScale(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.workoutPlanFull),
                child: _SectionCard(
                  icon: Icons.fitness_center,
                  title: 'today_workout'.tr,
                  child: Obx(() {
                    final workout = c.todayWorkout.value;
                    if (c.isLoading.value) {
                      return const ShimmerBox(height: 60);
                    }
                    if (workout == null || workout.isRestDay) {
                      return Text(
                        'rest_day'.tr,
                        style: TextStyle(color: context.textSecondary, fontSize: 13),
                      );
                    }
                    final done =
                        workout.exercises.where((e) => e.completed).length;
                    final total = workout.exercises.length;
                    final planTitle =
                        workout.plan?['title']?.toString() ?? 'training_plan_fallback'.tr;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(planTitle,
                            style: TextStyle(
                                color: context.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        const SizedBox(height: 6),
                        Text('exercises_done'.trParams({'done': '$done', 'total': '$total'}),
                            style: TextStyle(
                                color: context.textSecondary, fontSize: 12)),
                        const SizedBox(height: 8),
                        AnimatedProgressBar(
                            value: total > 0 ? done / total : 0),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),

            FadeSlideIn(
              delay: const Duration(milliseconds: 220),
              child: TapScale(
              onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.nutrition),
                child: _SectionCard(
                  icon: Icons.restaurant_menu,
                  title: 'nutrition_title'.tr,
                  child: Row(
                    children: [
                      AnimatedCounter(
                        end: 2400,
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text('calories_per_day'.tr,
                          style:
                              TextStyle(color: context.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            FadeSlideIn(
              delay: const Duration(milliseconds: 290),
              child: TapScale(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.addProgress),
                child: _SectionCard(
                  icon: Icons.monitor_weight_outlined,
                  title: 'last_measurement'.tr,
                  child: Row(
                    children: [
                      MiniStat(value: 'weight_value_kg'.tr, label: 'weight_label'.tr),
                      const SizedBox(width: 20),
                      MiniStat(value: '18%', label: 'fat_label'.tr),
                      const SizedBox(width: 20),
                      MiniStat(value: 'height_value_cm'.tr, label: 'height_label'.tr),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ─── Quick actions ────────────────────────────
            FadeSlideIn(
              delay: const Duration(milliseconds: 360),
              child: Row(
                children: [
                  Expanded(
                    child: TapScale(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.qrCode),
                      child:
                          _QuickAction(icon: Icons.qr_code_2, label: 'qr_code_label'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TapScale(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.addProgress),
                      child: _QuickAction(
                          icon: Icons.add_chart, label: 'log_measurement'.tr),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SubStat extends StatelessWidget {
  final Widget child;
  const _SubStat({required this.child});
  @override
  Widget build(BuildContext context) => child;
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionCard(
      {required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      color: context.textPrimary, fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(Icons.chevron_right, color: context.textSecondary, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(color: context.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}
