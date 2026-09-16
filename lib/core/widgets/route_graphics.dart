import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';

/// Mini Route Polyline Thumbnail Painter
class MiniRouteThumbnail extends StatelessWidget {
  final List<Offset> points;
  final Color strokeColor;
  final double strokeWidth;

  const MiniRouteThumbnail({
    super.key,
    required this.points,
    this.strokeColor = StravoColors.orangePrimary,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoutePainter(
        points: points,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final List<Offset> points;
  final Color strokeColor;
  final double strokeWidth;

  _RoutePainter({
    required this.points,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    double minX = points.first.dx;
    double maxX = points.first.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;

    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }

    final double width = maxX - minX;
    final double height = maxY - minY;
    if (width == 0 || height == 0) return;

    const double padding = 8.0;
    final double scaleX = (size.width - padding * 2) / width;
    final double scaleY = (size.height - padding * 2) / height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double offsetX = (size.width - width * scale) / 2 - minX * scale;
    final double offsetY = (size.height - height * scale) / 2 - minY * scale;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = points[i].dx * scale + offsetX;
      final y = points[i].dy * scale + offsetY;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Glow effect
    final glowPaint = Paint()
      ..color = strokeColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);

    // Start point (cyber green dot)
    if (points.isNotEmpty) {
      final start = Offset(
        points.first.dx * scale + offsetX,
        points.first.dy * scale + offsetY,
      );
      canvas.drawCircle(start, 3.5, Paint()..color = StravoColors.cyberGreen);
      canvas.drawCircle(start, 1.5, Paint()..color = Colors.white);
    }

    // Finish point (checker / orange dot)
    if (points.length > 1) {
      final end = Offset(
        points.last.dx * scale + offsetX,
        points.last.dy * scale + offsetY,
      );
      canvas.drawCircle(end, 4.0, Paint()..color = StravoColors.orangePrimary);
      canvas.drawCircle(end, 2.0, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.strokeColor != strokeColor;
}

/// Interactive Cyber Elevation Profile Chart
class ElevationProfileChart extends StatelessWidget {
  final List<double> elevations;
  final double height;
  final Color primaryColor;

  const ElevationProfileChart({
    super.key,
    required this.elevations,
    this.height = 140,
    this.primaryColor = StravoColors.orangePrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ElevationChartPainter(
          elevations: elevations,
          chartColor: primaryColor,
        ),
      ),
    );
  }
}

class _ElevationChartPainter extends CustomPainter {
  final List<double> elevations;
  final Color chartColor;

  _ElevationChartPainter({required this.elevations, required this.chartColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (elevations.length < 2) return;

    final double minEle = elevations.reduce((a, b) => a < b ? a : b);
    final double maxEle = elevations.reduce((a, b) => a > b ? a : b);
    final double eleRange = (maxEle - minEle == 0) ? 1.0 : (maxEle - minEle);

    const double topPad = 12.0;
    const double bottomPad = 24.0;
    final double usableHeight = size.height - topPad - bottomPad;

    final linePath = Path();
    final fillPath = Path();

    final stepX = size.width / (elevations.length - 1);

    for (int i = 0; i < elevations.length; i++) {
      final x = i * stepX;
      final normalized = (elevations[i] - minEle) / eleRange;
      final y = size.height - bottomPad - (normalized * usableHeight);

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height - bottomPad);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * stepX;
        final prevNormalized = (elevations[i - 1] - minEle) / eleRange;
        final prevY = size.height - bottomPad - (prevNormalized * usableHeight);
        final cx = (prevX + x) / 2;
        linePath.cubicTo(cx, prevY, cx, y, x, y);
        fillPath.cubicTo(cx, prevY, cx, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height - bottomPad);
    fillPath.close();

    // Fill with cyberpunk gradient
    final gradient = ui.Gradient.linear(
      Offset(0, topPad),
      Offset(0, size.height - bottomPad),
      [chartColor.withValues(alpha: 0.35), chartColor.withValues(alpha: 0.0)],
    );

    final fillPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Line glow
    final glowPaint = Paint()
      ..color = chartColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, glowPaint);

    // Crisp line
    final linePaint = Paint()
      ..color = chartColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Draw baseline
    final basePaint = Paint()
      ..color = StravoColors.glassBorder
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(0, size.height - bottomPad),
      Offset(size.width, size.height - bottomPad),
      basePaint,
    );

    // Draw min / max labels
    final tpMin = TextPainter(
      text: TextSpan(
        text: '${minEle.toInt()}m',
        style: const TextStyle(
          color: StravoColors.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpMin.paint(canvas, Offset(0, size.height - 18));

    final tpMax = TextPainter(
      text: TextSpan(
        text: '${maxEle.toInt()}m max',
        style: const TextStyle(
          color: StravoColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpMax.paint(canvas, Offset(size.width - tpMax.width, 0));
  }

  @override
  bool shouldRepaint(covariant _ElevationChartPainter oldDelegate) =>
      oldDelegate.elevations != elevations ||
      oldDelegate.chartColor != chartColor;
}
