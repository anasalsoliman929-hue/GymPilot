import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../home/views/home_view.dart';
import '../../nutrition/views/nutrition_view.dart';
import '../../profile/views/profile_view.dart';
import '../../progress/views/progress_view.dart';
import '../../subscriptions/views/subscriptions_view.dart';
import '../../wallet/views/wallet_view.dart';
import '../../workout/views/workout_view.dart';
import '../controllers/main_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();

    return Obx(() {
      // شاشة تحميل أثناء التحقق من الاشتراك
      if (c.isLoading.value) {
        return Scaffold(
          backgroundColor: context.bgColor,
          body: const AppLoading(),
        );
      }

      // إذا لا يوجد اشتراك — يظهر فقط الاشتراك والمحفظة
      if (!c.hasActiveSubscription.value) {
        return _NoSubscriptionShell(c: c);
      }

      // إذا يوجد اشتراك — يظهر كل التبويبات
      return _FullShell(c: c);
    });
  }
}

// ─── Shell بدون اشتراك ────────────────────────────────────────
class _NoSubscriptionShell extends StatelessWidget {
  final MainController c;
  const _NoSubscriptionShell({required this.c});

 static const _tabs = [
  SubscriptionsView(),
  WalletView(),
  ProfileView(),
];

static List<_NavItem> get _items => [
  _NavItem(Icons.card_membership_outlined, Icons.card_membership, 'my_subscriptions'.tr),
  _NavItem(Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'wallet'.tr),
  _NavItem(Icons.person_outline, Icons.person, 'my_account_tab'.tr),
];
  @override
  Widget build(BuildContext context) {
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

// ─── Shell مع اشتراك ──────────────────────────────────────────
class _FullShell extends StatelessWidget {
  final MainController c;
  const _FullShell({required this.c});

  static const _tabs = [
    HomeView(),
    WorkoutView(),
    NutritionView(),
    ProgressView(),
    ProfileView(),
  ];

  static List<_NavItem> get _items => [
    _NavItem(Icons.home_outlined, Icons.home, 'home_title'.tr),
    _NavItem(Icons.fitness_center_outlined, Icons.fitness_center, 'workouts_tab'.tr),
    _NavItem(Icons.restaurant_menu_outlined, Icons.restaurant_menu, 'nutrition_tab'.tr),
    _NavItem(Icons.monitor_weight_outlined, Icons.monitor_weight, 'measurements_tab'.tr),
    _NavItem(Icons.person_outline, Icons.person, 'my_account_tab'.tr),
  ];

  @override
  Widget build(BuildContext context) {
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
        color: context.cardColor,
        border: Border(top: BorderSide(color: context.borderColor)),
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
                          color: selected ? AppColors.primary : context.textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: selected ? AppColors.primary : context.textSecondary,
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        child: Text(item.label),
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
