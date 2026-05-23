import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Lumen Design System — ThemeData Factory
///
/// Usage:
///   MaterialApp(
///     theme:      LumenTheme.light(),
///     darkTheme:  LumenTheme.dark(),
///     themeMode:  ThemeMode.system,
///   )
abstract class LumenTheme {
  // ─── Dark ─────────────────────────────────────────────────────────────────

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,

      // Primary
      primary:              LumenDarkColors.primary,
      onPrimary:            LumenDarkColors.onPrimary,
      primaryContainer:     LumenDarkColors.primaryContainer,
      onPrimaryContainer:   LumenDarkColors.onPrimaryContainer,

      // Secondary
      secondary:            LumenDarkColors.secondary,
      onSecondary:          LumenDarkColors.onSecondary,
      secondaryContainer:   LumenDarkColors.secondaryContainer,
      onSecondaryContainer: LumenDarkColors.onSecondaryContainer,

      // Tertiary
      tertiary:             LumenDarkColors.tertiary,
      onTertiary:           LumenDarkColors.onTertiary,
      tertiaryContainer:    LumenDarkColors.tertiaryContainer,
      onTertiaryContainer:  LumenDarkColors.onTertiaryContainer,

      // Error
      error:                LumenDarkColors.error,
      onError:              LumenDarkColors.onError,
      errorContainer:       LumenDarkColors.errorContainer,
      onErrorContainer:     LumenDarkColors.onErrorContainer,

      // Surface
      surface:              LumenDarkColors.surface,
      onSurface:            LumenDarkColors.onSurface,
      surfaceContainerHighest: LumenDarkColors.surfaceContainerHighest,
      onSurfaceVariant:     LumenDarkColors.onSurfaceVariant,

      // Outline
      outline:              LumenDarkColors.outline,
      outlineVariant:       LumenDarkColors.outlineVariant,

      // Inverse
      inverseSurface:       LumenDarkColors.inverseSurface,
      onInverseSurface:     LumenDarkColors.inverseOnSurface,
      inversePrimary:       LumenDarkColors.inversePrimary,

      surfaceTint:          LumenDarkColors.surfaceTint,
    );

    final textTheme = LumenTypography.darkTextTheme(
      LumenDarkColors.onSurface,
      LumenDarkColors.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness:   Brightness.dark,
      colorScheme:  colorScheme,
      textTheme:    textTheme,
      scaffoldBackgroundColor: LumenDarkColors.background,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:  LumenDarkColors.surfaceContainerLow,
        foregroundColor:  LumenDarkColors.onSurface,
        elevation:        0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        titleTextStyle:   textTheme.headlineSmall,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: LumenDarkColors.onSurface),
      ),

      // ── Cards ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color:        LumenDarkColors.surfaceContainerLow,
        elevation:    0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.cardDark),
          side: const BorderSide(
            color: LumenDarkColors.outlineVariant,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: LumenSpacing.elementGap / 2),
      ),

      // ── Buttons ─────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:  LumenDarkColors.primaryContainer,
          foregroundColor:  LumenDarkColors.onPrimaryContainer,
          elevation:        0,
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.sm,
            vertical:   LumenSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LumenRadius.buttonDark),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LumenDarkColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.sm,
            vertical:   LumenSpacing.xs,
          ),
          side: const BorderSide(color: LumenDarkColors.outline, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LumenRadius.buttonDark),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LumenDarkColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.xs,
            vertical:   LumenSpacing.elementGap,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LumenRadius.buttonDark),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor:  LumenDarkColors.primaryContainer,
        foregroundColor:  LumenDarkColors.onPrimaryContainer,
        elevation:        4,
        shape: CircleBorder(),
      ),

      // ── Inputs ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:      true,
        fillColor:   LumenDarkColors.surfaceContainerLow,
        hintStyle:   textTheme.bodyMedium?.copyWith(
          color: LumenDarkColors.onSurfaceVariant,
        ),
        labelStyle:  textTheme.bodyMedium?.copyWith(
          color: LumenDarkColors.onSurfaceVariant,
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return textTheme.bodyMedium!.copyWith(color: LumenDarkColors.primary);
          }
          return textTheme.bodyMedium!.copyWith(color: LumenDarkColors.onSurfaceVariant);
        }),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputDark),
          borderSide: const BorderSide(color: LumenDarkColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputDark),
          borderSide: const BorderSide(color: LumenDarkColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputDark),
          borderSide: const BorderSide(
            color: LumenDarkColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputDark),
          borderSide: const BorderSide(color: LumenDarkColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.sm,
          vertical:   LumenSpacing.xs,
        ),
      ),

      // ── Chips ───────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:    LumenDarkColors.surfaceContainerHigh,
        selectedColor:      LumenDarkColors.primaryContainer,
        disabledColor:      LumenDarkColors.surfaceContainerHighest,
        labelStyle:         textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.xs,
          vertical:   LumenSpacing.elementGap / 2,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      // ── List Tiles ──────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor:         Colors.transparent,
        selectedTileColor: LumenDarkColors.surfaceContainerHigh,
        iconColor:         LumenDarkColors.onSurfaceVariant,
        textColor:         LumenDarkColors.onSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.containerPadding,
          vertical:   LumenSpacing.elementGap / 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.darkMd),
        ),
      ),

      // ── Navigation ──────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:      LumenDarkColors.surfaceContainerLow,
        indicatorColor:       LumenDarkColors.primaryContainer.withValues(alpha: 0.24),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: LumenDarkColors.primary);
          }
          return const IconThemeData(color: LumenDarkColors.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(color: LumenDarkColors.primary);
          }
          return textTheme.labelMedium?.copyWith(color: LumenDarkColors.onSurfaceVariant);
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color:     LumenDarkColors.outlineVariant,
        thickness: 1,
        space:     1,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: LumenDarkColors.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.darkLg),
        ),
        titleTextStyle:   textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
      ),

      // ── SnackBar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: LumenDarkColors.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: LumenDarkColors.inverseOnSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.darkMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Switch / Checkbox / Radio ────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return LumenDarkColors.onPrimary;
          return LumenDarkColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return LumenDarkColors.primary;
          return LumenDarkColors.surfaceContainerHighest;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return LumenDarkColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(LumenDarkColors.onPrimary),
        side: const BorderSide(color: LumenDarkColors.outline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Progress Indicator ───────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color:            LumenDarkColors.primary,
        linearTrackColor: LumenDarkColors.outlineVariant,
      ),
    );
  }

  // ─── Light ────────────────────────────────────────────────────────────────

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,

      primary:              LumenLightColors.primary,
      onPrimary:            LumenLightColors.onPrimary,
      primaryContainer:     LumenLightColors.primaryContainer,
      onPrimaryContainer:   LumenLightColors.onPrimaryContainer,

      secondary:            LumenLightColors.secondary,
      onSecondary:          LumenLightColors.onSecondary,
      secondaryContainer:   LumenLightColors.secondaryContainer,
      onSecondaryContainer: LumenLightColors.onSecondaryContainer,

      tertiary:             LumenLightColors.tertiary,
      onTertiary:           LumenLightColors.onTertiary,
      tertiaryContainer:    LumenLightColors.tertiaryContainer,
      onTertiaryContainer:  LumenLightColors.onTertiaryContainer,

      error:                LumenLightColors.error,
      onError:              LumenLightColors.onError,
      errorContainer:       LumenLightColors.errorContainer,
      onErrorContainer:     LumenLightColors.onErrorContainer,

      surface:              LumenLightColors.surface,
      onSurface:            LumenLightColors.onSurface,
      surfaceContainerHighest: LumenLightColors.surfaceContainerHighest,
      onSurfaceVariant:     LumenLightColors.onSurfaceVariant,

      outline:              LumenLightColors.outline,
      outlineVariant:       LumenLightColors.outlineVariant,

      inverseSurface:       LumenLightColors.inverseSurface,
      onInverseSurface:     LumenLightColors.inverseOnSurface,
      inversePrimary:       LumenLightColors.inversePrimary,

      surfaceTint:          LumenLightColors.surfaceTint,
    );

    final textTheme = LumenTypography.lightTextTheme(
      LumenLightColors.onSurface,
      LumenLightColors.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness:   Brightness.light,
      colorScheme:  colorScheme,
      textTheme:    textTheme,
      scaffoldBackgroundColor: LumenLightColors.background,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:  LumenLightColors.surfaceContainerLowest,
        foregroundColor:  LumenLightColors.onSurface,
        elevation:        0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        titleTextStyle:   textTheme.titleMedium,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: LumenLightColors.onSurface),
        shadowColor: Color(0x14000000),
      ),

      // ── Cards ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color:        LumenLightColors.surfaceContainerLowest,
        elevation:    0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.cardLight),
          side: const BorderSide(
            color: LumenLightColors.cardBorder,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: LumenSpacing.elementGap / 2),
      ),

      // ── Buttons ─────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:  LumenLightColors.primaryContainer,
          foregroundColor:  LumenLightColors.onPrimaryContainer,
          elevation:        0,
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.sm,
            vertical:   LumenSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LumenRadius.buttonLight),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LumenLightColors.onSurface,
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.sm,
            vertical:   LumenSpacing.xs,
          ),
          side: const BorderSide(color: LumenLightColors.cardBorder, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LumenRadius.buttonLight),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LumenLightColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: LumenSpacing.xs,
            vertical:   LumenSpacing.elementGap,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LumenRadius.buttonLight),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor:  LumenLightColors.primaryContainer,
        foregroundColor:  LumenLightColors.onPrimaryContainer,
        elevation:        2,
        shape: CircleBorder(),
      ),

      // ── Inputs ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: LumenLightColors.surfaceContainerLowest,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: LumenLightColors.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: LumenLightColors.onSurfaceVariant,
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return textTheme.bodyMedium!.copyWith(color: LumenLightColors.primary);
          }
          return textTheme.bodyMedium!.copyWith(color: LumenLightColors.onSurfaceVariant);
        }),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputLight),
          borderSide: const BorderSide(color: LumenLightColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputLight),
          borderSide: const BorderSide(color: LumenLightColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputLight),
          borderSide: const BorderSide(
            color: LumenLightColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LumenRadius.inputLight),
          borderSide: const BorderSide(color: LumenLightColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.sm,
          vertical:   LumenSpacing.xs,
        ),
      ),

      // ── Chips ───────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:     LumenLightColors.chipBackground,
        selectedColor:       LumenLightColors.primary.withValues(alpha: 0.12),
        disabledColor:       LumenLightColors.surfaceContainerHigh,
        labelStyle:          textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.xs,
          vertical:   LumenSpacing.elementGap / 2,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      // ── List Tiles ──────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor:         Colors.transparent,
        selectedTileColor: LumenLightColors.surfaceContainerHigh,
        iconColor:         LumenLightColors.onSurfaceVariant,
        textColor:         LumenLightColors.onSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: LumenSpacing.sm,
          vertical:   LumenSpacing.elementGap / 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.lightLg),
        ),
      ),

      // ── Navigation ──────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:   LumenLightColors.surfaceContainerLowest,
        indicatorColor:    LumenLightColors.primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: LumenLightColors.primary);
          }
          return const IconThemeData(color: LumenLightColors.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(color: LumenLightColors.primary);
          }
          return textTheme.labelMedium?.copyWith(color: LumenLightColors.onSurfaceVariant);
        }),
        elevation:        0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Color(0x14000000),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color:     LumenLightColors.divider,
        thickness: 1,
        space:     1,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor:  LumenLightColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shadowColor: Color(0x1F000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.lightXl),
        ),
        titleTextStyle:   textTheme.headlineMedium,
        contentTextStyle: textTheme.bodyLarge,
      ),

      // ── SnackBar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: LumenLightColors.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: LumenLightColors.inverseOnSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LumenRadius.lightLg),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Switch / Checkbox / Radio ────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return LumenLightColors.onPrimary;
          return LumenLightColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return LumenLightColors.primary;
          return LumenLightColors.surfaceContainerHigh;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return LumenLightColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(LumenLightColors.onPrimary),
        side: const BorderSide(color: LumenLightColors.cardBorder, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),

      // ── Progress Indicator ───────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color:            LumenLightColors.primary,
        linearTrackColor: LumenLightColors.surfaceContainerHigh,
      ),

      // ── Data Table ───────────────────────────────────────────────────────
      dataTableTheme: DataTableThemeData(
        headingRowColor:  WidgetStateProperty.all(LumenLightColors.surfaceContainerLow),
        dataRowColor:     WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return LumenLightColors.primary.withValues(alpha: 0.08);
          }
          return LumenLightColors.surfaceContainerLowest;
        }),
        dividerThickness: 1,
        headingTextStyle: textTheme.labelMedium?.copyWith(
          color: LumenLightColors.onSurfaceVariant,
        ),
        dataTextStyle:    textTheme.bodyMedium,
        horizontalMargin: LumenSpacing.sm,
        columnSpacing:    LumenSpacing.md,
      ),
    );
  }
}
