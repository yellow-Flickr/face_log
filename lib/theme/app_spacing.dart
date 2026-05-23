/// Lumen Design System — Spacing & Sizing Constants
///
/// Dark theme uses a 4px base grid (unit: 4px).
/// Light theme uses the same 4px/8px scale.
/// This file unifies both into a single token set.
abstract class LumenSpacing {
  // Base unit (shared)
  static const double unit     = 4.0;

  // Scale
  static const double xs       = 8.0;   // element-gap (dark) / xs (light)
  static const double sm       = 16.0;  // stack-gap (dark) / sm (light)
  static const double md       = 24.0;  // light md
  static const double lg       = 40.0;  // light lg
  static const double xl       = 64.0;  // light xl

  // Page margins
  static const double containerPadding  = 20.0; // dark spec
  static const double marginMobile      = 16.0; // light spec mobile
  static const double marginDesktop     = 48.0; // light spec desktop
  static const double gutter            = 24.0; // light grid gutter

  // Vertical rhythm
  static const double stackGap          = 16.0;
  static const double elementGap        = 8.0;
  static const double sectionMargin     = 32.0;

  // Camera / bounding box safe zone
  static const double cameraButtonClearZone = 40.0;

  // Component sizes
  static const double fabSize           = 64.0;
  static const double statusIndicatorDot= 8.0;
  static const double iconSize          = 24.0;
  static const double iconSizeSmall     = 16.0;
}

/// Lumen Design System — Border Radius Tokens
abstract class LumenRadius {
  // Dark theme (more rounded)
  static const double darkSm      = 4.0;   // 0.25rem
  static const double darkDefault = 8.0;   // 0.5rem
  static const double darkMd      = 12.0;  // 0.75rem — buttons & inputs
  static const double darkLg      = 16.0;  // 1rem   — cards & viewfinder
  static const double darkXl      = 24.0;  // 1.5rem
  static const double full        = 9999.0;

  // Light theme (more precise, less rounded)
  static const double lightSm      = 2.0;  // 0.125rem
  static const double lightDefault = 4.0;  // 0.25rem — buttons & inputs
  static const double lightMd      = 6.0;  // 0.375rem
  static const double lightLg      = 8.0;  // 0.5rem  — cards
  static const double lightXl      = 12.0; // 0.75rem — large modals

  // Semantic aliases
  static const double buttonDark   = darkMd;   // 12px
  static const double buttonLight  = lightDefault; // 4px
  static const double cardDark     = darkLg;   // 16px
  static const double cardLight    = lightLg;  // 8px
  static const double inputDark    = darkMd;   // 12px
  static const double inputLight   = lightDefault; // 4px
  static const double chipDark     = full;
  static const double chipLight    = full;
  static const double checkboxLight= 2.0;
}

/// Lumen Design System — Elevation / Shadow Tokens
abstract class LumenElevation {
  // Light theme ambient shadows (dark theme uses tonal layering instead)
  static const List<Map<String, dynamic>> level2 = [
    {
      'offset': (0.0, 4.0),
      'blurRadius': 20.0,
      'color': 0x14000000, // rgba(0,0,0,0.08)
    }
  ];
  static const List<Map<String, dynamic>> level3 = [
    {
      'offset': (0.0, 12.0),
      'blurRadius': 40.0,
      'color': 0x1F000000, // rgba(0,0,0,0.12)
    }
  ];

  // Glassmorphism (dark theme overlays)
  static const double glassBlurRadius    = 20.0;
  static const double glassFillOpacity   = 0.6;  // 60% opacity dark fill
  static const double neonGlowBlurRadius = 12.0;
}
