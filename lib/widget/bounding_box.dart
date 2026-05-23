import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Bounding box state for face/object tracking overlays
enum LumenBoundingBoxState {
  /// Actively scanning — bracket frame, neon accent color
  scanning,

  /// Face locked / candidate found — brackets pulse subtly
  locked,

  /// Match confirmed — solid circle overlay, success green
  matched,

  /// No match / rejected — error red frame
  rejected,
}

/// Lumen Design System — Camera Bounding Box Overlay
///
/// Dark:  square-bracket frame in neon accent green, pulses on lock,
///        transforms to success circle on match.
/// Light: same states with primary blue / success / error colors.
///
/// Wrap the live camera widget and stack this on top:
///
///   Stack(children: [
///     CameraPreview(controller),
///     Positioned(
///       left: x, top: y,
///       child: LumenBoundingBox(
///         width: w, height: h,
///         state: _boxState,
///       ),
///     ),
///   ])
class BoundingBox extends StatefulWidget {
  const BoundingBox({
    super.key,
    required this.width,
    required this.height,
    this.state = LumenBoundingBoxState.scanning,
    this.cornerLength = 20.0,
    this.strokeWidth = 2.5,
    this.label,
    this.confidence,
  });

  final double width;
  final double height;
  final LumenBoundingBoxState state;

  /// Corner bracket arm length in logical pixels
  final double cornerLength;
  final double strokeWidth;

  /// Optional top label (e.g. detected class name)
  final String? label;

  /// 0.0–1.0 confidence
  final double? confidence;

  @override
  State<BoundingBox> createState() => _BoundingBoxState();
}

class _BoundingBoxState extends State<BoundingBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacity = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    _updateAnimation();
  }

  @override
  void didUpdateWidget(BoundingBox old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state) _updateAnimation();
  }

  void _updateAnimation() {
    if (widget.state == LumenBoundingBoxState.locked) {
      _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt = Theme.of(context).textTheme;

    final activeColor = switch (widget.state) {
      LumenBoundingBoxState.scanning =>
        isDark ? LumenDarkColors.neonAccent : LumenLightColors.primary,
      LumenBoundingBoxState.locked =>
        isDark ? LumenDarkColors.neonAccent : LumenLightColors.primary,
      LumenBoundingBoxState.matched =>
        isDark ? LumenDarkColors.secondary : LumenLightColors.successIndicator,
      LumenBoundingBoxState.rejected =>
        isDark ? LumenDarkColors.error : LumenLightColors.error,
    };

    final glowColor = activeColor.withValues(alpha: 0.45);

    if (widget.state == LumenBoundingBoxState.matched) {
      // Transform to a success circle
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Container(
            width: widget.width * 0.85,
            height: widget.width * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: activeColor, width: widget.strokeWidth),
              boxShadow: [
                BoxShadow(
                  color: glowColor,
                  blurRadius: LumenElevation.neonGlowBlurRadius,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.check_rounded,
                color: activeColor,
                size: widget.width * 0.3,
              ),
            ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) => Opacity(
        opacity: _opacity.value,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              // Bracket frame painter
              CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _BracketPainter(
                  color: activeColor,
                  glowColor: isDark ? glowColor : Colors.transparent,
                  cornerLength: widget.cornerLength,
                  strokeWidth: widget.strokeWidth,
                ),
              ),

              // Top label
              if (widget.label != null)
                Positioned(
                  top: -22,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.label!,
                      style: tt.labelMedium?.copyWith(
                        color: isDark
                            ? Colors.black
                            : LumenLightColors.surfaceContainerLowest,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

              // Bottom-right confidence badge
              if (widget.confidence != null)
                Positioned(
                  bottom: -22,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: activeColor.withValues(alpha: 0.15),
                      border: Border.all(
                        color: activeColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(LumenRadius.full),
                    ),
                    child: Text(
                      '${(widget.confidence! * 100).toStringAsFixed(0)}%',
                      style: tt.labelMedium?.copyWith(color: activeColor),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter({
    required this.color,
    required this.glowColor,
    required this.cornerLength,
    required this.strokeWidth,
  });

  final Color color;
  final Color glowColor;
  final double cornerLength;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Glow pass (dark only)
    if (glowColor != Colors.transparent) {
      final glowPaint = Paint()
        ..color = glowColor
        ..strokeWidth = strokeWidth + 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      _drawBrackets(canvas, size, glowPaint);
    }

    // Solid pass
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    _drawBrackets(canvas, size, paint);
  }

  void _drawBrackets(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final c = cornerLength;

    // Top-left
    canvas.drawLine(Offset(0, c), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(c, 0), paint);

    // Top-right
    canvas.drawLine(Offset(w - c, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, c), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, h - c), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(c, h), paint);

    // Bottom-right
    canvas.drawLine(Offset(w - c, h), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - c), paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) =>
      old.color != color ||
      old.cornerLength != cornerLength ||
      old.strokeWidth != strokeWidth;
}
