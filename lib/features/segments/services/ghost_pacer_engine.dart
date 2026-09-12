import 'dart:math' as math;

import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';
import 'package:stravo/features/segments/models/segment_models.dart';

/// Simulates a virtual "Ghost Competitor" racing alongside the user in
/// real-time, comparing elapsed time against the personal record (PR).
///
/// Pure Dart, no external dependencies, battery-friendly.
class GhostPacerEngine {
  Segment? _activeSegment;
  double _prSeconds = 0.0;
  String? _startAudioCue;

  /// Whether a segment session is currently active.
  bool get isActive => _activeSegment != null;

  /// The currently active segment, if any.
  Segment? get activeSegment => _activeSegment;

  /// Starts a ghost-pacer session for [segment].
  ///
  /// Uses [customPrSeconds] if provided, otherwise falls back to
  /// [segment.prEffortSeconds], defaulting to 300s (5 min).
  String startSegment(Segment segment, {double? customPrSeconds}) {
    _activeSegment = segment;
    _prSeconds = customPrSeconds ?? segment.prEffortSeconds ?? 300.0;
    final formatted = _formatDuration(_prSeconds);
    _startAudioCue =
        'Mulai segmen ${segment.name}! Rekor terbaikmu $formatted!';
    return _startAudioCue!;
  }

  /// Updates the ghost comparison with the user's current position and elapsed
  /// time.
  ///
  /// Returns a [GhostPacerSnapshot] containing the real-time delta, HUD
  /// message, and optional audio cue.
  GhostPacerSnapshot updatePosition(
    RouteCoordinate currentPos,
    double currentElapsedSeconds,
  ) {
    final segment = _activeSegment;
    if (segment == null) {
      throw StateError('No active segment. Call startSegment() first.');
    }

    final progress = _calculateProgress(currentPos, segment);
    final pacerElapsed = progress * _prSeconds;
    final delta = currentElapsedSeconds - pacerElapsed;
    final ahead = delta <= 0;

    final absDelta = delta.abs();
    final hudMessage = ahead
        ? 'Kamu ${absDelta.toStringAsFixed(1)}s di depan Ghost Pacer'
        : 'Tertinggal ${absDelta.toStringAsFixed(1)}s dari Ghost Pacer';

    return GhostPacerSnapshot(
      segmentName: segment.name,
      progress: progress,
      userElapsedSeconds: currentElapsedSeconds,
      pacerElapsedSeconds: pacerElapsed,
      timeDeltaSeconds: delta,
      isAhead: ahead,
      hudMessage: hudMessage,
    );
  }

  /// Completes the current segment session and returns the [SegmentEffort].
  ///
  /// Generates a celebration audio cue if a new PR is achieved.
  SegmentEffort completeSegment(double finalElapsedSeconds) {
    final segment = _activeSegment;
    if (segment == null) {
      throw StateError('No active segment. Call startSegment() first.');
    }

    final isPr = finalElapsedSeconds < _prSeconds;
    final avgSpeed = segment.distanceMeters > 0
        ? (segment.distanceMeters / finalElapsedSeconds) * 3.6
        : 0.0;

    final effort = SegmentEffort(
      id: '${segment.id}_${DateTime.now().millisecondsSinceEpoch}',
      segmentId: segment.id,
      elapsedSeconds: finalElapsedSeconds,
      avgSpeedKmH: avgSpeed,
      timestamp: DateTime.now(),
      isPr: isPr,
    );

    _activeSegment = null;
    return effort;
  }

  /// Returns the celebration/completion audio cue text.
  String getCompletionAudioCue(SegmentEffort effort) {
    final segment = _activeSegment;
    final name = segment?.name ?? 'segmen';
    if (effort.isPr) {
      return 'Selamat! Rekor Baru di $name!';
    }
    return 'Segmen $name selesai. Waktu: ${_formatDuration(effort.elapsedSeconds)}.';
  }

  // ── Progress calculation ───────────────────────────────────

  /// Estimates user progress (0.0 → 1.0) along the segment polyline using
  /// closest-point projection.
  double _calculateProgress(RouteCoordinate pos, Segment segment) {
    final coords = segment.polylineCoordinates;
    if (coords.length < 2) return 0.0;

    // Accumulate segment lengths and find the closest point.
    double totalLength = 0.0;
    double closestDist = double.infinity;
    int closestIdx = 0;

    final segLengths = <double>[];
    for (int i = 0; i < coords.length - 1; i++) {
      final d = _haversineMeters(
        coords[i].latitude,
        coords[i].longitude,
        coords[i + 1].latitude,
        coords[i + 1].longitude,
      );
      segLengths.add(d);
      totalLength += d;
    }

    // Find closest polyline vertex.
    for (int i = 0; i < coords.length; i++) {
      final d = _haversineMeters(
        pos.latitude,
        pos.longitude,
        coords[i].latitude,
        coords[i].longitude,
      );
      if (d < closestDist) {
        closestDist = d;
        closestIdx = i;
      }
    }

    if (totalLength == 0) return 0.0;

    // Sum lengths up to closest vertex.
    double traveled = 0.0;
    for (int i = 0; i < closestIdx && i < segLengths.length; i++) {
      traveled += segLengths[i];
    }

    return (traveled / totalLength).clamp(0.0, 1.0);
  }

  // ── Helpers ────────────────────────────────────────────────

  static const double _earthRadiusMeters = 6371000.0;

  static double _haversineMeters(
    double lat1, double lng1, double lat2, double lng2,
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

  static String _formatDuration(double seconds) {
    final m = (seconds / 60).floor();
    final s = (seconds % 60).floor();
    return '${m}m ${s}s';
  }
}
