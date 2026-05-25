import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Logs / Attendance Log screen — pixel-faithful recreation of the provided web UI.
/// Uses the existing Lumen dark theme tokens and glassmorphism patterns.
class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  String _activeTab = 'today'; // 'today' | 'history'

  // Sample data for the "Today" tab (matches the HTML content)
  final List<_LogEntry> _todayEntries = [
    _LogEntry(
      name: 'Felix Arvid',
      time: '08:42 AM',
      status: _LogStatus.punctual,
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAc3-15Hk4dPduHD2UK-cd0QQxtIoMOy7WxJCXpYA0q8Ujz9ghqyMYZVPFhYOwVhp1j1-bxqH30T-VYuTddx-fL_f5lktXpbILeteYZs6R7WlFBjM5hxr2C691l4KnJI0PLOAWlAC2aqOd21skXw2RTH3ffIFQF92dGAhvLxYbvwfKYxKlxMl-0YjXlzxQB_mzW8acKjAYUkz6rVLzKFTQNrrQ7FGcUpOrPeifwcbPys8XOrJZ6HXvqKwTFfT24N-Qm31eUYiSWbXA',
    ),
    _LogEntry(
      name: 'Sasha Grey',
      time: '09:15 AM',
      status: _LogStatus.late,
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBIrBro177PHDN8DUp4PRZRwyEwlGs7pzk5_3IYWE8zYy07vKB7S0PphLIpcO1h39hXbiLlNBWeJHGRzExDejxjR5EpdONOOzsZntVrGIaQFpnc67FMxjfktQCwfS6Zvq6yvlZkTMJwrZNX6RsbvGmhoinUVdSOeU9OteeZTbX9BC6S290-fEp_PlvDpeZVpKTpWe4E4AX4ajaeibcqLnkrUpenLMH8cRyUF1Hnf_yE2NBuugtf8CBpdwXxfElL6C5wKGNGJ7vzW-k',
    ),
    _LogEntry(
      name: 'Marcus Thorne',
      time: '09:45 AM',
      status: _LogStatus.remote,
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDxfPhvM1lV_-GWEkfWShcytKd8WouRNTFw7PMHfG-92W22iCQqPw3L2teUz3QQDv0NhcG-ajgeeglI8ungeoWoUSizpJTPSvMUpdstMdd5wpjenJ945pJ0zBIEitTpx8tv6yAI1PmtcAPYZjAbvn_RsUgecNbRchOwsc2tkmEcUsivzEp-0a6MZv5ddYwlHsGaSu115rI_nxIksSwPT5m9kbGECqJ4y0XrGknFz795ss6yONA28VshEecYj5xRc86NPR9oDj47mSE',
    ),
  ];

  void _switchTab(String tab) {
    setState(() => _activeTab = tab);
  }

  void _deleteEntry(int index) {
    setState(() {
      _todayEntries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 12,
            left: LumenSpacing.containerPadding,
            right: LumenSpacing.containerPadding,
            bottom: 140, // leave room for FAB + bottom nav
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stats Bento Grid ───────────────────────────────────────────
              _StatsBento(),

              const SizedBox(height: LumenSpacing.sectionMargin),

              // ── Segmented Tab Control ─────────────────────────────────────
              _CustomTabBar(activeTab: _activeTab, onTabChanged: _switchTab),

              const SizedBox(height: 16),

              // ── Tab Content ───────────────────────────────────────────────
              if (_activeTab == 'today')
                _TodayTab(entries: _todayEntries, onDelete: _deleteEntry)
              else
                const _HistoryTab(),
            ],
          ),
        ),

        // ── Floating Camera FAB (navigates back to Home/Camera) ───────────
        Positioned(
          right: 24,
          bottom: 108, // above the bottom nav
          child: FloatingActionButton(
            heroTag: 'logs-fab',
            onPressed: () => context.go('/home'),
            backgroundColor: LumenDarkColors.primary,
            foregroundColor: LumenDarkColors.onPrimary,
            elevation: 8,
            child: const Icon(Icons.photo_camera, size: 28),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Stats Cards (Bento Grid)
// ──────────────────────────────────────────────────────────────────────────────

class _StatsBento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    Widget statCard({
      required String title,
      required String value,
      String? subtitle,
      required IconData icon,
    }) {
      return Container(
        height: 128,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: LumenDarkColors.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1,
                child: Icon(icon, size: 56, color: LumenDarkColors.onSurface),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.labelMedium?.copyWith(
                    color: LumenDarkColors.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                if (subtitle == null)
                  Text(
                    value,
                    style: tt.displaySmall?.copyWith(
                      fontSize: 32,
                      color: LumenDarkColors.primary,
                    ),
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: tt.displaySmall?.copyWith(
                          fontSize: 32,
                          color: LumenDarkColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        subtitle,
                        style: tt.labelMedium?.copyWith(
                          color: LumenDarkColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: LumenSpacing.stackGap,
      crossAxisSpacing: LumenSpacing.stackGap,
      children: [
        statCard(title: 'TOTAL USERS', value: '45', icon: Icons.group),
        statCard(
          title: 'PRESENT TODAY',
          value: '12',
          subtitle: '/ 45',
          icon: Icons.how_to_reg,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Custom Segmented Tabs (Today / History)
// ──────────────────────────────────────────────────────────────────────────────

class _CustomTabBar extends StatelessWidget {
  const _CustomTabBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  final String activeTab;
  final ValueChanged<String> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    Widget tabButton(String id, String label) {
      final bool isActive = activeTab == id;
      return Expanded(
        child: GestureDetector(
          onTap: () => onTabChanged(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? LumenDarkColors.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: tt.labelMedium?.copyWith(
                color: isActive
                    ? LumenDarkColors.onPrimaryContainer
                    : LumenDarkColors.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: LumenDarkColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LumenDarkColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          tabButton('today', 'Today'),
          tabButton('history', 'History'),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// TODAY TAB — Swipe-to-delete list
// ──────────────────────────────────────────────────────────────────────────────

class _TodayTab extends StatelessWidget {
  const _TodayTab({super.key, required this.entries, required this.onDelete});

  final List<_LogEntry> entries;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    if (entries.isEmpty) {
      return _EmptyState();
    }

    return Column(
      children: List.generate(entries.length, (index) {
        final e = entries[index];
        return Dismissible(
          key: ValueKey('${e.name}-$index'),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: LumenDarkColors.errorContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onDelete(index),
          child: _LogListItem(entry: e),
        );
      }),
    );
  }
}

class _LogListItem extends StatelessWidget {
  const _LogListItem({super.key, required this.entry});

  final _LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final (chipText, chipColor) = switch (entry.status) {
      _LogStatus.punctual => ('PUNCTUAL', LumenDarkColors.secondary),
      _LogStatus.late => ('LATE', LumenDarkColors.error),
      _LogStatus.remote => ('REMOTE', LumenDarkColors.tertiary),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LumenDarkColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.network(
              entry.avatarUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 48,
                height: 48,
                color: LumenDarkColors.surfaceContainerHigh,
                child: const Icon(Icons.person, color: Colors.white30),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name + Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: LumenDarkColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.time,
                      style: tt.labelMedium?.copyWith(
                        color: LumenDarkColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              chipText,
              style: tt.labelMedium?.copyWith(
                color: chipColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAmbF38r_X6sxNnKRpUcPfY0-Ff6rcat-lKb6xE4FViQPHnB7t2CxqQpXwqxCwRgh7lpwqF6fewUdP3M4bceGGocjp5BGT0-EbCItckp4ZZ-yL-OIMqvcO_duKzS1e1UoCifRQzTmjkUQs6NZtGcnQJF8j6aohx0xRIh4wveZVG0lJJFliwGTm6gH70QyrrYcsro8TazJiiYfGExgBmloNSWeLnBP1T5EcP_LE97MqWGzQ5DHLUM0Bz7KfnpRK16eN-6L188d_eJhI',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.inbox, size: 80, color: Colors.white24),
          ),
          const SizedBox(height: 24),
          Text(
            'No attendance marked yet today',
            style: tt.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Attendance logs will appear here once biometric scans are completed.',
            style: tt.bodyMedium?.copyWith(
              color: LumenDarkColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// HISTORY TAB
// ──────────────────────────────────────────────────────────────────────────────

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        // Search + Calendar row
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search logs...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: LumenDarkColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: LumenDarkColors.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: LumenDarkColors.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: LumenDarkColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: LumenDarkColors.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: LumenDarkColors.outlineVariant),
              ),
              child: IconButton(
                icon: const Icon(Icons.calendar_today),
                color: LumenDarkColors.primary,
                onPressed: () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Export CSV
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('Export Attendance (CSV)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: LumenDarkColors.primary,
              foregroundColor: LumenDarkColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Timeline
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: LumenDarkColors.outlineVariant, width: 2),
            ),
          ),
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            children: [
              _TimelineItem(
                date: 'Yesterday - Oct 23, 2023',
                count: '42 Users present',
                isToday: true,
              ),
              const SizedBox(height: 24),
              _TimelineItem(
                date: 'Oct 22, 2023',
                count: '39 Users present',
                isToday: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    super.key,
    required this.date,
    required this.count,
    required this.isToday,
  });

  final String date;
  final String count;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 4, right: 16),
          decoration: BoxDecoration(
            color: isToday
                ? LumenDarkColors.primary
                : LumenDarkColors.outlineVariant,
            shape: BoxShape.circle,
            border: Border.all(color: LumenDarkColors.background, width: 4),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: tt.labelMedium?.copyWith(
                  color: isToday
                      ? LumenDarkColors.primary
                      : LumenDarkColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: LumenDarkColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(count, style: tt.bodyMedium),
                    const Icon(
                      Icons.chevron_right,
                      color: LumenDarkColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Data models (local to this screen for demo)
// ──────────────────────────────────────────────────────────────────────────────

enum _LogStatus { punctual, late, remote }

class _LogEntry {
  final String name;
  final String time;
  final _LogStatus status;
  final String avatarUrl;

  const _LogEntry({
    required this.name,
    required this.time,
    required this.status,
    required this.avatarUrl,
  });
}
