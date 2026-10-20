import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../data/models/notification_model.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NotificationsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('notifications_title'.tr),
        automaticallyImplyLeading: false,
        actions: [
          Obx(() => c.unreadCount > 0
              ? TextButton(
                  onPressed: c.markAllAsRead,
                  child: Text('mark_all_read'.tr,
                      style: TextStyle(color: AppColors.primary, fontSize: 13)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) return const AppLoading();
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }
        if (c.items.isEmpty) {
          return AppEmptyState(
            message: 'no_notifications'.tr,
            icon: Icons.notifications_none,
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: c.load,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                c.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: c.items.length + (c.hasMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i >= c.items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    ),
                  );
                }
                final n = c.items[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FadeSlideIn(
                    delay: Duration(milliseconds: 30 * i),
                    child: _NotificationCard(
                      notification: n,
                      onTap: () => c.markAsRead(n),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  const _NotificationCard({required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return SurfaceCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (unread ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: unread ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                    )),
                if (notification.body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(notification.body, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                ],
                if (notification.createdAt != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    formatDate(notification.createdAt!.toIso8601String()),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          if (unread)
            Container(
              margin: const EdgeInsets.only(top: 4, right: 2),
              width: 9,
              height: 9,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
