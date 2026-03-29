import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../community/widgets/app_drawer.dart';

/// Global key for the home scaffold so child pages can open the drawer.
final homeScaffoldKeyProvider = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldKey = ref.watch(homeScaffoldKeyProvider);

    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: 40,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: true,
            );
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
              selectedIcon: const Icon(Icons.home, color: AppColors.navy),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: AppColors.textSecondary),
              selectedIcon: const Icon(Icons.search, color: AppColors.navy),
              label: l10n.navSearch,
            ),
            NavigationDestination(
              icon: Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary),
              selectedIcon: const Icon(Icons.camera_alt, color: AppColors.navy),
              label: l10n.navCamera,
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_num_outlined, color: AppColors.textSecondary),
              selectedIcon: const Icon(Icons.confirmation_num, color: AppColors.navy),
              label: l10n.navReserve,
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline, color: AppColors.textSecondary),
              selectedIcon: const Icon(Icons.chat_bubble, color: AppColors.navy),
              label: l10n.navChat,
            ),
          ],
        ),
      ),
    );
  }
}
