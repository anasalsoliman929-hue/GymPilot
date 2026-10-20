import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/translations/language_controller.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();

    return Scaffold(
      body: Obx(() {
        final user = c.user.value;
        final trainer = user?.trainer;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: c.refresh,
          child: ListView(
            children: [
              // ─── Header ─────────────────────────────────
              FadeSlideIn(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 28),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 92, height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                          border: Border.all(color: Colors.white54, width: 3),
                        ),
                        child: const Icon(Icons.sports_gymnastics, size: 46, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      Text(user?.name ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      if (user?.phone != null) ...[
                        const SizedBox(height: 2),
                        Text(user!.phone!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),

              // ─── Stats row ──────────────────────────────
              if (trainer != null)
                FadeSlideIn(
                  delay: const Duration(milliseconds: 150),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Stat(title: 'max_members'.tr, value: '${trainer.maxMembers}'),
                        const _VDivider(),
                        _Stat(title: 'specialties'.tr, value: '${trainer.specialties.length}'),
                      ],
                    ),
                  ),
                ),

              Divider(color: Theme.of(context).dividerColor, height: 1),

              // ─── Tiles ──────────────────────────────────
              ...[
                _TileData(Icons.edit_outlined, 'edit_my_profile'.tr, AppRoutes.editProfile),
                _TileData(Icons.lock_outline, 'change_password_title'.tr, AppRoutes.changePassword),
                _TileData(Icons.notifications_outlined, 'notifications_title'.tr, AppRoutes.notifications),
              ].asMap().entries.map((e) => FadeSlideIn(
                    delay: Duration(milliseconds: 220 + e.key * 60),
                    child: _Tile(
                      icon: e.value.icon,
                      label: e.value.label,
                      onTap: () => Get.toNamed(e.value.route),
                    ),
                  )),

              Divider(color: Theme.of(context).dividerColor, height: 1),

              // ─── Appearance & Language settings ──────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 380),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Text('settings'.tr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 400),
                child: const _ThemeTile(),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 420),
                child: const _LanguageTile(),
              ),

              Divider(color: Theme.of(context).dividerColor, height: 1),

              FadeSlideIn(
                delay: const Duration(milliseconds: 440),
                child: _Tile(
                  icon: Icons.logout,
                  label: 'logout'.tr,
                  isDanger: true,
                  onTap: () => _confirmLogout(context, c),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  void _confirmLogout(BuildContext context, ProfileController c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('logout'.tr, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: Text('logout_confirm'.tr, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.pop(context);
              c.logout();
            },
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}

// ─── Theme (light / dark / system) picker tile ─────────────
class _ThemeTile extends StatelessWidget {
  const _ThemeTile();

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();
    return Obx(() {
      final mode = themeC.themeMode.value;
      return ListTile(
        leading: Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.onSurface),
        title: Text('appearance'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
        trailing: DropdownButton<ThemeMode>(
          value: mode,
          underline: const SizedBox.shrink(),
          dropdownColor: Theme.of(context).cardColor,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          items: [
            DropdownMenuItem(value: ThemeMode.system, child: Text('theme_system'.tr)),
            DropdownMenuItem(value: ThemeMode.light, child: Text('theme_light'.tr)),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('theme_dark'.tr)),
          ],
          onChanged: (m) {
            if (m != null) themeC.setThemeMode(m);
          },
        ),
      );
    });
  }
}

// ─── Language picker tile ───────────────────────────────────
class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    final langC = Get.find<LanguageController>();
    return Obx(() {
      final code = langC.languageCode.value;
      return ListTile(
        leading: Icon(Icons.language_outlined, color: Theme.of(context).colorScheme.onSurface),
        title: Text('language'.tr,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
        trailing: DropdownButton<String>(
          value: code,
          underline: const SizedBox.shrink(),
          dropdownColor: Theme.of(context).cardColor,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          items: kSupportedLanguages
              .map((l) => DropdownMenuItem(value: l.code, child: Text(l.label)))
              .toList(),
          onChanged: (v) {
            if (v != null) langC.changeLanguage(v);
          },
        ),
      );
    });
  }
}

class _TileData {
  final IconData icon;
  final String label;
  final String route;
  _TileData(this.icon, this.label, this.route);
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;
  const _Tile({required this.icon, required this.label, required this.onTap, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.danger : Theme.of(context).colorScheme.onSurface;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDanger ? AppColors.danger : AppColors.primary),
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: isDanger
          ? null
          : Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14),
    );
  }
}

class _Stat extends StatelessWidget {
  final String title, value;
  const _Stat({required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12), textAlign: TextAlign.center),
        ],
      );
}

class _VDivider extends StatelessWidget {
  const _VDivider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 34, color: Theme.of(context).dividerColor);
}
