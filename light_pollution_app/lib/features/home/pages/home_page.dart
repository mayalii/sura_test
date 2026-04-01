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
    final c = context.colors;

    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: 40,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: c.divider, width: 0.5),
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
              icon: Icon(Icons.home_outlined, color: c.textSecondary),
              selectedIcon: Icon(Icons.home, color: c.accent),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: c.textSecondary),
              selectedIcon: Icon(Icons.search, color: c.accent),
              label: l10n.navSearch,
            ),
            NavigationDestination(
              icon: Icon(Icons.camera_alt_outlined, color: c.textSecondary),
              selectedIcon: Icon(Icons.camera_alt, color: c.accent),
              label: l10n.navCamera,
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_num_outlined, color: c.textSecondary),
              selectedIcon: Icon(Icons.confirmation_num, color: c.accent),
              label: l10n.navReserve,
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline, color: c.textSecondary),
              selectedIcon: Icon(Icons.chat_bubble, color: c.accent),
              label: l10n.navChat,
            ),
          ],
        ),
      ),
    );
  }
}
