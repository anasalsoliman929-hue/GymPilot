import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/views/home_view.dart';
import '../../members/views/members_view.dart';
import '../../notifications/views/notifications_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_controller.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  static const _tabs = [
    HomeView(),
    MembersView(),
    NotificationsView(),
    ProfileView(),
  ];

  static const _items = [
    _NavItem(Icons.space_dashboard_outlined, Icons.space_dashboard, 'nav_home'),
    _NavItem(Icons.groups_outlined, Icons.groups, 'nav_members'),
    _NavItem(Icons.notifications_outlined, Icons.notifications, 'nav_notifications'),
    _NavItem(Icons.person_outline, Icons.person, 'nav_profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();

    return Obx(() => Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                child: child,
              ),
            ),
            child: KeyedSubtree(
              key: ValueKey(c.currentIndex.value),
              child: _tabs[c.currentIndex.value.clamp(0, _tabs.length - 1)],
            ),
          ),
          bottomNavigationBar: _BottomBar(
            items: _items,
            currentIndex: c.currentIndex.value,
            onTap: (i) => c.changeTab(i),
          ),
        ));
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final selected = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        width: selected ? 20 : 0,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          selected ? item.activeIcon : item.icon,
                          key: ValueKey(selected),
                          color: selected ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: selected ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        child: Text(item.label.tr),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon, activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}
