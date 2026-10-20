import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('nav_home'.tr),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) return const AppLoading();
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
         
        }

        final trainer = c.profile.value?.trainer;
        final maxMembers = trainer?.maxMembers ?? 0;
        final currentMembers = c.members.length;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: c.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Greeting card ───────────────────────────
              FadeSlideIn(
                child: GradientCard(
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.sports_gymnastics, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('greeting_hi'.tr,
                                style: TextStyle(color: Colors.white70, fontSize: 13)),
                            Text(c.profile.value?.name ?? 'trainer_default_name'.tr,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                MiniStat(
                                  value: '$currentMembers${maxMembers > 0 ? '/$maxMembers' : ''}',
                                  label: 'nav_members'.tr,
                                ),
                                const SizedBox(width: 24),
                                MiniStat(
                                  value: '${c.activeSubscriptionsCount}',
                                  label: 'active_subscriptions'.tr,
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

              const SizedBox(height: 16),

              // ─── Specialties ──────────────────────────────
              if (trainer != null && trainer.specialties.isNotEmpty) ...[
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: SectionLabel('my_specialties'.tr),
                ),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trainer.specialties
                        .map((s) => Chip(
                              label: Text(_specialtyLabel(s)),
                              backgroundColor: Theme.of(context).cardColor,
                              side: BorderSide(color: Theme.of(context).dividerColor),
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ─── Quick action ─────────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 140),
                child: SurfaceCard(
                  onTap: () => Get.find<MainController>().changeTab(1),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.groups, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('manage_my_members'.tr,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Recent members ───────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 180),
                child: SectionLabel('recent_members'.tr),
              ),
              if (c.members.isEmpty)
                AppEmptyState(
                  message: 'no_linked_members'.tr,
                  icon: Icons.groups_outlined,
                )
              else
                ...c.members.take(5).toList().asMap().entries.map((e) {
                  final m = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FadeSlideIn(
                      delay: Duration(milliseconds: 200 + (e.key * 60)),
                      child: SurfaceCard(
                        onTap: () => Get.toNamed(AppRoutes.memberDetails, arguments: m.id),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary.withOpacity(0.15),
                              child: Text(
                                m.name.isNotEmpty ? m.name.characters.first : '?',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.name,
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                                  if (m.activeSubscription != null)
                                    Text(
                                      m.activeSubscription!.status == 'active' ? 'sub_active'.tr : 'sub_expired'.tr,
                                      style: TextStyle(
                                        color: m.activeSubscription!.status == 'active'
                                            ? AppColors.success
                                            : Theme.of(context).colorScheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    )
                                  else
                                    Text('no_active_subscription'.tr,
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  String _specialtyLabel(String key) {
    final map = {
      'bodybuilding': 'specialty_bodybuilding'.tr,
      'weight_loss': 'specialty_weight_loss'.tr,
      'fitness': 'specialty_fitness'.tr,
      'crossfit': 'specialty_crossfit'.tr,
    };
    return map[key] ?? key;
  }
}
