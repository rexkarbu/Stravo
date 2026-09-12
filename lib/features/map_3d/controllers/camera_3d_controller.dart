import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../domain/models/route_coordinate.dart';

/// Immutable value object representing the 3D cinematic camera state at a given frame/progress.
@immutable
class Camera3DState {
  /// Target center latitude in degrees.
  final double latitude;

  /// Target center longitude in degrees.
  final double longitude;

  /// Target elevation above sea level in meters.
  final double elevation;

  /// Camera bearing (rotation/heading) in degrees (0.0 to 360.0).
  /// 0 = North, 90 = East, 180 = South, 270 = West.
  final double bearing;

  /// Camera pitch (tilt down from vertical) in degrees (45.0 to 65.0).
  final double pitch;

  /// Camera zoom level (dynamic, typically 13.0 to 17.5).
  final double zoom;

  /// Route progress represented by this state (0.0 to 1.0).
  final double progress;

  const Camera3DState({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.bearing,
    required this.pitch,
    required this.zoom,
    required this.progress,
  });

  /// Serializes camera parameters for MapLibre GL JS / StravoBridge camera methods.
  Map<String, dynamic> toJson() => {
        'center': [longitude, latitude],
        'elevation': elevation,
        'bearing': bearing,
        'pitch': pitch,
        'zoom': zoom,
        'progress': progress,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Camera3DState &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          elevation == other.elevation &&
          bearing == other.bearing &&
          pitch == other.pitch &&
          zoom == other.zoom &&
          progress == other.progress;

  @override
  int get hashCode => Object.hash(
        latitude,
        longitude,
        elevation,
        bearing,
        pitch,
        zoom,
        progress,
      );

  @override
  String toString() =>
      'Camera3DState(lat: ${latitude.toStringAsFixed(5)}, lng: ${longitude.toStringAsFixed(5)}, elev: ${elevation.toStringAsFixed(1)}m, bearing: ${bearing.toStringAsFixed(1)}°, pitch: ${pitch.toStringAsFixed(1)}°, zoom: ${zoom.toStringAsFixed(1)}, prog: ${(progress * 100).toStringAsFixed(1)}%)';
}

/// Controller that computes smooth 3D cinematic camera movements along a GPS route.
///
/// Uses Catmull-Rom cubic splines ($C^1$ continuity) for smooth position and tangential
/// bearing calculations. Implements dynamic camera choreography:
/// - Zoom in & tilt down (higher pitch) during steep climbs.
/// - Zoom out at high summits/peaks for sweeping panoramic vistas.
/// - Smooth bearing tracking without sudden 360° backward spins at North crossings (0°/360°).
class Camera3DController {
  final List<RouteCoordinate> _points;
  final List<double> _distances; // Cumulative distance in meters
  final double _totalDistance;
  final double _minElevation;
  final double _maxElevation;

  Camera3DController._({
    required List<RouteCoordinate> points,
    required List<double> distances,
    required double totalDistance,
    required double minElevation,
    required double maxElevation,
  })  : _points = points,
        _distances = distances,
        _totalDistance = totalDistance,
        _minElevation = minElevation,
        _maxElevation = maxElevation;

  /// Creates a [Camera3DController] from a route.
  ///
  /// Filters invalid coordinates. If fewer than 2 valid coordinates exist,
  /// the controller enters a safe fallback mode.
  factory Camera3DController({required List<RouteCoordinate> route}) {
    final validPoints = route.where((p) => p.isValid).toList(growable: false);

    if (validPoints.length < 2) {
      return Camera3DController._(
        points: validPoints,
        distances: const [0.0],
        totalDistance: 0.0,
        minElevation: 0.0,
        maxElevation: 0.0,
      );
    }

    final distances = <double>[0.0];
    double accumulated = 0.0;
    double minElev = double.infinity;
    double maxElev = -double.infinity;

    for (int i = 0; i < validPoints.length; i++) {
      final p = validPoints[i];
      final elev = p.elevation ?? 0.0;
      if (elev < minElev) minElev = elev;
      if (elev > maxElev) maxElev = elev;

      if (i > 0) {
        final d = _distanceMeters(validPoints[i - 1], p);
        accumulated += d;
        distances.add(accumulated);
      }
    }

    if (minElev.isInfinite) minElev = 0.0;
    if (maxElev.isInfinite) maxElev = 0.0;

    return Camera3DController._(
      points: validPoints,
      distances: distances,
      totalDistance: accumulated,
      minElevation: minElev,
      maxElevation: maxElev,
    );
  }

  /// Total route distance in meters.
  double get totalDistance => _totalDistance;

  /// Number of valid route coordinates.
  int get pointCount => _points.length;

  /// Computes the camera state at a given [progress] (clamped to 0.0 - 1.0).
  Camera3DState getStateAtProgress(double progress) {
    final p = progress.clamp(0.0, 1.0);

    // Edge case: Empty route
    if (_points.isEmpty) {
      return Camera3DState(
        latitude: 0.0,
        longitude: 0.0,
        elevation: 0.0,
        bearing: 0.0,
        pitch: 50.0,
        zoom: 15.0,
        progress: p,
      );
    }

    // Edge case: Single point route or zero total distance
    if (_points.length == 1 || _totalDistance <= 0.0) {
      final single = _points.first;
      return Camera3DState(
        latitude: single.latitude,
        longitude: single.longitude,
        elevation: single.elevation ?? 0.0,
        bearing: 0.0,
        pitch: 50.0,
        zoom: 15.0,
        progress: p,
      );
    }

    // Binary search for the segment index matching target distance
    final targetDist = p * _totalDistance;
    int segIndex = _findSegmentIndex(targetDist);
    final segStartDist = _distances[segIndex];
    final segEndDist = _distances[segIndex + 1];
    final segLen = segEndDist - segStartDist;

    final double t = segLen > 0.0 ? ((targetDist - segStartDist) / segLen).clamp(0.0, 1.0) : 0.0;

    // Catmull-Rom 4 control points
    final p0 = _points[math.max(0, segIndex - 1)];
    final p1 = _points[segIndex];
    final p2 = _points[segIndex + 1];
    final p3 = _points[math.min(_points.length - 1, segIndex + 2)];

    final e0 = p0.elevation ?? p1.elevation ?? 0.0;
    final e1 = p1.elevation ?? 0.0;
    final e2 = p2.elevation ?? p1.elevation ?? 0.0;
    final e3 = p3.elevation ?? p2.elevation ?? 0.0;

    // Interpolated position via Catmull-Rom
    final lat = _catmullRom(p0.latitude, p1.latitude, p2.latitude, p3.latitude, t);
    final lng = _catmullRom(p0.longitude, p1.longitude, p2.longitude, p3.longitude, t);
    final elev = _catmullRom(e0, e1, e2, e3, t);

    // Tangent derivative vector
    final dLat = _catmullRomDerivative(p0.latitude, p1.latitude, p2.latitude, p3.latitude, t);
    final dLng = _catmullRomDerivative(p0.longitude, p1.longitude, p2.longitude, p3.longitude, t);
    final dElev = _catmullRomDerivative(e0, e1, e2, e3, t);

    // Bearing calculation from tangential vector
    final avgLatRad = lat * math.pi / 180.0;
    final x = dLng * math.cos(avgLatRad) * 111320.0;
    final y = dLat * 110540.0;

    double bearing = 0.0;
    if (x.abs() > 1e-6 || y.abs() > 1e-6) {
      final rad = math.atan2(x, y);
      bearing = (rad * 180.0 / math.pi % 360.0 + 360.0) % 360.0;
    } else {
      // Fallback: direction between p1 and p2
      final fallbackDx = (p2.longitude - p1.longitude) * math.cos(avgLatRad) * 111320.0;
      final fallbackDy = (p2.latitude - p1.latitude) * 110540.0;
      final rad = math.atan2(fallbackDx, fallbackDy);
      bearing = (rad * 180.0 / math.pi % 360.0 + 360.0) % 360.0;
    }

    // Dynamic Camera Choreography:
    // 1. Climb Gradient Calculation:
    final dHoriz = math.sqrt(x * x + y * y);
    final gradient = dHoriz > 0.01 ? (dElev / dHoriz) : 0.0;
    final gradientPct = gradient * 100.0; // e.g. 10%

    // Normalized climb factor (-1.0 to +1.0, 15% is Hors Catégorie)
    final climbFactor = (gradientPct / 15.0).clamp(-1.0, 1.0);

    // 2. Summit / High Peak Ratio:
    final elevRange = _maxElevation - _minElevation;
    final peakRatio = elevRange > 1.0 ? ((elev - _minElevation) / elevRange).clamp(0.0, 1.0) : 0.5;

    // Pitch Choreography (45° - 65°):
    // - Base: 50.0°
    // - Steep climbs: tilt down towards terrain (+climbFactor * 15°) -> up to 65.0°
    // - Descents: ease up towards horizon (-5°) -> down to 45.0°
    // - Summits: flatten slightly for panoramic vista
    double pitch = 50.0;
    if (climbFactor > 0.0) {
      pitch += climbFactor * 15.0;
    } else {
      pitch += climbFactor * 5.0;
    }
    if (peakRatio > 0.8) {
      pitch -= (peakRatio - 0.8) * 15.0;
    }
    pitch = pitch.clamp(45.0, 65.0);

    // Zoom Choreography (13.0 - 17.0):
    // - Base: 15.2
    // - Steep climb: zoom in (+1.3) to focus on athlete effort
    // - Descent: zoom slightly wider
    // - Summit / high peak: zoom out (-1.7) to reveal wide landscape
    double zoom = 15.2;
    if (climbFactor > 0.0) {
      zoom += climbFactor * 1.3;
    } else {
      zoom += climbFactor * 0.5;
    }
    if (peakRatio > 0.5) {
      zoom -= (peakRatio - 0.5) * 2.0 * 1.5;
    }
    zoom = zoom.clamp(13.0, 17.5);

    return Camera3DState(
      latitude: lat,
      longitude: lng,
      elevation: elev,
      bearing: bearing,
      pitch: pitch,
      zoom: zoom,
      progress: p,
    );
  }

  // ---------------------------------------------------------------------------
  // Bearing & Spline Utilities
  // ---------------------------------------------------------------------------

  /// Calculates the shortest angular delta from [fromBearing] to [toBearing] in [-180, 180].
  ///
  /// Correctly handles the 0°/360° North crossing (e.g. 350° to 10° gives +20°, not -340°).
  static double shortestAngleDelta(double fromBearing, double toBearing) {
    return (toBearing - fromBearing + 540.0) % 360.0 - 180.0;
  }

  /// Smoothly interpolates bearing from [fromBearing] to [toBearing] at parameter [t] (0.0 to 1.0).
  ///
  /// Guarantees shortest-path rotation without 360° backward spinning across North.
  static double interpolateBearing(double fromBearing, double toBearing, double t) {
    final delta = shortestAngleDelta(fromBearing, toBearing);
    final result = fromBearing + delta * t.clamp(0.0, 1.0);
    return (result % 360.0 + 360.0) % 360.0;
  }

  // ---------------------------------------------------------------------------
  // Internal Helpers
  // ---------------------------------------------------------------------------

  int _findSegmentIndex(double targetDist) {
    int low = 0;
    int high = _points.length - 2;
    int segIndex = 0;

    while (low <= high) {
      final mid = (low + high) >> 1;
      if (_distances[mid] <= targetDist) {
        segIndex = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return segIndex.clamp(0, _points.length - 2);
  }

  static double _catmullRom(double p0, double p1, double p2, double p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;
    return 0.5 * (
      (2.0 * p1) +
      (-p0 + p2) * t +
      (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 +
      (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3
    );
  }

  static double _catmullRomDerivative(double p0, double p1, double p2, double p3, double t) {
    final t2 = t * t;
    return 0.5 * (
      (-p0 + p2) +
      2.0 * (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t +
      3.0 * (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t2
    );
  }

  static double _distanceMeters(RouteCoordinate a, RouteCoordinate b) {
    const latMeters = 110540.0;
    final avgLatRad = (a.latitude + b.latitude) * math.pi / 360.0;
    final lngMeters = 111320.0 * math.cos(avgLatRad);
    final dx = (b.longitude - a.longitude) * lngMeters;
    final dy = (b.latitude - a.latitude) * latMeters;
    return math.sqrt(dx * dx + dy * dy);
  }
}
