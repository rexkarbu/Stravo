import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';

class NeonSpeedometerGauge extends StatelessWidget {
  final double currentSpeed;
  final double maxSpeed;
  final String unit;

  const NeonSpeedometerGauge({
    super.key,
    required this.currentSpeed,
    this.maxSpeed = 60.0,
    this.unit = 'km/h',
  });

  @override
  Widget build(BuildContext context) {
    // Normalize speed for the gauge
    final normalizedSpeed = (currentSpeed / maxSpeed).clamp(0.0, 1.0);

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The gauge drawing
          CustomPaint(
            size: const Size(280, 280),
            painter: _SpeedometerPainter(progress: normalizedSpeed),
          ),
          
          // Center Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentSpeed.toStringAsFixed(1),
                style: StravoTypography.speedLarge,
              ),
              const SizedBox(height: 4),
              Text(
                unit.toUpperCase(),
                style: StravoTypography.metricUnit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double progress;

  _SpeedometerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Sweep angle is 240 degrees (from 150 to 390 degrees)
    const startAngle = 150 * math.pi / 180;
    const sweepAngle = 240 * math.pi / 180;

    // 1. Draw Background Track
    final trackPaint = Paint()
      ..color = StravoColors.surfaceElevated
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
      
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // 2. Draw Progress Glow
    if (progress > 0) {
      final progressSweep = sweepAngle * progress;
      
      // Determine color based on speed relative to max
      Color glowColor = StravoColors.orangePrimary;
      if (progress > 0.8) {
        glowColor = StravoColors.neonPink; // Very fast
      } else if (progress > 0.5) {
        glowColor = StravoColors.neonYellow;
      }
      
      // Outer blur (Neon effect)
      final glowPaint = Paint()
        ..color = glowColor.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
        
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        progressSweep,
        false,
        glowPaint,
      );

      // Inner solid progress line
      final progressPaint = Paint()
        ..color = glowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
        
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        progressSweep,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
