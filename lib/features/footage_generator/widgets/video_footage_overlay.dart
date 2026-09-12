import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/story_card_data.dart';
import '../models/video_timeline_state.dart';

// ---------------------------------------------------------------------------
// Colour constants – consistent with story_card_widget.dart
// ---------------------------------------------------------------------------

const _kBackground = Color(0xFF0A0C10);
const _kStravoOrange = Color(0xFFFF5500);
const _kCyberGreen = Color(0xFF00FF9D);
const _kElectricCyan = Color(0xFF00E5FF);
const _kTextPrimary = Color(0xFFFFFFFF);
const _kTextSecondary = Color(0xFFB0B8C4);
const _kCardSurface = Color(0xFF14171E);

// ---------------------------------------------------------------------------
// VideoFootageOverlay – composites phase-aware UI on top of 3D map frames
// ---------------------------------------------------------------------------

/// A transparent overlay that renders phase-aware UI elements for the
/// 30-second cinematic video. Drive it by passing successive
/// [VideoTimelineFrame]s from an animation controller.
class VideoFootageOverlay extends StatelessWidget {
  final VideoTimelineFrame frame;
  final StoryCardData data;

  const VideoFootageOverlay({
    super.key,
    required this.frame,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: data.aspectRatio.width.toDouble(),
      height: data.aspectRatio.height.toDouble(),
      child: Stack(
        children: [
          // Phase-specific overlays
          if (frame.currentPhase == VideoSegmentPhase.intro)
            _IntroOverlay(frame: frame, data: data),
          if (frame.currentPhase == VideoSegmentPhase.flyoverTracking)
            _FlyoverOverlay(frame: frame, data: data),
          if (frame.currentPhase == VideoSegmentPhase.outroSummary)
            _OutroOverlay(data: data),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Intro Overlay (0 – 3 s): fade-in title, date, logo
// ---------------------------------------------------------------------------

class _IntroOverlay extends StatelessWidget {
  final VideoTimelineFrame frame;
  final StoryCardData data;

  const _IntroOverlay({required this.frame, required this.data});

  @override
  Widget build(BuildContext context) {
    // Linear fade from 0.0 at t=0 to 1.0 at t=2, hold at 1.0 until t=3
    final opacity = (frame.timestampSeconds / 2.0).clamp(0.0, 1.0);

    return Positioned.fill(
      child: Container(
        color: _kBackground.withValues(alpha: 0.7),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
        child: Opacity(
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STRAVO PRO logo
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'STRAVO',
                    style: TextStyle(
                      color: _kTextPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'PRO',
                    style: TextStyle(
                      color: _kStravoOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Activity title
              Text(
                data.title,
                style: TextStyle(
                  color: _kTextPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              // Date + Sport + Distance
              Text(
                '${_formatDate(data.date)} • ${data.sportType}',
                style: TextStyle(color: _kTextSecondary, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                '${data.distanceKm.toStringAsFixed(1)} km',
                style: TextStyle(
                  color: _kCyberGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} '
      '${_monthName(d.month)} '
      '${d.year}';

  static String _monthName(int m) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[m.clamp(1, 12)];
  }
}

// ---------------------------------------------------------------------------
// Flyover Tracking Overlay (3 – 24 s): Mini HUD + Elevation Bar + Waypoints
// ---------------------------------------------------------------------------

class _FlyoverOverlay extends StatelessWidget {
  final VideoTimelineFrame frame;
  final StoryCardData data;

  const _FlyoverOverlay({required this.frame, required this.data});

  @override
  Widget build(BuildContext context) {
    // Interpolate speed from route progress
    final progress = frame.routeProgress;
    final coveredKm = data.distanceKm * progress;

    // Rough speed interpolation from coordinates
    double currentSpeedKmH = data.avgSpeedKmH;
    if (data.coordinates.isNotEmpty) {
      final idx = (progress * (data.coordinates.length - 1)).round().clamp(0, data.coordinates.length - 1);
      final coord = data.coordinates[idx];
      final spd = coord.speedKmPerHour;
      if (spd != null) currentSpeedKmH = spd;
    }

    return Stack(
      children: [
        // --- Mini Telemetry HUD (top-right) ---
        Positioned(
          top: 40,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _kCardSurface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kCyberGreen.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Speed
                Text(
                  currentSpeedKmH.toStringAsFixed(1),
                  style: TextStyle(
                    color: _kCyberGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'km/h',
                  style: TextStyle(color: _kTextSecondary, fontSize: 10, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                // Distance
                Text(
                  coveredKm.toStringAsFixed(1),
                  style: TextStyle(
                    color: _kTextPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'km',
                  style: TextStyle(color: _kTextSecondary, fontSize: 10, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),

        // --- Running Elevation Bar (bottom) ---
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 48,
          child: CustomPaint(
            painter: _ElevationBarPainter(
              coordinates: data.coordinates,
              progress: progress,
            ),
            child: const SizedBox.expand(),
          ),
        ),

        // --- KM Waypoint Pop-up ---
        if (frame.activeWaypointIndex != null)
          Positioned(
            left: 24,
            top: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _kStravoOrange.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag, color: _kTextPrimary, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'KM ${frame.activeWaypointIndex}',
                    style: TextStyle(
                      color: _kTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Mini elevation bar that fills left-to-right based on route progress.
class _ElevationBarPainter extends CustomPainter {
  final List<dynamic> coordinates;
  final double progress;

  _ElevationBarPainter({required this.coordinates, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Background bar
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = _kCardSurface.withValues(alpha: 0.7),
    );

    if (coordinates.isEmpty) return;

    // Gather elevations
    final elevations = <double>[];
    for (final c in coordinates) {
      final e = (c as dynamic).elevation;
      elevations.add((e is double && e.isFinite) ? e : 0.0);
    }

    final minE = elevations.reduce(math.min);
    final maxE = elevations.reduce(math.max);
    final range = maxE - minE;
    final effectiveRange = range > 0.01 ? range : 1.0;

    // Draw filled elevation profile up to progress
    final fillCount = (progress * elevations.length).ceil().clamp(0, elevations.length);
    if (fillCount < 2) return;

    final path = Path();
    final stepW = size.width / (elevations.length - 1);

    for (var i = 0; i < fillCount; i++) {
      final x = i * stepW;
      final y = size.height - ((elevations[i] - minE) / effectiveRange) * (size.height * 0.8);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Close area
    final lastX = (fillCount - 1) * stepW;
    path.lineTo(lastX, size.height);
    path.lineTo(0, size.height);
    path.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        _kElectricCyan.withValues(alpha: 0.6),
        _kElectricCyan.withValues(alpha: 0.1),
      ],
    );
    canvas.drawPath(path, Paint()..shader = gradient.createShader(Offset.zero & size));

    // Stroke on top
    // Rebuild stroke path (without the close)
    final strokePath = Path();
    for (var i = 0; i < fillCount; i++) {
      final x = i * stepW;
      final y = size.height - ((elevations[i] - minE) / effectiveRange) * (size.height * 0.8);
      if (i == 0) {
        strokePath.moveTo(x, y);
      } else {
        strokePath.lineTo(x, y);
      }
    }
    canvas.drawPath(
      strokePath,
      Paint()
        ..color = _kElectricCyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_ElevationBarPainter old) =>
      progress != old.progress || !identical(coordinates, old.coordinates);
}

// ---------------------------------------------------------------------------
// Outro Summary Overlay (24 – 30 s): Stats recap card
// ---------------------------------------------------------------------------

class _OutroOverlay extends StatelessWidget {
  final StoryCardData data;

  const _OutroOverlay({required this.data});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: _kBackground.withValues(alpha: 0.85),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kTextPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 32),
            // Stats 2x2 grid
            Row(
              children: [
                _OutroStat(label: 'TOTAL DISTANCE', value: '${data.distanceKm.toStringAsFixed(1)} km'),
                _OutroStat(label: 'MOVING TIME', value: data.formattedDuration),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _OutroStat(label: 'MAX SPEED', value: '${data.maxSpeedKmH.toStringAsFixed(1)} km/h'),
                _OutroStat(label: 'ELEVATION GAIN', value: '${data.elevationGainMeters.round()} m'),
              ],
            ),
            const SizedBox(height: 40),
            // Stravo branding
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}

class _OutroStat extends StatelessWidget {
  final String label;
  final String value;
  const _OutroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: _kCyberGreen,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _kTextSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
