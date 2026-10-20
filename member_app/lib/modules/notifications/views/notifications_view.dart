import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/notifications_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NotificationsController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('notifications_title'.tr),
            if (c.unreadCount.value > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${c.unreadCount.value}',
                  style: TextStyle(color: context.textPrimary, fontSize: 12),
                ),
              ),
            ],
          ],
        )),
        actions: [
          Obx(() => c.unreadCount.value > 0
              ? TextButton(
                  onPressed: c.markAllRead,
                  child: Text('mark_all_read'.tr,
                      style: TextStyle(color: AppColors.primary, fontSize: 13)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: List.generate(
              5,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ShimmerBox(height: 80, radius: 14),
              ),
            ),
          );
        }

        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }

        if (c.notifications.isEmpty) {
          return AppEmptyState(
            icon: Icons.notifications_outlined,
            message: 'no_notifications_yet'.tr,
          );
        }

        return RefreshIndicator(
          onRefresh: c.load,
          color: AppColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: c.notifications.length,
            itemBuilder: (_, i) {
              final n      = c.notifications[i] as Map;
              final isRead = n['is_read'] == true || n['is_read'] == 1;
              final id     = n['id'] as int;
              final type   = n['type']?.toString() ?? '';

              return FadeSlideIn(
                delay: Duration(milliseconds: 40 * i),
                child: GestureDetector(
                  onTap: () { if (!isRead) c.markRead(id); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isRead
                          ? context.cardColor
                          : AppColors.primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isRead
                            ? context.borderColor
                            : AppColors.primary.withOpacity(0.35),
                        width: isRead ? 1 : 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(
                            color: _typeColor(context, type).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _typeIcon(type),
                            color: _typeColor(context, type),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      n['title']?.toString() ?? '',
                                      style: TextStyle(
                                        color: context.textPrimary,
                                        fontWeight: isRead
                                            ? FontWeight.w400
                                            : FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  if (!isRead)
                                    Container(
                                      width: 8, height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n['body']?.toString() ?? '',
                                style: TextStyle(
                                    color: context.textSecondary,
                                    fontSize: 12,
                                    height: 1.5),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatDate(n['created_at']?.toString()),
                                style: TextStyle(
                                    color: context.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'subscription_expiry': return Icons.card_membership_outlined;
      case 'wallet_topup':        return Icons.account_balance_wallet_outlined;
      case 'system':              return Icons.info_outline;
      case 'training_plan':       return Icons.fitness_center_outlined;
      case 'nutrition_plan':      return Icons.restaurant_outlined;
      default:                    return Icons.notifications_outlined;
    }
  }

  Color _typeColor(BuildContext context, String type) {
    switch (type) {
      case 'subscription_expiry': return AppColors.primary;
      case 'wallet_topup':        return AppColors.success;
      case 'system':              return const Color(0xFF74B9FF);
      case 'training_plan':       return AppColors.primaryLight;
      case 'nutrition_plan':      return const Color(0xFF4ECDC4);
      default:                    return context.textSecondary;
    }
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60)  return 'minutes_ago'.trParams({'n': '${diff.inMinutes}'});
      if (diff.inHours < 24)    return 'hours_ago'.trParams({'n': '${diff.inHours}'});
      if (diff.inDays < 7)      return 'days_ago'.trParams({'n': '${diff.inDays}'});
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}