import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/story_card_data.dart';

// ---------------------------------------------------------------------------
// Colour constants – Stravo Pro dark premium palette
// ---------------------------------------------------------------------------

const _kBackground = Color(0xFF0A0C10);
const _kStravoOrange = Color(0xFFFF5500);
const _kCyberGreen = Color(0xFF00FF9D);
const _kElectricCyan = Color(0xFF00E5FF);
const _kTextPrimary = Color(0xFFFFFFFF);
const _kTextSecondary = Color(0xFFB0B8C4);
const _kCardSurface = Color(0xFF14171E);

// ---------------------------------------------------------------------------
// StoryCardWidget – self-contained, no external deps
// ---------------------------------------------------------------------------

/// Renders a social-media-ready story card at the pixel size defined by
/// [StoryCardAspect]. Wrap inside a [RepaintBoundary] + [GlobalKey] to
/// capture as PNG via the generator service.
class StoryCardWidget extends StatelessWidget {
  final StoryCardData data;

  const StoryCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final w = data.aspectRatio.width.toDouble();
    final h = data.aspectRatio.height.toDouble();
    final isStory = data.aspectRatio == StoryCardAspect.story9x16;

    return SizedBox(
      width: w,
      height: h,
      child: ColoredBox(
        color: _kBackground,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.06,
            vertical: h * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Header ----
              _Header(data: data),
              SizedBox(height: h * 0.025),

              // ---- Route Map (centerpiece) ----
              Expanded(
                flex: isStory ? 5 : 4,
                child: _RouteMapSection(data: data),
              ),
              SizedBox(height: h * 0.02),

              // ---- Elevation Profile ----
              Expanded(
                flex: isStory ? 2 : 2,
                child: _ElevationSection(data: data),
              ),
              SizedBox(height: h * 0.02),

              // ---- Stats Grid ----
              _StatsGrid(data: data),
              SizedBox(height: h * 0.015),

              // ---- Footer ----
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final StoryCardData data;
  const _Header({required this.data});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${data.date.day.toString().padLeft(2, '0')} '
        '${_monthName(data.date.month)} '
        '${data.date.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo line
        Row(
          children: [
            Text(
              'STRAVO',
              style: TextStyle(
                color: _kTextPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'PRO',
              style: TextStyle(
                color: _kStravoOrange,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Title
        Text(
          data.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _kTextPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        // Date + Sport chip
        Row(
          children: [
            Text(
              dateStr,
              style: TextStyle(color: _kTextSecondary, fontSize: 14),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _kStravoOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kStravoOrange.withValues(alpha: 0.5)),
              ),
              child: Text(
                data.sportType.toUpperCase(),
                style: TextStyle(
                  color: _kStravoOrange,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _monthName(int m) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[m.clamp(1, 12)];
  }
}

// ---------------------------------------------------------------------------
// Route Map Section (with CustomPainter)
// ---------------------------------------------------------------------------

class _RouteMapSection extends StatelessWidget {
  final StoryCardData data;
  const _RouteMapSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kCardSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: RoutePathPainter(coordinates: data.coordinates),
        child: const SizedBox.expand(),
      ),
    );
  }
}

/// Draws GPS route path normalised to canvas with neon glow effect.
class RoutePathPainter extends CustomPainter {
  final List<dynamic> coordinates; // List<RouteCoordinate>

  RoutePathPainter({required this.coordinates});

  @override
  void paint(Canvas canvas, Size size) {
    if (coordinates.isEmpty) return;

    // Extract lat/lng from coordinates
    final lats = <double>[];
    final lngs = <double>[];
    for (final c in coordinates) {
      lats.add((c as dynamic).latitude as double);
      lngs.add((c as dynamic).longitude as double);
    }

    if (lats.length < 2) {
      // Single point: draw a dot
      final paint = Paint()
        ..color = _kCyberGreen
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 6, paint);
      return;
    }

    final minLat = lats.reduce(math.min);
    final maxLat = lats.reduce(math.max);
    final minLng = lngs.reduce(math.min);
    final maxLng = lngs.reduce(math.max);

    final latRange = maxLat - minLat;
    final lngRange = maxLng - minLng;

    // Avoid divide-by-zero for flat/constant routes
    final effectiveLatRange = latRange > 1e-8 ? latRange : 1e-8;
    final effectiveLngRange = lngRange > 1e-8 ? lngRange : 1e-8;

    // Padding inside the canvas
    const pad = 24.0;
    final drawW = size.width - pad * 2;
    final drawH = size.height - pad * 2;

    // Scale to fit, preserving aspect ratio
    final scaleX = drawW / effectiveLngRange;
    final scaleY = drawH / effectiveLatRange;
    final scale = math.min(scaleX, scaleY);

    final centeredW = effectiveLngRange * scale;
    final centeredH = effectiveLatRange * scale;
    final offsetX = pad + (drawW - centeredW) / 2;
    final offsetY = pad + (drawH - centeredH) / 2;

    Offset toCanvas(double lat, double lng) {
      final x = offsetX + (lng - minLng) * scale;
      // Flip Y: higher lat = lower y
      final y = offsetY + centeredH - (lat - minLat) * scale;
      return Offset(x, y);
    }

    // Build path
    final path = Path();
    final first = toCanvas(lats[0], lngs[0]);
    path.moveTo(first.dx, first.dy);
    for (var i = 1; i < lats.length; i++) {
      final pt = toCanvas(lats[i], lngs[i]);
      path.lineTo(pt.dx, pt.dy);
    }

    // Glow pass (wider, blurred)
    final glowPaint = Paint()
      ..color = _kCyberGreen.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // Core line
    final linePaint = Paint()
      ..color = _kCyberGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    // Start dot (green)
    canvas.drawCircle(first, 5, Paint()..color = _kCyberGreen);

    // Finish dot (orange)
    final last = toCanvas(lats.last, lngs.last);
    canvas.drawCircle(last, 5, Paint()..color = _kStravoOrange);
  }

  @override
  bool shouldRepaint(RoutePathPainter oldDelegate) =>
      !identical(coordinates, oldDelegate.coordinates);
}

// ---------------------------------------------------------------------------
// Elevation Section (with CustomPainter)
// ---------------------------------------------------------------------------

class _ElevationSection extends StatelessWidget {
  final StoryCardData data;
  const _ElevationSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kCardSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: ElevationProfilePainter(coordinates: data.coordinates),
        child: const SizedBox.expand(),
      ),
    );
  }
}

/// Draws an area-chart elevation profile with vertical gradient fill.
class ElevationProfilePainter extends CustomPainter {
  final List<dynamic> coordinates; // List<RouteCoordinate>

  ElevationProfilePainter({required this.coordinates});

  @override
  void paint(Canvas canvas, Size size) {
    if (coordinates.isEmpty) return;

    // Gather elevations, defaulting to 0 if absent
    final elevations = <double>[];
    for (final c in coordinates) {
      final e = (c as dynamic).elevation;
      elevations.add((e is double && e.isFinite) ? e : 0.0);
    }

    if (elevations.length < 2) return;

    final minE = elevations.reduce(math.min);
    final maxE = elevations.reduce(math.max);
    final range = maxE - minE;
    final effectiveRange = range > 0.01 ? range : 1.0;

    const padX = 8.0;
    const padTop = 10.0;
    const padBot = 4.0;
    final drawW = size.width - padX * 2;
    final drawH = size.height - padTop - padBot;

    double xFor(int i) => padX + (i / (elevations.length - 1)) * drawW;
    double yFor(double e) =>
        padTop + drawH - ((e - minE) / effectiveRange) * drawH;

    // Build path
    final profilePath = Path();
    profilePath.moveTo(xFor(0), yFor(elevations[0]));
    for (var i = 1; i < elevations.length; i++) {
      profilePath.lineTo(xFor(i), yFor(elevations[i]));
    }

    // Closed area path for fill
    final areaPath = Path.from(profilePath);
    areaPath.lineTo(xFor(elevations.length - 1), size.height);
    areaPath.lineTo(xFor(0), size.height);
    areaPath.close();

    // Gradient fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        _kElectricCyan.withValues(alpha: 0.5),
        _kElectricCyan.withValues(alpha: 0.0),
      ],
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(Offset.zero & size);
    canvas.drawPath(areaPath, fillPaint);

    // Profile stroke
    final strokePaint = Paint()
      ..color = _kElectricCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(profilePath, strokePaint);

    // Peak line and label
    if (range > 0.01) {
      final peakIdx = elevations.indexOf(maxE);
      final peakX = xFor(peakIdx);
      final peakY = yFor(maxE);

      // Dashed-style line (simple solid for ponytail simplicity)
      final dashPaint = Paint()
        ..color = _kTextSecondary.withValues(alpha: 0.4)
        ..strokeWidth = 1.0;
      canvas.drawLine(
        Offset(peakX, peakY),
        Offset(peakX, size.height - padBot),
        dashPaint,
      );

      // Peak dot
      canvas.drawCircle(
        Offset(peakX, peakY),
        3.5,
        Paint()..color = _kElectricCyan,
      );

      // Peak label
      final tp = TextPainter(
        text: TextSpan(
          text: '${maxE.round()}m',
          style: TextStyle(
            color: _kElectricCyan,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(peakX - tp.width / 2, peakY - tp.height - 4));
    }
  }

  @override
  bool shouldRepaint(ElevationProfilePainter oldDelegate) =>
      !identical(coordinates, oldDelegate.coordinates);
}

// ---------------------------------------------------------------------------
// Stats Grid
// ---------------------------------------------------------------------------

class _StatsGrid extends StatelessWidget {
  final StoryCardData data;
  const _StatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCell(label: 'DISTANCE', value: '${data.distanceKm.toStringAsFixed(1)} km'),
        _StatCell(label: 'TIME', value: data.formattedDuration),
        _StatCell(label: 'ELEVATION', value: '${data.elevationGainMeters.round()} m'),
        _StatCell(label: 'AVG SPEED', value: '${data.avgSpeedKmH.toStringAsFixed(1)} km/h'),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: _kTextPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: _kTextSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '100% OFFLINE DATA SOVEREIGNTY \u2022 MOUNT KAMOJANG 3D',
        style: TextStyle(
          color: _kTextSecondary.withValues(alpha: 0.5),
          fontSize: 9,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
