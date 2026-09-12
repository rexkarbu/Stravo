import 'package:flutter/foundation.dart';
import 'package:stravo/core/constants/enums.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

// ─── Geo Bounding Box ────────────────────────────────────────

/// Axis-aligned bounding box for O(1) spatial pre-filtering.
@immutable
class GeoBoundingBox {
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;

  const GeoBoundingBox({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
  });

  /// Creates a bounding box from a list of coordinates with optional padding.
  factory GeoBoundingBox.fromCoordinates(
    List<RouteCoordinate> coords, {
    double paddingDegrees = 0.001,
  }) {
    assert(coords.isNotEmpty, 'coords must not be empty');
    double mnLat = coords.first.latitude;
    double mxLat = coords.first.latitude;
    double mnLng = coords.first.longitude;
    double mxLng = coords.first.longitude;
    for (final c in coords) {
      if (c.latitude < mnLat) mnLat = c.latitude;
      if (c.latitude > mxLat) mxLat = c.latitude;
      if (c.longitude < mnLng) mnLng = c.longitude;
      if (c.longitude > mxLng) mxLng = c.longitude;
    }
    return GeoBoundingBox(
      minLat: mnLat - paddingDegrees,
      maxLat: mxLat + paddingDegrees,
      minLng: mnLng - paddingDegrees,
      maxLng: mxLng + paddingDegrees,
    );
  }

  /// O(1) containment check — no trigonometry needed.
  bool contains(RouteCoordinate pos) =>
      pos.latitude >= minLat &&
      pos.latitude <= maxLat &&
      pos.longitude >= minLng &&
      pos.longitude <= maxLng;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoBoundingBox &&
          minLat == other.minLat &&
          maxLat == other.maxLat &&
          minLng == other.minLng &&
          maxLng == other.maxLng;

  @override
  int get hashCode => Object.hash(minLat, maxLat, minLng, maxLng);
}

// ─── Segment ─────────────────────────────────────────────────

/// A named GPS segment (e.g. a climb, sprint, or scenic stretch).
@immutable
class Segment {
  final String id;
  final String name;
  final SportType sportType;
  final RouteCoordinate startPoint;
  final RouteCoordinate finishPoint;
  final double distanceMeters;
  final double elevationGainMeters;
  final GeoBoundingBox boundingBox;
  final List<RouteCoordinate> polylineCoordinates;

  /// Personal-record effort time in seconds (null if never attempted).
  final double? prEffortSeconds;

  const Segment({
    required this.id,
    required this.name,
    required this.sportType,
    required this.startPoint,
    required this.finishPoint,
    required this.distanceMeters,
    required this.elevationGainMeters,
    required this.boundingBox,
    required this.polylineCoordinates,
    this.prEffortSeconds,
  });

  Segment copyWith({double? prEffortSeconds}) => Segment(
        id: id,
        name: name,
        sportType: sportType,
        startPoint: startPoint,
        finishPoint: finishPoint,
        distanceMeters: distanceMeters,
        elevationGainMeters: elevationGainMeters,
        boundingBox: boundingBox,
        polylineCoordinates: polylineCoordinates,
        prEffortSeconds: prEffortSeconds ?? this.prEffortSeconds,
      );
}

// ─── Segment Effort ──────────────────────────────────────────

/// A single recorded attempt on a segment.
@immutable
class SegmentEffort {
  final String id;
  final String segmentId;
  final double elapsedSeconds;
  final double avgSpeedKmH;
  final DateTime timestamp;
  final bool isPr;

  const SegmentEffort({
    required this.id,
    required this.segmentId,
    required this.elapsedSeconds,
    required this.avgSpeedKmH,
    required this.timestamp,
    required this.isPr,
  });
}

// ─── Tracking Status ─────────────────────────────────────────

/// Lifecycle state of segment tracking.
enum SegmentTrackingStatus { idle, approaching, active, completed, abandoned }

// ─── Ghost Pacer Snapshot ────────────────────────────────────

/// Real-time comparison snapshot between user and ghost pacer.
@immutable
class GhostPacerSnapshot {
  final String segmentName;

  /// Progress along the segment polyline (0.0 → 1.0).
  final double progress;
  final double userElapsedSeconds;
  final double pacerElapsedSeconds;

  /// Negative = ahead of pacer, positive = behind.
  final double timeDeltaSeconds;
  final bool isAhead;
  final String hudMessage;

  /// Optional audio cue text for TTS.
  final String? audioCue;

  const GhostPacerSnapshot({
    required this.segmentName,
    required this.progress,
    required this.userElapsedSeconds,
    required this.pacerElapsedSeconds,
    required this.timeDeltaSeconds,
    required this.isAhead,
    required this.hudMessage,
    this.audioCue,
  });
}
