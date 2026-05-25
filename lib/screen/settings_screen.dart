import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:face_log/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Settings screen — light theme version adapted from the "Attendance Pro - Settings" HTML.
/// Uses Lumen light tokens, cards, and typography.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _confidenceThreshold = 70;
  bool _cameraToggle = true;

  @override
  Widget build(BuildContext context) {
    // Force light Lumen theme to match the reference design
    return Theme(
      data: LumenTheme.light(),
      child: Scaffold(
        backgroundColor: LumenLightColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),

            padding: const EdgeInsets.symmetric(
              horizontal: LumenSpacing.marginMobile,
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page title
                  Text(
                    'System Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Configure your device recognition engine and local database.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: LumenLightColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // RECOGNITION SECTION
                  _SectionCard(
                    title: 'Recognition',
                    children: [
                      // Confidence Threshold
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confidence Threshold',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Minimum accuracy required for valid match',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color:
                                              LumenLightColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: LumenLightColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '${_confidenceThreshold.round()}%',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color:
                                            LumenLightColors.onPrimaryContainer,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 9,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                            ),
                            child: Slider(
                              value: _confidenceThreshold,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              activeColor: LumenLightColors.primary,
                              inactiveColor: LumenLightColors.outlineVariant,
                              onChanged: (value) {
                                setState(() => _confidenceThreshold = value);
                              },
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 1),

                      // Camera Toggle
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Camera Selection Toggle',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Enable manual camera switching in view',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color:
                                            LumenLightColors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _cameraToggle,
                            onChanged: (val) =>
                                setState(() => _cameraToggle = val),
                            activeThumbColor: LumenLightColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // DATABASE SECTION
                  _SectionCard(
                    title: 'Database',
                    children: [
                      _ActionRow(
                        icon: Icons.file_download,
                        title: 'Export CSV',
                        subtitle: 'Download all attendance logs as spreadsheet',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Exporting attendance as CSV...'),
                            ),
                          );
                        },
                      ),
                      _ActionRow(
                        icon: Icons.delete_sweep,
                        title: 'Clear Logs',
                        subtitle: 'Permanently delete activity history',
                        isDestructive: true,
                        onTap: () {
                          _showConfirmDialog(
                            title: 'Clear Logs?',
                            message:
                                'This will permanently delete all attendance history.',
                            confirmText: 'Clear',
                            onConfirm: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logs cleared')),
                              );
                            },
                          );
                        },
                      ),
                      _ActionRow(
                        icon: Icons.restart_alt,
                        title: 'Reset App',
                        subtitle: 'Wipe all local data and configurations',
                        isDestructive: true,
                        onTap: () {
                          _showConfirmDialog(
                            title: 'Reset App?',
                            message:
                                'This will erase everything. This action cannot be undone.',
                            confirmText: 'Reset',
                            onConfirm: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('App has been reset'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // SYSTEM INFO
                  _SectionCard(
                    title: 'System Info',
                    children: [
                      _InfoRow(label: 'Model Version', value: 'v2.4.8-STABLE'),
                      _InfoRow(label: 'DB Size', value: '142.5 MB'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Secure Node Footer
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: LumenLightColors.surfaceContainerHigh,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: LumenLightColors.outlineVariant,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCzALYfuFLrCSAcZYu8TXqe9rKa3Bt1vrIh-A3Ey2cbZ9XzhChvJ9FXnVFmIRM9G9H4yfKz9r1WzPAllNZztMuzDlR4kWBvzth0TRhgHSxQ-fgYL6n4MQEH_-Dg94yipm7CoMriJG-syvilaOCUZWjuey_UiTvzz2CMSQVQXbUXYnicpMpx-thZKZMTI5bO49JWJ8jbCHz7pgWlklTSpNIxviGx_sPpg3KQSFaqHL4n2reI2vg_enO_wI2u0cI7sFoPAmlxs68MvRY',
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.security,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SECURE ENCRYPTED NODE',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: LumenLightColors.onSurfaceVariant,
                                letterSpacing: 1.5,
                              ),
                        ),
                        Text(
                          'ID: AP-9942-XJ',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: LumenLightColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: TextButton.styleFrom(
              foregroundColor: LumenLightColors.error,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Reusable Section Card
// ──────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LumenLightColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LumenLightColors.outlineVariant),
      ),
      child: Column(
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: LumenLightColors.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(color: LumenLightColors.outlineVariant),
              ),
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: LumenLightColors.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Action Row (Export, Clear, Reset)
// ──────────────────────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? LumenLightColors.error
        : LumenLightColors.onSurface;
    final iconColor = isDestructive
        ? LumenLightColors.error
        : LumenLightColors.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: LumenLightColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive
                  ? LumenLightColors.error
                  : LumenLightColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Info Row (System Info)
// ──────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: LumenLightColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: LumenLightColors.outlineVariant),
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: LumenLightColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
