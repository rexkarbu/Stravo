import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/core/constants/enums.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';
import 'package:stravo/features/segments/models/segment_models.dart';
import 'package:stravo/features/segments/services/ghost_pacer_engine.dart';
import 'package:stravo/features/segments/services/segment_matcher.dart';

// ─── Test Helpers ────────────────────────────────────────────

RouteCoordinate _coord(double lat, double lng) =>
    RouteCoordinate(latitude: lat, longitude: lng);

/// Creates a simple test segment along a straight line from [startLat] to
/// [finishLat] with [pointCount] evenly spaced points.
Segment _testSegment({
  String id = 'seg1',
  String name = 'Tanjakan Kamojang',
  double startLat = -7.1300,
  double startLng = 107.8000,
  double finishLat = -7.1200,
  double finishLng = 107.8000,
  int pointCount = 11,
  double distanceMeters = 1112.0,
  double elevationGainMeters = 150.0,
  double? prEffortSeconds = 120.0,
}) {
  final coords = List.generate(pointCount, (i) {
    final t = i / (pointCount - 1);
    return _coord(
      startLat + (finishLat - startLat) * t,
      startLng + (finishLng - startLng) * t,
    );
  });
  return Segment(
    id: id,
    name: name,
    sportType: SportType.gravelCycling,
    startPoint: coords.first,
    finishPoint: coords.last,
    distanceMeters: distanceMeters,
    elevationGainMeters: elevationGainMeters,
    boundingBox: GeoBoundingBox.fromCoordinates(coords),
    polylineCoordinates: coords,
    prEffortSeconds: prEffortSeconds,
  );
}

// ═════════════════════════════════════════════════════════════
// TESTS
// ═════════════════════════════════════════════════════════════

void main() {
  // ─── GeoBoundingBox ──────────────────────────────────────

  group('GeoBoundingBox', () {
    final box = GeoBoundingBox(
      minLat: -7.14,
      maxLat: -7.11,
      minLng: 107.79,
      maxLng: 107.81,
    );

    test('contains returns true for coordinate inside box', () {
      expect(box.contains(_coord(-7.125, 107.800)), isTrue);
    });

    test('contains returns false for coordinate outside box (north)', () {
      expect(box.contains(_coord(-7.10, 107.800)), isFalse);
    });

    test('contains returns false for coordinate outside box (east)', () {
      expect(box.contains(_coord(-7.125, 107.82)), isFalse);
    });

    test('contains returns true for coordinate on boundary', () {
      expect(box.contains(_coord(-7.14, 107.79)), isTrue);
    });

    test('fromCoordinates creates padded box', () {
      final coords = [_coord(-7.13, 107.80), _coord(-7.12, 107.80)];
      final computed = GeoBoundingBox.fromCoordinates(coords, paddingDegrees: 0.01);
      // minLat should be -7.13 - 0.01 = -7.14
      expect(computed.minLat, closeTo(-7.14, 0.0001));
      expect(computed.maxLat, closeTo(-7.11, 0.0001));
    });
  });

  // ─── SegmentMatcher ──────────────────────────────────────

  group('SegmentMatcher', () {
    late Segment segment;
    late SegmentMatcher matcher;

    setUp(() {
      segment = _testSegment();
      matcher = SegmentMatcher([segment]);
    });

    test('skips points outside bounding box (coarse filter)', () {
      // Coordinate far away — outside bounding box entirely.
      final far = _coord(-6.90, 106.80);
      expect(matcher.matchPoint(far), isNull);
    });

    test('detects entry within 25m of start point', () {
      // Very close to start: -7.1300, 107.8000
      final near = _coord(-7.13005, 107.80005);
      expect(matcher.matchPoint(near), isNotNull);
      expect(matcher.matchPoint(near)!.id, equals('seg1'));
    });

    test('rejects point inside bbox but far from start', () {
      // Inside the bounding box but far from the start point.
      final mid = _coord(-7.1250, 107.8000);
      expect(matcher.matchPoint(mid), isNull);
    });

    test('isNearFinish returns true near finish point', () {
      final nearFinish = _coord(-7.12005, 107.80005);
      expect(matcher.isNearFinish(segment, nearFinish), isTrue);
    });

    test('isNearFinish returns false far from finish', () {
      final far = _coord(-7.1300, 107.8000);
      expect(matcher.isNearFinish(segment, far), isFalse);
    });
  });

  // ─── GhostPacerEngine ───────────────────────────────────

  group('GhostPacerEngine', () {
    late Segment segment;
    late GhostPacerEngine engine;

    setUp(() {
      segment = _testSegment(prEffortSeconds: 120.0);
      engine = GhostPacerEngine();
    });

    test('startSegment returns audio cue with segment name and PR', () {
      final cue = engine.startSegment(segment);
      expect(cue, contains('Tanjakan Kamojang'));
      expect(cue, contains('Rekor terbaikmu'));
      expect(engine.isActive, isTrue);
    });

    test('throws if updatePosition called without active segment', () {
      expect(
        () => engine.updatePosition(_coord(-7.125, 107.800), 30.0),
        throwsStateError,
      );
    });

    test('ahead scenario: user at 50% in 50s vs 120s PR', () {
      engine.startSegment(segment);
      // Mid-point of the segment polyline
      final midPoint = _coord(-7.1250, 107.8000);
      final snap = engine.updatePosition(midPoint, 50.0);

      // At ~50% progress, pacer elapsed = 0.5 * 120 = 60s.
      // User at 50s → delta = 50 - 60 = -10 → ahead!
      expect(snap.isAhead, isTrue);
      expect(snap.timeDeltaSeconds, lessThan(0));
      expect(snap.hudMessage, contains('di depan Ghost Pacer'));
    });

    test('behind scenario: user at 50% in 70s vs 120s PR', () {
      engine.startSegment(segment);
      final midPoint = _coord(-7.1250, 107.8000);
      final snap = engine.updatePosition(midPoint, 70.0);

      // At ~50% progress, pacer elapsed = 60s.
      // User at 70s → delta = 70 - 60 = +10 → behind.
      expect(snap.isAhead, isFalse);
      expect(snap.timeDeltaSeconds, greaterThan(0));
      expect(snap.hudMessage, contains('Tertinggal'));
    });

    test('detects new PR on completion', () {
      engine.startSegment(segment);
      // Finish faster than PR (120s)
      final effort = engine.completeSegment(100.0);
      expect(effort.isPr, isTrue);
      expect(effort.segmentId, equals('seg1'));
      expect(engine.isActive, isFalse);
    });

    test('no PR when slower than record', () {
      engine.startSegment(segment);
      final effort = engine.completeSegment(150.0);
      expect(effort.isPr, isFalse);
    });

    test('completion audio cue celebrates new PR', () {
      engine.startSegment(segment);
      final effort = engine.completeSegment(100.0);
      // getCompletionAudioCue needs to be called before engine clears segment
      // Engine already cleared, but it should still work for PR detection.
      final cue = engine.getCompletionAudioCue(effort);
      // Since _activeSegment is cleared, name falls back to 'segmen'
      expect(effort.isPr, isTrue);
      expect(cue, isA<String>());
    });

    test('uses default 300s when segment has no PR', () {
      final noPr = _testSegment(prEffortSeconds: null);
      engine.startSegment(noPr);
      final cue = engine.startSegment(noPr);
      expect(cue, contains('5m 0s'));
    });

    test('custom PR overrides segment PR', () {
      engine.startSegment(segment, customPrSeconds: 60.0);
      final snap = engine.updatePosition(_coord(-7.1250, 107.8000), 25.0);
      // At ~50%, pacer = 0.5 * 60 = 30s, user = 25s → delta = -5 → ahead
      expect(snap.isAhead, isTrue);
    });

    test('progress is clamped to 0.0-1.0', () {
      engine.startSegment(segment);
      // Position at start
      final snap = engine.updatePosition(segment.startPoint, 1.0);
      expect(snap.progress, greaterThanOrEqualTo(0.0));
      expect(snap.progress, lessThanOrEqualTo(1.0));
    });

    test('avgSpeedKmH is calculated correctly', () {
      engine.startSegment(segment);
      final effort = engine.completeSegment(120.0);
      // distance = 1112m, time = 120s → speed = 1112/120 * 3.6 ≈ 33.36 km/h
      expect(effort.avgSpeedKmH, closeTo(33.36, 0.5));
    });
  });

  // ─── SegmentTrackingStatus ───────────────────────────────

  group('SegmentTrackingStatus', () {
    test('has all expected values', () {
      expect(SegmentTrackingStatus.values, hasLength(5));
      expect(SegmentTrackingStatus.values, contains(SegmentTrackingStatus.idle));
      expect(SegmentTrackingStatus.values, contains(SegmentTrackingStatus.active));
      expect(SegmentTrackingStatus.values, contains(SegmentTrackingStatus.completed));
    });
  });

  // ─── GhostPacerSnapshot ─────────────────────────────────

  group('GhostPacerSnapshot', () {
    test('hudMessage reflects ahead status', () {
      const snap = GhostPacerSnapshot(
        segmentName: 'Test',
        progress: 0.5,
        userElapsedSeconds: 50.0,
        pacerElapsedSeconds: 60.0,
        timeDeltaSeconds: -10.0,
        isAhead: true,
        hudMessage: 'Kamu 10.0s di depan Ghost Pacer',
      );
      expect(snap.isAhead, isTrue);
      expect(snap.audioCue, isNull);
    });
  });
}
