import 'package:face_log/widget/bounding_box.dart';
import 'package:face_log/widget/button.dart';
import 'package:face_log/widget/lumen_card.dart';
import 'package:face_log/widget/lumen_input.dart';
import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:face_log/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const FaceLogApp());

class FaceLogApp extends StatefulWidget {
  const FaceLogApp({super.key});

  @override
  State<FaceLogApp> createState() => _FaceLogAppState();
}

class _FaceLogAppState extends State<FaceLogApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaceLog',
      debugShowCheckedModeBanner: false,
      theme: LumenTheme.light(),
      darkTheme: LumenTheme.dark(),
      themeMode: _themeMode,
      home: _ThemePreviewScreen(
        onThemeToggle: () => setState(() {
          _themeMode = _themeMode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark;
        }),
      ),
    );
  }
}

/// Quick visual preview of design tokens & widgets in both themes.
class _ThemePreviewScreen extends StatefulWidget {
  const _ThemePreviewScreen({required this.onThemeToggle});
  final VoidCallback onThemeToggle;

  @override
  State<_ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<_ThemePreviewScreen> {
  LumenBoundingBoxState _boxState = LumenBoundingBoxState.scanning;
  LumenConnectivityStatus _connectivity = LumenConnectivityStatus.online;

  void _cycleBoxState() => setState(() {
    _boxState = LumenBoundingBoxState
        .values[(_boxState.index + 1) % LumenBoundingBoxState.values.length];
  });

  void _cycleConnectivity() => setState(() {
    _connectivity =
        LumenConnectivityStatus.values[(_connectivity.index + 1) %
            LumenConnectivityStatus.values.length];
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumen Design System'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: Column(
        children: [
          LumenOfflineBanner(status: _connectivity),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(LumenSpacing.containerPadding),
              children: [
                // ── Typography preview ───────────────────────────────────
                Text('Typography', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.elementGap),
                Text(
                  'Display Large',
                  style: tt.displayLarge?.copyWith(fontSize: 28),
                ),
                Text('Headline Medium', style: tt.headlineMedium),
                Text(
                  'Body Large — Attendance system for mobile CV apps.',
                  style: tt.bodyLarge,
                ),
                Text('08:42 AM', style: tt.displaySmall),
                Text('ID-00347 • OFFLINE MODE', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.sectionMargin),

                // ── Buttons ──────────────────────────────────────────────
                Text('Buttons', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.elementGap),
                Wrap(
                  spacing: LumenSpacing.xs,
                  runSpacing: LumenSpacing.xs,
                  children: [
                    Button(
                      label: 'Check In',
                      icon: Icons.fingerprint,
                      onPressed: () {},
                    ),
                    Button(
                      label: 'Export CSV',
                      variant: LumenButtonVariant.secondary,
                      icon: Icons.download_outlined,
                      onPressed: () {},
                    ),
                    Button(
                      label: 'View Logs',
                      variant: LumenButtonVariant.ghost,
                      onPressed: () {},
                    ),
                    Button(
                      label: 'Delete',
                      variant: LumenButtonVariant.destructive,
                      icon: Icons.delete_outline,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: LumenSpacing.xs),
                Button(
                  label: 'Register New User',
                  icon: Icons.person_add_outlined,
                  fullWidth: true,
                  onPressed: () {},
                ),
                const SizedBox(height: LumenSpacing.sectionMargin),

                // ── Camera FAB ───────────────────────────────────────────
                Text('Camera FAB', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.elementGap),
                Center(
                  child: LumenCameraFab(
                    onPressed: () {},
                    heroTag: 'preview-fab',
                  ),
                ),
                const SizedBox(height: LumenSpacing.sectionMargin),

                // ── Bounding Box ─────────────────────────────────────────
                Text(
                  'Bounding Box (tap to cycle state: ${_boxState.name})',
                  style: tt.labelMedium,
                ),
                const SizedBox(height: LumenSpacing.elementGap),
                GestureDetector(
                  onTap: _cycleBoxState,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: isDark
                          ? LumenDarkColors.surfaceContainerLow
                          : LumenLightColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(
                        isDark ? LumenRadius.cardDark : LumenRadius.cardLight,
                      ),
                    ),
                    child: Center(
                      child: BoundingBox(
                        width: 120,
                        height: 140,
                        state: _boxState,
                        label: 'FACE',
                        confidence: 0.93,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: LumenSpacing.sectionMargin),

                // ── Cards & Status Chips ─────────────────────────────────
                Text('Attendance Cards', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.elementGap),
                LumenAttendanceCard(
                  name: 'Sarah Chen',
                  time: '08:42 AM',
                  idLabel: 'ID-00347',
                  matchPercent: 97,
                  status: LumenAttendanceStatus.punctual,
                ),
                LumenAttendanceCard(
                  name: 'Marcus Webb',
                  time: '09:17 AM',
                  idLabel: 'ID-00512',
                  matchPercent: 88,
                  status: LumenAttendanceStatus.late,
                ),
                LumenAttendanceCard(
                  name: 'Priya Nair',
                  time: '08:55 AM',
                  idLabel: 'ID-00231',
                  matchPercent: null,
                  status: LumenAttendanceStatus.remote,
                ),
                const SizedBox(height: LumenSpacing.sectionMargin),

                // ── Inputs ───────────────────────────────────────────────
                Text('Inputs', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.elementGap),
                LumenSearchField(hint: 'Search employees…'),
                const SizedBox(height: LumenSpacing.xs),
                const LumenInput(
                  label: 'Full Name',
                  hint: 'Enter employee name',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: LumenSpacing.xs),
                const LumenInput(
                  label: 'Employee ID',
                  hint: 'e.g. ID-00001',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: LumenSpacing.sectionMargin),

                // ── Connectivity Banner Demo ─────────────────────────────
                Text('Offline Banner (tap to cycle)', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.elementGap),
                GestureDetector(
                  onTap: _cycleConnectivity,
                  child: LumenOfflineBanner(status: _connectivity),
                ),
                const SizedBox(height: LumenSpacing.sectionMargin),

                // ── Glass Card ───────────────────────────────────────────
                Text('Glass Card (camera overlay)', style: tt.labelMedium),
                const SizedBox(height: LumenSpacing.elementGap),
                Stack(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cs.primaryContainer, cs.tertiaryContainer],
                        ),
                        borderRadius: BorderRadius.circular(
                          isDark ? LumenRadius.cardDark : LumenRadius.cardLight,
                        ),
                      ),
                    ),
                    Positioned(
                      left: LumenSpacing.xs,
                      top: LumenSpacing.xs,
                      right: LumenSpacing.xs,
                      child: LumenGlassCard(
                        padding: const EdgeInsets.all(LumenSpacing.xs),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: isDark
                                  ? LumenDarkColors.secondary
                                  : LumenLightColors.successIndicator,
                            ),
                            const SizedBox(width: LumenSpacing.elementGap),
                            Text(
                              'Identity Confirmed',
                              style: tt.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LumenSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
