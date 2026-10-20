import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/members_controller.dart';

class MembersView extends StatelessWidget {
  const MembersView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MembersController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('members_title'.tr),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              onChanged: (v) => c.searchController.value = v,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'search_member_hint'.tr,
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) return const AppLoading();
              if (c.error != null) {
                return AppErrorView(message: c.error!, onRetry: c.load);
              }
              final list = c.filtered;
              if (list.isEmpty) {
                return AppEmptyState(
                  message: 'no_matching_members'.tr,
                  icon: Icons.groups_outlined,
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: c.load,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final m = list[i];
                    final sub = m.activeSubscription;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FadeSlideIn(
                        delay: Duration(milliseconds: 40 * i),
                        child: SurfaceCard(
                          onTap: () => Get.toNamed(AppRoutes.memberDetails, arguments: m.id),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
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
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600, fontSize: 15)),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Icon(
                                          sub != null && sub.status == 'active'
                                              ? Icons.check_circle
                                              : Icons.remove_circle_outline,
                                          size: 13,
                                          color: sub != null && sub.status == 'active'
                                              ? AppColors.success
                                              : Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          sub != null
                                              ? (sub.status == 'active' ? 'sub_active'.tr : 'sub_status'.trParams({'status': sub.status}))
                                              : 'no_subscription'.tr,
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (m.activeTrainingPlan != null)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.fitness_center, color: AppColors.primary, size: 16),
                                ),
                              if (m.activeNutritionPlan != null)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.restaurant_menu, color: AppColors.primary, size: 16),
                                ),
                              Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
