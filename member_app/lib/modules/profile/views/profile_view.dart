import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../routes/app_routes.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Obx(() {
            final user = c.user.value;
            final initials = _initials(user?.name);
            final wallet = user?.member?.wallet;
            final weight = user?.member?.initialWeight;
            final height = user?.member?.height;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Text('profile_title'.tr,
                      style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                ),

                // ─── بطاقة الملف المدمجة ─────────────────────
                FadeSlideIn(
                  child: SurfaceCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(initials,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user?.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 3),
                              Text(user?.email ?? user?.phone ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: context.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        TapScale(
                          onTap: c.openQrCode,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.qr_code_2,
                                color: AppColors.primary, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ─── شبكة الإحصائيات ─────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: wallet != null ? '${wallet.balance.toInt()}' : '--',
                          label: 'wallet_balance_stat'.tr,
                          highlight: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          value: weight != null ? 'kg_value'.trParams({'n': '${weight.toInt()}'}) : '--',
                          label: 'initial_weight'.tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          value: height != null ? 'cm_value'.trParams({'n': '${height.toInt()}'}) : '--',
                          label: 'height_short'.tr,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 110),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: (user?.member?.goal != null && user!.member!.goal!.isNotEmpty)
                              ? user.member!.goal!
                              : '--',
                          label: 'goal_label'.tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          value: _genderLabel(user?.member?.gender),
                          label: 'gender_label'.tr,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ─── قسم: حسابي ───────────────────────────────
                _SectionLabel(text: 'account_section'.tr),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 140),
                  child: _TileGroup(
                    tiles: [
                      _TileData(Icons.schedule, 'my_period_title'.tr, AppRoutes.myPeriod),
                      _TileData(Icons.account_balance_wallet_outlined, 'wallet_and_payments'.tr, AppRoutes.wallet),
                      _TileData(Icons.report_gmailerrorred_outlined, 'complaints_title'.tr, AppRoutes.complaints),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ─── قسم: إعدادات ─────────────────────────────
                _SectionLabel(text: 'settings_label'.tr),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: _TileGroup(
                    tiles: [
                      _TileData(Icons.lock_outline, 'change_password_title'.tr, AppRoutes.changePassword),
                      _TileData(Icons.notifications_outlined, 'notifications_label'.tr, AppRoutes.notifications),
                      _TileData(Icons.settings_outlined, 'settings_label'.tr, AppRoutes.settings),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ─── تسجيل الخروج ─────────────────────────────
                FadeSlideIn(
                  delay: const Duration(milliseconds: 260),
                  child: TapScale(
                    onTap: () => _confirmLogout(context, c),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.danger.withOpacity(0.35)),
                      ),
                      child: Text('logout_title'.tr,
                          style: const TextStyle(
                              color: AppColors.danger,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _genderLabel(String? gender) {
    switch (gender) {
      case 'male':
        return 'male'.tr;
      case 'female':
        return 'female'.tr;
      default:
        return '--';
    }
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts[0].characters.first + parts[1].characters.first).toUpperCase();
  }

  void _confirmLogout(BuildContext context, ProfileController c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text('logout_title'.tr, style: TextStyle(color: context.textPrimary)),
        content: Text('logout_account_confirm'.tr,
            style: TextStyle(color: context.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.pop(context);
              c.logout();
            },
            child: Text('exit'.tr),
          ),
        ],
      ),
    );
  }
}

// ─── بطاقة إحصائية صغيرة ───────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;
  const _StatCard({required this.value, required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: highlight ? AppColors.primary : context.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

// ─── عنوان قسم ──────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(text,
            style: TextStyle(color: context.textSecondary, fontSize: 12)),
      );
}

// ─── مجموعة عناصر مجمّعة ببطاقة واحدة ──────────────────────────
class _TileGroup extends StatelessWidget {
  final List<_TileData> tiles;
  const _TileGroup({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(tiles.length, (i) {
          final t = tiles[i];
          return Column(
            children: [
              TapScale(
                onTap: () => Navigator.pushNamed(context, t.route),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      Icon(t.icon, size: 19, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(t.label,
                            style: TextStyle(color: context.textPrimary, fontSize: 13)),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 13, color: context.textSecondary),
                    ],
                  ),
                ),
              ),
              if (i != tiles.length - 1)
                Divider(height: 1, color: context.borderColor),
            ],
          );
        }),
      ),
    );
  }
}

class _TileData {
  final IconData icon;
  final String label, route;
  const _TileData(this.icon, this.label, this.route);
}
