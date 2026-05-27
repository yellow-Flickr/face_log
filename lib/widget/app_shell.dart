import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared application shell providing the custom dark header + bottom navigation
/// for all routes when using go_router StatefulShellRoute.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Force the dark Lumen theme for the shell chrome (matches the biometric design)
      bottomNavigationBar: _AppBottomNav(
        navigationShell: navigationShell,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.security,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Biometric Sync',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // The actual page content for the current branch
      body: navigationShell,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Bottom navigation bar wired to go_router navigationShell
// ──────────────────────────────────────────────────────────────────────────────

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final currentIndex = navigationShell.currentIndex;

    Widget navItem({
      required IconData icon,
      required String label,
      required int index,
      IconData? activeIcon,
    }) {
      final bool active = currentIndex == index;
      final Color iconColor = active
          ? Theme.of(context).colorScheme.onPrimaryContainer
          : Theme.of(context).colorScheme.onSurfaceVariant;
      final Color textColor = active
          ? Theme.of(context).colorScheme.onPrimaryContainer
          : Theme.of(context).colorScheme.onSurfaceVariant;

      Widget item = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active ? (activeIcon ?? icon) : icon,
            color: iconColor,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: tt.labelMedium?.copyWith(
              color: textColor,
              fontSize: 10,
              letterSpacing: 0.2,
            ),
          ),
        ],
      );

      if (active) {
        item = Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: item,
        );
      }

      return GestureDetector(
        onTap: () => navigationShell.goBranch(
          index,
          initialLocation: index == currentIndex,
        ),
        behavior: HitTestBehavior.opaque,
        child: item,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: 10 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(
            icon: Icons.photo_camera,
            activeIcon: Icons.photo_camera,
            label: 'Home',
            index: 0,
          ),
          navItem(icon: Icons.history, label: 'Logs', index: 1),
          navItem(icon: Icons.group, label: 'Users', index: 2),
          navItem(icon: Icons.settings, label: 'Settings', index: 3),
        ],
      ),
    );
  }
}
