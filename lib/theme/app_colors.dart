import 'package:flutter/material.dart';

/// Lumen Interface — Dark Theme Colors
abstract class LumenDarkColors {
  // Surfaces
  static const Color surface               = Color(0xFF131313);
  static const Color surfaceDim            = Color(0xFF131313);
  static const Color surfaceBright         = Color(0xFF393939);
  static const Color surfaceContainerLowest= Color(0xFF0E0E0E);
  static const Color surfaceContainerLow   = Color(0xFF1C1B1B);
  static const Color surfaceContainer      = Color(0xFF201F1F);
  static const Color surfaceContainerHigh  = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest= Color(0xFF353534);

  // On-Surface
  static const Color onSurface            = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant     = Color(0xFFC1C6D6);

  // Inverse
  static const Color inverseSurface       = Color(0xFFE5E2E1);
  static const Color inverseOnSurface     = Color(0xFF313030);

  // Outline
  static const Color outline              = Color(0xFF8B909F);
  static const Color outlineVariant       = Color(0xFF414754);

  // Primary
  static const Color primary              = Color(0xFFADC7FF);
  static const Color onPrimary            = Color(0xFF002E68);
  static const Color primaryContainer     = Color(0xFF1A73E8);
  static const Color onPrimaryContainer   = Color(0xFFFFFFFF);
  static const Color inversePrimary       = Color(0xFF005BC0);
  static const Color surfaceTint          = Color(0xFFADC7FF);

  // Secondary (success green)
  static const Color secondary            = Color(0xFF6DDD81);
  static const Color onSecondary          = Color(0xFF003914);
  static const Color secondaryContainer   = Color(0xFF30A550);
  static const Color onSecondaryContainer = Color(0xFF003210);

  // Tertiary (accent orange)
  static const Color tertiary             = Color(0xFFFFB691);
  static const Color onTertiary           = Color(0xFF552100);
  static const Color tertiaryContainer    = Color(0xFFC55500);
  static const Color onTertiaryContainer  = Color(0xFF0E0200);

  // Error
  static const Color error                = Color(0xFFFFB4AB);
  static const Color onError              = Color(0xFF690005);
  static const Color errorContainer       = Color(0xFF93000A);
  static const Color onErrorContainer     = Color(0xFFFFDAD6);

  // Background
  static const Color background           = Color(0xFF131313);
  static const Color onBackground         = Color(0xFFE5E2E1);
  static const Color surfaceVariant       = Color(0xFF353534);

  // Semantic aliases
  static const Color neonAccent           = Color(0xFF39FF14); // bounding boxes / tracking nodes
  static const Color offlineAmber         = Color(0xFFFFB700);
  static const Color syncingAmber         = Color(0xFFFF9F00);
}

/// Lumen Interface Light — Light Theme Colors
abstract class LumenLightColors {
  // Surfaces
  static const Color surface               = Color(0xFFF7F9FF);
  static const Color surfaceDim            = Color(0xFFD7DAE0);
  static const Color surfaceBright         = Color(0xFFF7F9FF);
  static const Color surfaceContainerLowest= Color(0xFFFFFFFF);
  static const Color surfaceContainerLow   = Color(0xFFF1F4FA);
  static const Color surfaceContainer      = Color(0xFFEBEEF4);
  static const Color surfaceContainerHigh  = Color(0xFFE5E8EE);
  static const Color surfaceContainerHighest= Color(0xFFDFE3E8);

  // On-Surface
  static const Color onSurface            = Color(0xFF181C20);
  static const Color onSurfaceVariant     = Color(0xFF414754);

  // Inverse
  static const Color inverseSurface       = Color(0xFF2D3135);
  static const Color inverseOnSurface     = Color(0xFFEEF1F7);

  // Outline
  static const Color outline              = Color(0xFF727785);
  static const Color outlineVariant       = Color(0xFFC1C6D6);

  // Primary
  static const Color primary              = Color(0xFF005BBF);
  static const Color onPrimary            = Color(0xFFFFFFFF);
  static const Color primaryContainer     = Color(0xFF1A73E8);
  static const Color onPrimaryContainer   = Color(0xFFFFFFFF);
  static const Color inversePrimary       = Color(0xFFADC7FF);
  static const Color surfaceTint          = Color(0xFF005BC0);

  // Secondary (success green)
  static const Color secondary            = Color(0xFF006E2C);
  static const Color onSecondary          = Color(0xFFFFFFFF);
  static const Color secondaryContainer   = Color(0xFF86F898);
  static const Color onSecondaryContainer = Color(0xFF00722F);

  // Tertiary
  static const Color tertiary             = Color(0xFF9E4300);
  static const Color onTertiary           = Color(0xFFFFFFFF);
  static const Color tertiaryContainer    = Color(0xFFC55500);
  static const Color onTertiaryContainer  = Color(0xFF0E0200);

  // Error
  static const Color error                = Color(0xFFBA1A1A);
  static const Color onError              = Color(0xFFFFFFFF);
  static const Color errorContainer       = Color(0xFFFFDAD6);
  static const Color onErrorContainer     = Color(0xFF93000A);

  // Background
  static const Color background           = Color(0xFFF7F9FF);
  static const Color onBackground         = Color(0xFF181C20);
  static const Color surfaceVariant       = Color(0xFFDFE3E8);

  // Component-specific
  static const Color cardBorder           = Color(0xFFDADCE0);
  static const Color divider              = Color(0xFFF1F3F4);
  static const Color chipBackground       = Color(0xFFE8EAED);

  // Semantic aliases
  static const Color successIndicator     = Color(0xFF34A853);
  static const Color warningIndicator     = Color(0xFFFFB700);
}

/// Status chip semantic colors (theme-independent names mapped per theme)
class LumenStatusColors {
  final Color punctual;
  final Color late;
  final Color remote;
  final Color offline;
  final Color syncing;

  const LumenStatusColors({
    required this.punctual,
    required this.late,
    required this.remote,
    required this.offline,
    required this.syncing,
  });

  static const dark = LumenStatusColors(
    punctual: LumenDarkColors.secondary,
    late:     LumenDarkColors.error,
    remote:   LumenDarkColors.primary,
    offline:  Color(0xFF8B909F),
    syncing:  LumenDarkColors.offlineAmber,
  );

  static const light = LumenStatusColors(
    punctual: LumenLightColors.successIndicator,
    late:     LumenLightColors.error,
    remote:   LumenLightColors.primary,
    offline:  Color(0xFF727785),
    syncing:  LumenLightColors.warningIndicator,
  );
}
