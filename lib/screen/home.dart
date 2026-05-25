import 'dart:async';

import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_theme.dart';
import 'package:face_log/widget/bounding_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Home tab content — the live camera viewfinder + mark attendance flow.
/// This widget is rendered inside AppShell and does **not** include the
/// shared header or bottom navigation (those live in the shell).
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _snackVisible = false;
  Timer? _snackTimer;

  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _snackTimer?.cancel();
    _scanController.dispose();
    super.dispose();
  }

  void _markAttendance() {
    HapticFeedback.mediumImpact();

    setState(() => _snackVisible = true);
    _snackTimer?.cancel();
    _snackTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _snackVisible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Force dark aesthetic (the camera experience is always dark)
    return Stack(
      children: [
        // Full-screen cinematic camera background
        const _CameraBackground(),
    
        // Vignette overlay
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black54,
                ],
                stops: [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),
        ),
    
        // Centered viewfinder with brackets + scan line + match panel
        const _ViewfinderStack(),
    
        // Floating action buttons (register / mark / logs)
        _ActionButtonGroup(onMarkAttendance: _markAttendance),
    
        // Custom success snackbar
        if (_snackVisible) const _SuccessSnackbar(),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Background
// ──────────────────────────────────────────────────────────────────────────────

class _CameraBackground extends StatelessWidget {
  const _CameraBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://picsum.photos/id/1011/1200/1400',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => Container(color: LumenDarkColors.surface),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Viewfinder + Match Overlay
// ──────────────────────────────────────────────────────────────────────────────

class _ViewfinderStack extends StatelessWidget {
  const _ViewfinderStack({super.key});

  @override
  Widget build(BuildContext context) {
    const double boxSize = 288.0;

    return Center(
      child: SizedBox(
        width: boxSize,
        height: boxSize + 68,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: boxSize,
              child: const _ViewfinderFrame(size: boxSize),
            ),
            Positioned(
              top: boxSize - 22,
              left: 0,
              right: 0,
              child: const Center(child: _MatchResultPanel()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewfinderFrame extends StatelessWidget {
  const _ViewfinderFrame({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BoundingBox(
          width: size,
          height: size,
          state: LumenBoundingBoxState.locked,
          cornerLength: 48,
          strokeWidth: 4.0,
        ),
        _ScanLine(size: size),
      ],
    );
  }
}

class _ScanLine extends StatefulWidget {
  const _ScanLine({super.key, required this.size});

  final double size;

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pos;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _pos = Tween<double>(begin: 0.02, end: 0.98).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pos,
      builder: (context, _) {
        final top = _pos.value * widget.size;
        return Positioned(
          top: top,
          left: 12,
          right: 12,
          child: Container(
            height: 2.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFF6DDD81),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MatchResultPanel extends StatelessWidget {
  const _MatchResultPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: 264,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LumenDarkColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: LumenDarkColors.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LumenDarkColors.secondary.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: LumenDarkColors.secondary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'John Doe',
                style: tt.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: LumenDarkColors.onSurface,
                ),
              ),
              Text(
                '92% match detected',
                style: tt.labelMedium?.copyWith(
                  color: LumenDarkColors.secondary,
                  fontSize: 12,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Action Buttons
// ──────────────────────────────────────────────────────────────────────────────

class _ActionButtonGroup extends StatelessWidget {
  const _ActionButtonGroup({super.key, required this.onMarkAttendance});

  final VoidCallback onMarkAttendance;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 92),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _GlassIconButton(icon: Icons.person_add, onPressed: () {}),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: onMarkAttendance,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: LumenDarkColors.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: LumenDarkColors.secondary.withValues(alpha: 0.5),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      color: LumenDarkColors.onSecondary,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'MARK ATTENDANCE',
                    style: tt.labelMedium?.copyWith(
                      color: LumenDarkColors.secondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            _GlassIconButton(icon: Icons.history, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: LumenDarkColors.surface.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(color: LumenDarkColors.outlineVariant, width: 1),
        ),
        child: Icon(icon, color: LumenDarkColors.onSurface, size: 24),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Success Snackbar
// ──────────────────────────────────────────────────────────────────────────────

class _SuccessSnackbar extends StatelessWidget {
  const _SuccessSnackbar({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Positioned(
      bottom: 138,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          decoration: BoxDecoration(
            color: LumenDarkColors.secondaryContainer,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: LumenDarkColors.secondary.withValues(alpha: 0.2),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: LumenDarkColors.onSecondaryContainer,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Attendance marked successfully!',
                style: tt.bodyMedium?.copyWith(
                  color: LumenDarkColors.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
