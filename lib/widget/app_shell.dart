import 'dart:ui';

import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared application shell providing the custom dark header + bottom navigation
/// for all routes when using go_router StatefulShellRoute.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // Force the dark Lumen theme for the shell chrome (matches the biometric design)
    return Theme(
      data: ThemeData.dark(useMaterial3: true).copyWith(
        // we could also import LumenTheme.dark() here
        colorScheme: const ColorScheme.dark(
          primary: LumenDarkColors.primary,
          secondary: LumenDarkColors.secondary,
          surface: LumenDarkColors.surface,
          onSurface: LumenDarkColors.onSurface,
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // The actual page content for the current branch
            Positioned.fill(child: navigationShell),

            // Custom top header (Biometric Sync bar) — shown on every tab for now
            const _AppHeader(),

            // Persistent bottom navigation
            _AppBottomNav(navigationShell: navigationShell),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Reusable header extracted from the original Home screen
// ──────────────────────────────────────────────────────────────────────────────

class _AppHeader extends StatelessWidget {
  const _AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(
                horizontal: LumenSpacing.containerPadding,
              ),
              decoration: BoxDecoration(
                color: LumenDarkColors.surface.withValues(alpha: 0.4),
                border: Border(
                  bottom: BorderSide(
                    color: LumenDarkColors.outlineVariant.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.security,
                        color: LumenDarkColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Biometric Sync',
                        style: tt.headlineSmall?.copyWith(
                          color: LumenDarkColors.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: LumenDarkColors.surfaceContainerHigh.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: LumenDarkColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _PulsingDot(),
                        const SizedBox(width: 6),
                        Text(
                          'Today: 12 Present',
                          style: tt.labelMedium?.copyWith(
                            color: LumenDarkColors.onSurface,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: LumenDarkColors.surfaceVariant.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 15,
                          color: LumenDarkColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Offline',
                          style: tt.labelMedium?.copyWith(
                            color: LumenDarkColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({super.key});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: LumenDarkColors.secondary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: LumenDarkColors.secondary.withValues(
                alpha: 0.6 * _ctrl.value,
              ),
              blurRadius: 6 + 4 * _ctrl.value,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Bottom navigation bar wired to go_router navigationShell
// ──────────────────────────────────────────────────────────────────────────────

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({super.key, required this.navigationShell});

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
      final Color iconColor =
          active ? LumenDarkColors.onPrimaryContainer : LumenDarkColors.onSurfaceVariant;
      final Color textColor =
          active ? LumenDarkColors.onPrimaryContainer : LumenDarkColors.onSurfaceVariant;

      Widget item = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(active ? (activeIcon ?? icon) : icon, color: iconColor, size: 22),
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
            color: LumenDarkColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: item,
        );
      }

      return GestureDetector(
        onTap: () => navigationShell.goBranch(index),
        behavior: HitTestBehavior.opaque,
        child: item,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: LumenDarkColors.surfaceContainer.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: LumenDarkColors.outlineVariant.withValues(alpha: 0.3),
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
      ),
    );
  }
}
