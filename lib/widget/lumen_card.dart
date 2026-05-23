import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Lumen Design System — Card
///
/// Solid card for both themes. In dark: uses surface-container-low with 1px outline border.
/// In light: uses pure white with a 1px #DADCE0 border. No shadow on static cards.
class LumenCard extends StatelessWidget {
  const LumenCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  final Widget  child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback?       onTap;
  final Color?              color;

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final bgColor = color ?? (isDark
        ? LumenDarkColors.surfaceContainerLow
        : LumenLightColors.surfaceContainerLowest);
    final borderColor = isDark
        ? LumenDarkColors.outlineVariant
        : LumenLightColors.cardBorder;
    final radius = isDark ? LumenRadius.cardDark : LumenRadius.cardLight;

    Widget card = Container(
      decoration: BoxDecoration(
        color:        bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: padding ?? const EdgeInsets.all(LumenSpacing.sm),
      child: child,
    );

    if (onTap != null) {
      card = InkWell(
        onTap:       onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      );
    }

    return card;
  }
}

/// Glass card — for overlays placed on top of the camera viewfinder (dark theme)
/// or elevated floating panels (light theme).
class LumenGlassCard extends StatelessWidget {
  const LumenGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.blurRadius = LumenElevation.glassBlurRadius,
  });

  final Widget  child;
  final EdgeInsetsGeometry? padding;
  final double  blurRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = isDark ? LumenRadius.cardDark : LumenRadius.cardLight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: LumenElevation.glassFillOpacity)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : LumenLightColors.cardBorder,
              width: 1,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(LumenSpacing.sm),
          child: child,
        ),
      ),
    );
  }
}

/// Attendance history log card — displays a single check-in record.
class LumenAttendanceCard extends StatelessWidget {
  const LumenAttendanceCard({
    super.key,
    required this.name,
    required this.time,
    required this.status,
    this.idLabel,
    this.matchPercent,
    this.avatarUrl,
    this.onTap,
  });

  final String    name;
  final String    time;         // e.g. "08:42 AM"
  final LumenAttendanceStatus status;
  final String?   idLabel;      // e.g. "ID-00347"
  final int?      matchPercent; // 0–100
  final String?   avatarUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt     = Theme.of(context).textTheme;

    return LumenCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.sm,
        vertical:   LumenSpacing.xs,
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: isDark
                ? LumenDarkColors.surfaceContainerHigh
                : LumenLightColors.surfaceContainerHigh,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Icon(Icons.person_outline,
                    color: isDark
                        ? LumenDarkColors.onSurfaceVariant
                        : LumenLightColors.onSurfaceVariant)
                : null,
          ),
          const SizedBox(width: LumenSpacing.xs),

          // Name + ID
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                if (idLabel != null)
                  Text(
                    idLabel!.toUpperCase(),
                    style: tt.labelMedium,
                  ),
              ],
            ),
          ),

          // Time + match %
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: tt.displaySmall?.copyWith(fontSize: 18)),
              if (matchPercent != null)
                Text(
                  '$matchPercent% MATCH',
                  style: tt.labelMedium?.copyWith(
                    color: matchPercent! >= 85
                        ? (isDark ? LumenDarkColors.secondary : LumenLightColors.successIndicator)
                        : (isDark ? LumenDarkColors.error : LumenLightColors.error),
                  ),
                ),
            ],
          ),
          const SizedBox(width: LumenSpacing.xs),

          // Status chip
          LumenStatusChip(status: status),
        ],
      ),
    );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────

enum LumenAttendanceStatus { punctual, late, remote, offline, syncing }

class LumenStatusChip extends StatelessWidget {
  const LumenStatusChip({super.key, required this.status});
  final LumenAttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final colors  = isDark ? LumenStatusColors.dark : LumenStatusColors.light;
    final tt      = Theme.of(context).textTheme;

    final (label, color) = switch (status) {
      LumenAttendanceStatus.punctual => ('Punctual', colors.punctual),
      LumenAttendanceStatus.late     => ('Late',     colors.late),
      LumenAttendanceStatus.remote   => ('Remote',   colors.remote),
      LumenAttendanceStatus.offline  => ('Offline',  colors.offline),
      LumenAttendanceStatus.syncing  => ('Syncing',  colors.syncing),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.xs,
        vertical:   3,
      ),
      decoration: BoxDecoration(
        color:        color.withValues(alpha: 0.15),
        border:       Border.all(color: color.withValues(alpha: 0.4), width: 1),
        borderRadius: BorderRadius.circular(LumenRadius.full),
      ),
      child: Text(
        label,
        style: tt.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
