import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _updateSetting(WidgetRef ref, String field, bool value) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    await ref.read(firestoreServiceProvider).updateUser(user.id, {field: value});
    ref.invalidate(currentUserProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final user = ref.watch(currentUserProvider).valueOrNull;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColors.navyLight : AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          l10n.settingsTitle,
          style: font(
            color: isDark ? AppColors.darkTextPrimary : AppColors.navy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Account Section
          _SectionHeader(title: l10n.account),
          _SettingsTile(
            icon: Icons.person_outline,
            title: l10n.accountInfo,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.lock_outline,
            title: l10n.changePassword,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // Notifications Section
          _SectionHeader(title: l10n.notifications),
          _SettingsSwitch(
            icon: Icons.notifications_outlined,
            title: l10n.pushNotifications,
            value: user?.pushNotifications ?? true,
            onChanged: (v) => _updateSetting(ref, 'pushNotifications', v),
          ),
          _SettingsSwitch(
            icon: Icons.email_outlined,
            title: l10n.emailNotifications,
            value: user?.emailNotifications ?? false,
            onChanged: (v) => _updateSetting(ref, 'emailNotifications', v),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // Privacy Section
          _SectionHeader(title: l10n.privacy),
          _SettingsSwitch(
            icon: Icons.lock_outline,
            title: l10n.privateAccount,
            subtitle: l10n.privateAccountDesc,
            value: user?.isPrivate ?? false,
            onChanged: (v) => _updateSetting(ref, 'isPrivate', v),
          ),
          _SettingsSwitch(
            icon: Icons.visibility_outlined,
            title: l10n.showOnlineStatus,
            value: user?.showOnlineStatus ?? true,
            onChanged: (v) => _updateSetting(ref, 'showOnlineStatus', v),
          ),
          _SettingsSwitch(
            icon: Icons.chat_outlined,
            title: l10n.allowMessages,
            value: user?.allowMessages ?? true,
            onChanged: (v) => _updateSetting(ref, 'allowMessages', v),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // Display Section
          _SectionHeader(title: l10n.display),
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: l10n.appearance,
            subtitle: _themeModeLabel(ref.watch(themeModeProvider), l10n),
            onTap: () => _showThemeDialog(context, ref, l10n),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // About Section
          _SectionHeader(title: l10n.about),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: l10n.termsOfService,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.shield_outlined,
            title: l10n.privacyPolicy,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.code,
            title: l10n.openSourceLicenses,
            onTap: () => showLicensePage(context: context, applicationName: 'Sura'),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: l10n.appVersion,
            trailing: Text(
              '1.0.0',
              style: font(color: AppColors.textSecondary, fontSize: 14),
            ),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // Danger Zone
          _SectionHeader(title: l10n.dangerZone),
          _SettingsTile(
            icon: Icons.delete_forever_outlined,
            title: l10n.deleteAccount,
            subtitle: l10n.deleteAccountWarning,
            titleColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.deleteAccount),
                  content: Text(l10n.deleteAccountWarning),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: Text(l10n.deleteAccount),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final font = AppFonts.style(context);
    final current = ref.read(themeModeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.chooseTheme,
                  style: font(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              for (final entry in [
                (ThemeMode.system, l10n.themeSystem, Icons.settings_suggest_outlined),
                (ThemeMode.light, l10n.themeLight, Icons.light_mode_outlined),
                (ThemeMode.dark, l10n.themeDark, Icons.dark_mode_outlined),
              ])
                ListTile(
                  leading: Icon(entry.$3),
                  title: Text(
                    entry.$2,
                    style: font(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: current == entry.$1
                      ? const Icon(Icons.check, color: AppColors.navy)
                      : null,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setThemeMode(entry.$1);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: font(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: titleColor ?? (isDark ? AppColors.navyLight : AppColors.navy), size: 22),
      title: Text(
        title,
        style: font(
          color: titleColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: font(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontSize: 12),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextHint : AppColors.textHint, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SwitchListTile(
      secondary: Icon(icon, color: isDark ? AppColors.navyLight : AppColors.navy, size: 22),
      title: Text(
        title,
        style: font(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: font(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontSize: 12),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeTrackColor: isDark ? AppColors.navyLight : AppColors.navy,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
