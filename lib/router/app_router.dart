import 'package:face_log/screen/home.dart';
import 'package:face_log/screen/logs_screen.dart';
import 'package:face_log/screen/register_user_screen.dart';
import 'package:face_log/screen/settings_screen.dart';
import 'package:face_log/screen/users_screen.dart';
import 'package:face_log/widget/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Home / Camera tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const Home(),
            ),
          ],
        ),

        // Logs tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/logs',
              name: 'logs',
              builder: (context, state) => const LogsScreen(),
            ),
          ],
        ),

        // Users tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/users',
              name: 'users',
              builder: (context, state) => const UsersScreen(),
            ),
          ],
        ),

        // Settings tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Standalone registration flow (outside main shell)
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterUserScreen(),
    ),
  ],
);
