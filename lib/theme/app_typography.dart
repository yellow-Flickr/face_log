import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Lumen Design System — Typography
///
/// Dark  → Geist (all roles)
/// Light → Hanken Grotesk (display/headlines) + Inter (body) + JetBrains Mono (labels)
abstract class LumenTypography {
  // ─── Dark theme (Geist) ───────────────────────────────────────────────────

  static TextTheme darkTextTheme(Color onSurface, Color onSurfaceVariant) {
    final base = GoogleFonts.geistTextTheme();

    return base.copyWith(
      // display-lg: 40/48, w700, ls -0.02em
      displayLarge: GoogleFonts.geist(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -0.02 * 40,
        color: onSurface,
      ),
      // headline-md: 24/32, w600, ls -0.01em
      headlineMedium: GoogleFonts.geist(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.01 * 24,
        color: onSurface,
      ),
      // headline-sm: 20/28, w600
      headlineSmall: GoogleFonts.geist(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: onSurface,
      ),
      // body-lg: 16/24, w400
      bodyLarge: GoogleFonts.geist(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: onSurface,
      ),
      // body-md: 14/20, w400
      bodyMedium: GoogleFonts.geist(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: onSurface,
      ),
      // label-md: 12/16, w500, ls 0.05em
      labelMedium: GoogleFonts.geist(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.05 * 12,
        color: onSurfaceVariant,
      ),
      // status-number: 32/40, w700, ls 0.02em — used for clock-in times / match %
      displaySmall: GoogleFonts.geist(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: 0.02 * 32,
        color: onSurface,
      ),
    );
  }

  // ─── Light theme (Hanken Grotesk + Inter + JetBrains Mono) ───────────────

  static TextTheme lightTextTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      // display-lg: 48/56, w700, ls -0.02em  [Hanken Grotesk]
      displayLarge: GoogleFonts.hankenGrotesk(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 56 / 48,
        letterSpacing: -0.02 * 48,
        color: onSurface,
      ),
      // headline-lg: 32/40, w600  [Hanken Grotesk]
      headlineLarge: GoogleFonts.hankenGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        color: onSurface,
      ),
      // headline-lg-mobile: 28/36, w600  [Hanken Grotesk]
      headlineMedium: GoogleFonts.hankenGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
        color: onSurface,
      ),
      // title-md: 20/28, w500  [Hanken Grotesk]
      titleMedium: GoogleFonts.hankenGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 28 / 20,
        color: onSurface,
      ),
      // body-lg: 16/24, w400  [Inter]
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: onSurface,
      ),
      // body-md: 14/20, w400  [Inter]
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: onSurface,
      ),
      // label-md: 12/16, w500, ls 0.05em  [JetBrains Mono]
      labelMedium: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.05 * 12,
        color: onSurfaceVariant,
      ),
      // Small mono labels for IDs, codes
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 16 / 11,
        letterSpacing: 0.05 * 11,
        color: onSurfaceVariant,
      ),
    );
  }
}

/// Role-based text style helpers (use these instead of Theme.of(context).textTheme directly)
extension LumenTextStyles on TextTheme {
  /// Large clock-in time or biometric match percentage
  TextStyle get statusNumber => displaySmall!;

  /// Screen headings
  TextStyle get screenTitle => headlineMedium!;

  /// Card / section title
  TextStyle get cardTitle => headlineSmall ?? titleMedium!;

  /// Primary body copy
  TextStyle get body => bodyLarge!;

  /// Secondary / supporting body
  TextStyle get bodySecondary => bodyMedium!;

  /// Metadata labels (IDs, mode indicators) — rendered uppercase by widgets
  TextStyle get metaLabel => labelMedium!;
}
