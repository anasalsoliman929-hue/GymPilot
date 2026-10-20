import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/langs/LanguageController.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/settings_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingsController());
    final themeC = Get.find<ThemeController>();
    final langC = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr), automaticallyImplyLeading: false),
      body: Obx(() => ListView(
        children: [
          // ─── Profile ─────────────────────────────────────
          FadeSlideIn(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: Icon(Icons.person, color: context.textPrimary, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.user.value?.name ?? '',
                            style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            c.user.value?.email ?? '',
                            style: TextStyle(color: context.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Account ──────────────────────────────────────
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: _SectionHeader(label: 'account_section'.tr),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 120),
            child: _SettingsTile(
              icon: Icons.lock_outline,
              label: 'change_password_title'.tr,
              onTap: () => Get.toNamed(AppRoutes.changePassword),
            ),
          ),

          // ─── App ──────────────────────────────────────────
          FadeSlideIn(
            delay: const Duration(milliseconds: 160),
            child: _SectionHeader(label: 'app_section'.tr),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 190),
            child: _SettingsTile(
              icon: Icons.language_outlined,
              label: 'language_setting'.tr,
              trailing: Text(_langLabel(langC.lang.value),
                  style: TextStyle(color: context.textSecondary, fontSize: 13)),
              onTap: () => _showLanguagePicker(context, langC),
            ),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: _SettingsTile(
              icon: Icons.brightness_6_outlined,
              label: 'theme_setting'.tr,
              trailing: Text(_themeLabel(themeC.themeMode.value),
                  style: TextStyle(color: context.textSecondary, fontSize: 13)),
              onTap: () => _showThemePicker(context, themeC),
            ),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 210),
            child: _SettingsTile(
              icon: Icons.notifications_outlined,
              label: 'notifications_toggle'.tr,
              trailing: Switch(
                value: c.notifications.value,
                onChanged: c.toggleNotifications,
                activeColor: AppColors.primary,
              ),
            ),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 240),
            child: _SettingsTile(
              icon: Icons.info_outline,
              label: 'app_version'.tr,
              trailing: Text(AppStrings.appVersion, style: TextStyle(color: context.textSecondary, fontSize: 13)),
            ),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 260),
            child: _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              label: 'privacy_policy_title'.tr,
              onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
            ),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 270),
            child: _SettingsTile(
              icon: Icons.description_outlined,
              label: 'terms_of_use_title'.tr,
              onTap: () => Get.toNamed(AppRoutes.termsOfUse),
            ),
          ),

          FadeSlideIn(
            delay: const Duration(milliseconds: 280),
            child: _SettingsTile(
              icon: Icons.storefront_outlined,
              label: 'about_gym_title'.tr,
              onTap: () => _showGymInfo(context, c),
            ),
          ),

          // ─── Logout ───────────────────────────────────────
          FadeSlideIn(
            delay: const Duration(milliseconds: 280),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3a1a1a),
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  elevation: 0,
                ),
                onPressed: c.isLoggingOut.value ? null : () => _confirmLogout(context, c),
                icon: c.isLoggingOut.value
                    ? const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.danger))
                    : const Icon(Icons.logout_outlined),
                label: Text('logout_title'.tr),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      )),
    );
  }

  String _langLabel(String code) {
    switch (code) {
      case 'ar': return 'lang_arabic'.tr;
      case 'fr': return 'lang_french'.tr;
      default:   return 'lang_english'.tr;
    }
  }

  String _themeLabel(int mode) {
    switch (mode) {
      case 1: return 'theme_light'.tr;
      case 2: return 'theme_dark'.tr;
      default: return 'theme_system'.tr;
    }
  }

  void _showLanguagePicker(BuildContext context, LanguageController langC) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('choose_language'.tr,
                  style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            _PickerOption(
              label: 'lang_arabic'.tr,
              selected: langC.lang.value == 'ar',
              onTap: () { langC.changeLanguage('ar'); Navigator.pop(context); },
            ),
            _PickerOption(
              label: 'lang_english'.tr,
              selected: langC.lang.value == 'en',
              onTap: () { langC.changeLanguage('en'); Navigator.pop(context); },
            ),
            _PickerOption(
              label: 'lang_french'.tr,
              selected: langC.lang.value == 'fr',
              onTap: () { langC.changeLanguage('fr'); Navigator.pop(context); },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, ThemeController themeC) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('choose_theme'.tr,
                  style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            _PickerOption(
              label: 'theme_system'.tr,
              selected: themeC.themeMode.value == 0,
              onTap: () { themeC.setThemeMode(0); Navigator.pop(context); },
            ),
            _PickerOption(
              label: 'theme_light'.tr,
              selected: themeC.themeMode.value == 1,
              onTap: () { themeC.setThemeMode(1); Navigator.pop(context); },
            ),
            _PickerOption(
              label: 'theme_dark'.tr,
              selected: themeC.themeMode.value == 2,
              onTap: () { themeC.setThemeMode(2); Navigator.pop(context); },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showGymInfo(BuildContext context, SettingsController c) {
    final gym = c.gymInfo.value;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gym?.name ?? 'about_gym_title'.tr,
                  style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (gym?.address != null && gym!.address!.isNotEmpty)
                _GymInfoRow(icon: Icons.location_on_outlined, text: gym.address!),
              if (gym?.phone != null && gym!.phone!.isNotEmpty)
                _GymInfoRow(icon: Icons.phone_outlined, text: gym.phone!),
              if (gym?.minAge != null)
                _GymInfoRow(
                  icon: Icons.badge_outlined,
                  text: 'min_age_label'.trParams({'n': '${gym!.minAge}'}),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, SettingsController c) {    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('logout_title'.tr, style: TextStyle(color: context.textPrimary)),
        content: Text('logout_confirm_msg'.tr, style: TextStyle(color: context.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () { Navigator.pop(context); c.logout(); },
            child: Text('exit'.tr),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(label, style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _SettingsTile({required this.icon, required this.label, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TapScale(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: TextStyle(color: context.textPrimary))),
              trailing ?? Icon(Icons.chevron_right, color: context.textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PickerOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(label, style: TextStyle(color: selected ? AppColors.primary : context.textPrimary)),
      trailing: selected ? const Icon(Icons.check, color: AppColors.primary) : null,
    );
  }
}

class _GymInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _GymInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(color: context.textSecondary, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
