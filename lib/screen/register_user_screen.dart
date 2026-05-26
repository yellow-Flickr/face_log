import 'package:face_log/theme/app_colors.dart';
import 'package:face_log/theme/app_spacing.dart';
import 'package:face_log/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Employee Registration / Face Enrollment screen
/// Light-themed, matching the "Attendance Pro" registration flow.
class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  bool _isCapturing = false;
  bool _isSuccess = false;

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  String _selectedDepartment = 'Infrastructure & Security';

  final List<String> _departments = [
    'Infrastructure & Security',
    'Financial Operations',
    'Product Development',
    'Legal & Compliance',
  ];

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
    _scanController.dispose();
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _captureFace() async {
    if (_nameController.text.trim().isEmpty ||
        _idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in name and employee ID')),
      );
      return;
    }

    setState(() {
      _isCapturing = true;
      _isSuccess = false;
    });

    // Simulate processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isCapturing = false;
        _isSuccess = true;
      });

      // Show success and pop after delay
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: LumenTheme.light(),
      child: Scaffold(
        backgroundColor: LumenLightColors.background,
        appBar: AppBar(
          title: const Text('Attendance Pro'),
          centerTitle: false,
          backgroundColor: LumenLightColors.surface,
          foregroundColor: LumenLightColors.primary,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: LumenLightColors.outlineVariant),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(LumenSpacing.marginMobile),
            child: Column(
              children: [
                // Two-column layout (stacks on mobile)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildCameraSection()),
                              const SizedBox(width: 24),
                              Expanded(child: _buildFormSection()),
                            ],
                          )
                        : Column(
                            children: [
                              _buildCameraSection(),
                              const SizedBox(height: 24),
                              _buildFormSection(),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraSection() {
    return Column(
      children: [
        // Camera preview with overlays
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LumenLightColors.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background image (simulated camera feed)
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDNW5RjDpzZAjOOrmpXpl6X9ef1r8ASubMJvN4s_s6a1G2h0lq5__WDyB6o2xrB8KQsKrUiS2MfeeSGQsexGD1rGGROR64JM8N0zkoaKJ7cwcDYwLKiN3Kd8xbd0Eqek52NHvuRxYTAhr7e5QpnGUkKI1nezuafrQF-EpNOrLYugIje25S6mupARmTdBmuS0a-wficZAJD5qsUxXOtMKbU1mpCtEeI-mS7i_iZmqnXj8YCWORm27pUFLT224PSizFjIKxNrznKcrbk',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, _, _) => Container(color: Colors.black87),
                  ),

                  // Oval guide + scan line + brackets
                  Positioned.fill(
                    child: Stack(
                      children: [
                        // Oval mask border
                        Center(
                          child: Container(
                            width: 220,
                            height: 280,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: LumenLightColors.primaryContainer,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(140),
                            ),
                          ),
                        ),

                        // Animated scan line
                        AnimatedBuilder(
                          animation: _scanController,
                          builder: (context, _) {
                            final progress = _scanController.value;
                            return Positioned(
                              top: 60 + (progress * 160),
                              left: 60,
                              right: 60,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      LumenLightColors.primary,
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: LumenLightColors.primary
                                          .withValues(alpha: 0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Corner brackets
                        Positioned(
                          top: 40,
                          left: 40,
                          child: _CornerBracket(topLeft: true),
                        ),
                        Positioned(
                          top: 40,
                          right: 40,
                          child: _CornerBracket(topRight: true),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 40,
                          child: _CornerBracket(bottomLeft: true),
                        ),
                        Positioned(
                          bottom: 40,
                          right: 40,
                          child: _CornerBracket(bottomRight: true),
                        ),
                      ],
                    ),
                  ),

                  // Quality indicator at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: LumenLightColors.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quality Score',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'Good quality',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: LumenLightColors.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: 0.85,
                            backgroundColor: LumenLightColors.surfaceContainer,
                            color: LumenLightColors.secondary,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Position your face within the oval. Ensure you are in a well-lit environment for optimal recognition.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: LumenLightColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _CornerBracket({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: CustomPaint(
        painter: _BracketPainter(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
          color: LumenLightColors.primaryContainer,
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LumenLightColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LumenLightColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employee Registration',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete your profile to enable facial attendance.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: LumenLightColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // Form fields
          _buildInputField(
            label: 'Full Name',
            icon: Icons.person,
            controller: _nameController,
            hint: 'e.g. Sarah Jenkins',
          ),
          const SizedBox(height: 16),

          _buildInputField(
            label: 'Employee ID',
            icon: Icons.badge,
            controller: _idController,
            hint: 'EMP-102934',
          ),
          const SizedBox(height: 16),

          // Department dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Department',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: LumenLightColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedDepartment,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.corporate_fare, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: LumenLightColors.outlineVariant,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                items: _departments
                    .map(
                      (dept) =>
                          DropdownMenuItem(value: dept, child: Text(dept)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedDepartment = val!),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Capture button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isCapturing ? null : _captureFace,
              icon: _isSuccess
                  ? const Icon(Icons.check, color: Colors.white)
                  : _isCapturing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.photo_camera),
              label: Text(
                _isSuccess
                    ? 'Enrolled Successfully'
                    : _isCapturing
                    ? 'Processing...'
                    : 'Capture Face',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSuccess
                    ? LumenLightColors.secondary
                    : LumenLightColors.primaryContainer,
                foregroundColor: _isSuccess
                    ? Colors.white
                    : LumenLightColors.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: LumenLightColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: LumenLightColors.outlineVariant),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _BracketPainter extends CustomPainter {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;
  final Color color;

  _BracketPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const length = 28.0;

    if (topLeft) {
      canvas.drawLine(const Offset(0, 0), Offset(0, length), paint);
      canvas.drawLine(const Offset(0, 0), Offset(length, 0), paint);
    }
    if (topRight) {
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width - length, 0),
        paint,
      );
    }
    if (bottomLeft) {
      canvas.drawLine(
        Offset(0, size.height),
        Offset(0, size.height - length),
        paint,
      );
      canvas.drawLine(
        Offset(0, size.height),
        Offset(length, size.height),
        paint,
      );
    }
    if (bottomRight) {
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width, size.height - length),
        paint,
      );
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width - length, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
