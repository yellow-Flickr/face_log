import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// User Management screen — adapted from the light-themed "Attendance Pro | User Management" design.
/// Uses the Lumen light theme tokens (Hanken Grotesk + Inter + JetBrains Mono) and light color palette.
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _searchTerm = '';
  final List<_User> _allUsers = [
    _User(
      name: 'Marcus Thorne',
      email: 'm.thorne@atpro.io',
      employeeId: '#EMP-2024-001',
      department: 'Infrastructure',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCmLyMVoJTbqne-l_cqmkS5y0Hl9q9LLeEGlvgpGvfEalfTsP7qfHLlb6XgwUrlog5KkOuo6EjD0BNaEkYGWpefwUhGtXp8zU_a0KckwkcyUfsT6W-UtKmSnqSbnrwIlqO3JQRiiBSn6vI0nNE9gHO1PeCve4WNyFt1IBgsFCYM_SdKu4jAx2FlWj2RIlXcVftAwoPuBvdTujFTi_WWDEx8GERGaq5AiEw-zHA52peksYR1rEmV30H2oTWFsyPZYqiV9m9U-U1mnSM',
      status: _UserStatus.punctual,
    ),
    _User(
      name: 'Sarah Chen',
      email: 's.chen@atpro.io',
      employeeId: '#EMP-2024-002',
      department: 'FinOps',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC6CnbZSRvl8m2KDQn2SMb47qBfbt0W1WaWVvazVwp_68BGWPhAvNZf2nfkyYUyHfAM4ljc4QZgwxIQdi3Bo8dcijPYH7q61sGk5kq7G2pTTzv2CPUdrpbpJojf-QczUCghr98JQcwnmk0nABKTKF2uSVLBCmObEYKGM0qGpQn0cReaQLOmUbocCbZaRCGXU22K9TF7B65Lbhq170anotyN1NKqc7t5U_nig6HSh72QPSS4areagP4SCSAvycXRwBvFvxHRHx2_3NM',
      status: _UserStatus.remote,
    ),
    _User(
      name: 'Jameson Vane',
      email: 'j.vane@atpro.io',
      employeeId: '#EMP-2024-015',
      department: 'Security',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDx1JbuBNVtb2bQkudd262sNPhPvukbovFraJlyfI0VwdQAJWD9knyGcfhaGzER-AHdgalglO03_OX9C743jJsq7UbtXsYh6hYawiXEU5yUIY7re9QUWPd2T2BHzX8g5LM-PfeV-ygJ3XObs0PbQF543WjxYWVLOCPcYrqixT-SF4WM0StT4TIsJNwCFUV1ooz8tXxArLpnmb0cttxS501EB1wTO1HiNP5-Nq0vlLDbH-AGh68MTsRzi9Esynt2X0r8BuDpjPy82JQ',
      status: _UserStatus.late,
    ),
  ];

  List<_User> get _filteredUsers {
    if (_searchTerm.isEmpty) return _allUsers;
    final term = _searchTerm.toLowerCase();
    return _allUsers.where((u) {
      return u.name.toLowerCase().contains(term) ||
          u.email.toLowerCase().contains(term) ||
          u.employeeId.toLowerCase().contains(term) ||
          u.department.toLowerCase().contains(term);
    }).toList();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteUser(int index) {
    final user = _filteredUsers[index];
    setState(() {
      _allUsers.removeWhere((u) => u.employeeId == user.employeeId);
    });
    _showSnack('${user.name} removed');
  }

  void _retrainUser(_User user) {
    _showSnack('Re-training face profile for ${user.name}...');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.marginMobile,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + description
            Text(
              'Registered Users',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage facial recognition profiles and staff directories.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: LumenSpacing.lg),

            // Search bar
            _SearchBar(
              onChanged: (value) => setState(() => _searchTerm = value),
            ),
            const SizedBox(height: LumenSpacing.lg),

            // Bento summary cards
            _StatsBento(),
            const SizedBox(height: LumenSpacing.lg),

            _filteredUsers.isEmpty
                ? _EmptyState()
                : Expanded(
                    child: ListView.separated(
                      itemCount: _filteredUsers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return _UserCard(
                          user: _filteredUsers[index],
                          onRetrain: () => _retrainUser(_filteredUsers[index]),
                          onDelete: () => _deleteUser(index),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Search Bar
// ──────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LumenLightColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LumenLightColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search by name, ID, or department...',
          prefixIcon: const Icon(Icons.search, color: LumenLightColors.outline),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 4-card Bento Stats
// ──────────────────────────────────────────────────────────────────────────────

class _StatsBento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    Widget card(String label, String value, Color valueColor) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: LumenLightColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: LumenLightColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: tt.labelMedium?.copyWith(
                color: LumenLightColors.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: tt.titleMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.4,
      children: [
        card('Total Users', '1,248', Theme.of(context).colorScheme.primary),
        card('Departments', '12', Theme.of(context).colorScheme.primary),
        card('Active Status', '98.2%', Theme.of(context).colorScheme.secondary),
        card('Needs Retrain', '4', Theme.of(context).colorScheme.tertiary),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Local model
// ──────────────────────────────────────────────────────────────────────────────
enum _UserStatus { punctual, remote, late }

class _User {
  final String name;
  final String email;
  final String employeeId;
  final String department;
  final String avatarUrl;
  final _UserStatus status;
  const _User({
    required this.name,
    required this.email,
    required this.employeeId,
    required this.department,
    required this.avatarUrl,
    this.status = _UserStatus.punctual,
  });
}
// ──────────────────────────────────────────────────────────────────────────────
// User Card (exactly matching the dark HTML reference)
// ──────────────────────────────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.onRetrain,
    required this.onDelete,
  });

  final _User user;
  final VoidCallback onRetrain;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final (statusLabel, statusColor) = switch (user.status) {
      _UserStatus.punctual => (
        'Punctual',
        Theme.of(context).colorScheme.secondary,
      ),
      _UserStatus.remote => ('Remote', Theme.of(context).colorScheme.primary),
      _UserStatus.late => ('Late', Theme.of(context).colorScheme.error),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Image.network(
                user.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: const Icon(Icons.person, color: Colors.white30),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Status badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        statusLabel,
                        style: tt.labelMedium?.copyWith(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${user.employeeId}',
                  style: tt.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  user.department,
                  style: tt.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.face_retouching_natural, size: 22),
                color: Theme.of(context).colorScheme.primaryContainer,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: onRetrain,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 22),
                color: Theme.of(context).colorScheme.error,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Empty State
// ──────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: LumenDarkColors.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(color: LumenDarkColors.outlineVariant),
            ),
            child: const Icon(
              Icons.person_search,
              size: 40,
              color: LumenDarkColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No users registered yet.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding a new user to the biometric database.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: LumenDarkColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
