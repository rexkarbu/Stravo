import 'dart:math' as math;

import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';
import 'package:stravo/features/segments/models/segment_models.dart';

/// Two-tier spatial matcher: O(1) bounding-box coarse filter + Haversine fine
/// filter. Designed to be called on every GPS tick without draining the battery.
class SegmentMatcher {
  final List<Segment> _segments;

  SegmentMatcher(List<Segment> segments) : _segments = List.unmodifiable(segments);

  List<Segment> get segments => _segments;

  /// Returns the first segment whose start point is within [entryRadiusMeters]
  /// of [userPos], or `null` if none match.
  ///
  /// 1. **Coarse filter** — skip if [userPos] is outside the segment bounding box.
  /// 2. **Fine filter** — Haversine distance to [segment.startPoint].
  Segment? matchPoint(
    RouteCoordinate userPos, {
    double entryRadiusMeters = 25.0,
  }) {
    for (final segment in _segments) {
      // Step 1: O(1) bounding-box check — no trig, battery-friendly.
      if (!segment.boundingBox.contains(userPos)) continue;

      // Step 2: Haversine distance to start point.
      final dist = _haversineMeters(
        userPos.latitude,
        userPos.longitude,
        segment.startPoint.latitude,
        segment.startPoint.longitude,
      );
      if (dist <= entryRadiusMeters) return segment;
    }
    return null;
  }

  /// Whether [userPos] is within [exitRadiusMeters] of [segment.finishPoint].
  bool isNearFinish(
    Segment segment,
    RouteCoordinate userPos, {
    double exitRadiusMeters = 30.0,
  }) {
    return _haversineMeters(
          userPos.latitude,
          userPos.longitude,
          segment.finishPoint.latitude,
          segment.finishPoint.longitude,
        ) <=
        exitRadiusMeters;
  }

  // ── Haversine ──────────────────────────────────────────────

  static const double _earthRadiusMeters = 6371000.0;

  /// Calculates the great-circle distance between two lat/lng points in meters.
  static double _haversineMeters(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return _earthRadiusMeters * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _toRad(double deg) => deg * math.pi / 180.0;
}
