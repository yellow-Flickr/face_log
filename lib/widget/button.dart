import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum LumenButtonVariant { primary, secondary, ghost, destructive }

enum LumenButtonSize { sm, md, lg }

/// Lumen Design System — Button
///
/// Adapts its radius and fill to the active theme:
///   dark  → 12px radius, solid primaryContainer fill
///   light → 4px radius, solid primaryContainer fill
///
/// Example:
///   LumenButton(
///     label: 'Check In',
///     icon:  Icons.fingerprint,
///     onPressed: _handleCheckIn,
///   )
class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = LumenButtonVariant.primary,
    this.size = LumenButtonSize.md,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LumenButtonVariant variant;
  final LumenButtonSize size;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = isDark ? LumenRadius.buttonDark : LumenRadius.buttonLight;

    final (hPad, vPad, iconSize) = switch (size) {
      LumenButtonSize.sm => (LumenSpacing.xs, LumenSpacing.elementGap, 16.0),
      LumenButtonSize.md => (LumenSpacing.sm, LumenSpacing.xs, 18.0),
      LumenButtonSize.lg => (LumenSpacing.md, LumenSpacing.xs + 4, 20.0),
    };

    final textStyle =
        (size == LumenButtonSize.sm ? tt.bodyMedium : tt.bodyLarge)?.copyWith(
          fontWeight: FontWeight.w600,
        );

    Widget child = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _fgColor(variant, cs),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSize),
                SizedBox(width: LumenSpacing.elementGap / 2),
              ],
              Text(label),
            ],
          );

    if (fullWidth) {
      child = Center(child: child);
    }

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    return switch (variant) {
      LumenButtonVariant.primary => SizedBox(
        width: fullWidth ? double.infinity : null,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primaryContainer,
            foregroundColor: cs.onPrimaryContainer,
            disabledBackgroundColor: cs.primaryContainer.withValues(alpha: 0.5),
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            shape: shape,
            textStyle: textStyle,
          ),
          child: child,
        ),
      ),

      LumenButtonVariant.secondary => SizedBox(
        width: fullWidth ? double.infinity : null,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? cs.onSurface : cs.onSurface,
            side: BorderSide(
              color: isDark
                  ? LumenDarkColors.outline
                  : LumenLightColors.cardBorder,
            ),
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            shape: shape,
            textStyle: textStyle,
          ),
          child: child,
        ),
      ),

      LumenButtonVariant.ghost => SizedBox(
        width: fullWidth ? double.infinity : null,
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: cs.primary,
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            shape: shape,
            textStyle: textStyle,
          ),
          child: child,
        ),
      ),

      LumenButtonVariant.destructive => SizedBox(
        width: fullWidth ? double.infinity : null,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.errorContainer,
            foregroundColor: cs.onErrorContainer,
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            shape: shape,
            textStyle: textStyle,
          ),
          child: child,
        ),
      ),
    };
  }

  Color _fgColor(LumenButtonVariant v, ColorScheme cs) => switch (v) {
    LumenButtonVariant.primary => cs.onPrimaryContainer,
    LumenButtonVariant.secondary => cs.onSurface,
    LumenButtonVariant.ghost => cs.primary,
    LumenButtonVariant.destructive => cs.onErrorContainer,
  };
}

/// Oversized camera-trigger FAB with glassmorphic ring (dark) or shadow ring (light)
class LumenCameraFab extends StatelessWidget {
  const LumenCameraFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.camera_alt_outlined,
    this.heroTag,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      children: [
        // glassmorphic / shadow ring
        Container(
          width: LumenSpacing.fabSize + 16,
          height: LumenSpacing.fabSize + 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? LumenDarkColors.primary.withValues(alpha: 0.3)
                  : LumenLightColors.primary.withValues(alpha: 0.2),
              width: 2,
            ),
            color: isDark
                ? LumenDarkColors.primaryContainer.withValues(alpha: 0.1)
                : LumenLightColors.primary.withValues(alpha: 0.05),
          ),
        ),
        SizedBox(
          width: LumenSpacing.fabSize,
          height: LumenSpacing.fabSize,
          child: FloatingActionButton(
            heroTag: heroTag,
            onPressed: onPressed,
            elevation: isDark ? 4 : 2,
            child: Icon(icon, size: 28),
          ),
        ),
      ],
    );
  }
}
