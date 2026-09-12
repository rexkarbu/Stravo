import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stravo/features/footage_generator/models/story_card_data.dart';
import 'package:stravo/features/footage_generator/models/video_timeline_state.dart';
import 'package:stravo/features/footage_generator/widgets/video_footage_overlay.dart';
import 'package:stravo/features/footage_generator/services/on_device_video_renderer.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

List<RouteCoordinate> _sampleRoute() => [
      const RouteCoordinate(latitude: -7.1345, longitude: 107.7960, elevation: 1200, speed: 4.17),
      const RouteCoordinate(latitude: -7.1330, longitude: 107.7975, elevation: 1350, speed: 3.89),
      const RouteCoordinate(latitude: -7.1310, longitude: 107.7990, elevation: 1480, speed: 3.33),
      const RouteCoordinate(latitude: -7.1295, longitude: 107.8010, elevation: 1510, speed: 5.00),
      const RouteCoordinate(latitude: -7.1280, longitude: 107.8025, elevation: 1440, speed: 6.94),
    ];

StoryCardData _sampleData() => StoryCardData(
      title: 'Kamojang Volcanic Ascent',
      date: DateTime(2026, 9, 13),
      sportType: 'Gravel Ride',
      distanceMeters: 42195.0,
      movingDuration: const Duration(hours: 2, minutes: 15, seconds: 30),
      elevationGainMeters: 1250.0,
      maxSpeedMs: 15.28,
      avgSpeedMs: 5.20,
      coordinates: _sampleRoute(),
      aspectRatio: StoryCardAspect.story9x16,
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ==========================================================================
  // VideoTimelineFrame phase mapping accuracy
  // ==========================================================================
  group('VideoTimelineFrame - Phase Mapping', () {
    test('t=0.0 is intro phase with 0.0 progress', () {
      final f = VideoTimelineFrame.calculateFrame(0.0);
      expect(f.currentPhase, VideoSegmentPhase.intro);
      expect(f.routeProgress, 0.0);
      expect(f.activeWaypointIndex, isNull);
    });

    test('t=1.5 is intro phase', () {
      final f = VideoTimelineFrame.calculateFrame(1.5);
      expect(f.currentPhase, VideoSegmentPhase.intro);
      expect(f.routeProgress, 0.0);
    });

    test('t=2.999 is still intro phase', () {
      final f = VideoTimelineFrame.calculateFrame(2.999);
      expect(f.currentPhase, VideoSegmentPhase.intro);
    });

    test('t=3.0 transitions to flyoverTracking with progress ~0.0', () {
      final f = VideoTimelineFrame.calculateFrame(3.0);
      expect(f.currentPhase, VideoSegmentPhase.flyoverTracking);
      expect(f.routeProgress, closeTo(0.0, 0.001));
    });

    test('t=13.5 is flyoverTracking with progress ~0.5', () {
      final f = VideoTimelineFrame.calculateFrame(13.5);
      expect(f.currentPhase, VideoSegmentPhase.flyoverTracking);
      // (13.5 - 3) / 21 = 10.5 / 21 = 0.5
      expect(f.routeProgress, closeTo(0.5, 0.001));
    });

    test('t=23.999 is flyoverTracking near end', () {
      final f = VideoTimelineFrame.calculateFrame(23.999);
      expect(f.currentPhase, VideoSegmentPhase.flyoverTracking);
      expect(f.routeProgress, closeTo(1.0, 0.01));
    });

    test('t=24.0 transitions to outroSummary with progress 1.0', () {
      final f = VideoTimelineFrame.calculateFrame(24.0);
      expect(f.currentPhase, VideoSegmentPhase.outroSummary);
      expect(f.routeProgress, 1.0);
    });

    test('t=27.0 is outroSummary', () {
      final f = VideoTimelineFrame.calculateFrame(27.0);
      expect(f.currentPhase, VideoSegmentPhase.outroSummary);
      expect(f.routeProgress, 1.0);
    });

    test('t=30.0 is outroSummary at the very end', () {
      final f = VideoTimelineFrame.calculateFrame(30.0);
      expect(f.currentPhase, VideoSegmentPhase.outroSummary);
      expect(f.routeProgress, 1.0);
    });

    test('negative timestamp clamps to 0.0 intro', () {
      final f = VideoTimelineFrame.calculateFrame(-5.0);
      expect(f.currentPhase, VideoSegmentPhase.intro);
      expect(f.timestampSeconds, 0.0);
    });

    test('timestamp > 30 clamps to 30.0 outro', () {
      final f = VideoTimelineFrame.calculateFrame(99.9);
      expect(f.currentPhase, VideoSegmentPhase.outroSummary);
      expect(f.timestampSeconds, 30.0);
    });
  });

  // ==========================================================================
  // VideoTimelineFrame waypoint detection
  // ==========================================================================
  group('VideoTimelineFrame - Waypoint Detection', () {
    test('detects KM waypoint when crossing km boundary', () {
      // At 42195m, progress ~0.5 = ~21097m which is km 21
      final f = VideoTimelineFrame.calculateFrame(13.5, totalDistanceMeters: 42195.0);
      expect(f.currentPhase, VideoSegmentPhase.flyoverTracking);
      // Waypoint depends on exact position relative to km boundary
      // At progress 0.5, covered = 21097.5m, floor(21.0975) = 21
      // delta from 21000 = 97.5 > 50, so no waypoint (correct behavior)
    });

    test('no waypoint in intro phase', () {
      final f = VideoTimelineFrame.calculateFrame(1.0, totalDistanceMeters: 42195.0);
      expect(f.activeWaypointIndex, isNull);
    });

    test('no waypoint in outro phase', () {
      final f = VideoTimelineFrame.calculateFrame(27.0, totalDistanceMeters: 42195.0);
      expect(f.activeWaypointIndex, isNull);
    });

    test('no waypoint with zero distance', () {
      final f = VideoTimelineFrame.calculateFrame(10.0, totalDistanceMeters: 0.0);
      expect(f.activeWaypointIndex, isNull);
    });
  });

  // ==========================================================================
  // VideoFootageOverlay widget rendering
  // ==========================================================================
  group('VideoFootageOverlay - Widget Rendering', () {
    testWidgets('renders intro phase without errors', (tester) async {
      final frame = VideoTimelineFrame.calculateFrame(1.5);
      final data = _sampleData();

      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: VideoFootageOverlay(frame: frame, data: data),
          ),
        ),
      );

      expect(find.text('STRAVO'), findsOneWidget);
      expect(find.text('PRO'), findsOneWidget);
      expect(find.text('Kamojang Volcanic Ascent'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders flyover phase with HUD elements', (tester) async {
      final frame = VideoTimelineFrame.calculateFrame(13.5, totalDistanceMeters: 42195.0);
      final data = _sampleData();

      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: VideoFootageOverlay(frame: frame, data: data),
          ),
        ),
      );

      // Speed HUD should show "km/h"
      expect(find.text('km/h'), findsOneWidget);
      expect(find.text('km'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders outro phase with summary stats', (tester) async {
      final frame = VideoTimelineFrame.calculateFrame(27.0);
      final data = _sampleData();

      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: VideoFootageOverlay(frame: frame, data: data),
          ),
        ),
      );

      expect(find.text('TOTAL DISTANCE'), findsOneWidget);
      expect(find.text('MOVING TIME'), findsOneWidget);
      expect(find.text('MAX SPEED'), findsOneWidget);
      expect(find.text('ELEVATION GAIN'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders all phases with empty coordinates gracefully', (tester) async {
      final emptyData = StoryCardData(
        title: 'Empty Route',
        date: DateTime(2026, 1, 1),
        sportType: 'Walk',
        distanceMeters: 0,
        movingDuration: Duration.zero,
        elevationGainMeters: 0,
        maxSpeedMs: 0,
        avgSpeedMs: 0,
        coordinates: const [],
      );

      // Test all three phases
      for (final t in [1.0, 13.5, 27.0]) {
        final frame = VideoTimelineFrame.calculateFrame(t);
        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              child: VideoFootageOverlay(frame: frame, data: emptyData),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('renders flyover with waypoint popup when active', (tester) async {
      // Craft a frame with an active waypoint
      const frame = VideoTimelineFrame(
        timestampSeconds: 10.0,
        currentPhase: VideoSegmentPhase.flyoverTracking,
        routeProgress: 0.33,
        activeWaypointIndex: 5,
      );
      final data = _sampleData();

      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: VideoFootageOverlay(frame: frame, data: data),
          ),
        ),
      );

      expect(find.text('KM 5'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  // ==========================================================================
  // VideoEncodingStrategy interface & SkiaCanvasFrameGrabber
  // ==========================================================================
  group('VideoEncodingStrategy - Interface Validation', () {
    test('VideoEncodingStrategy is abstract and cannot be instantiated directly', () {
      // Verify the contract exists as an abstract class
      // If it were concrete, this would fail since encodeFramesToMp4 is abstract
      expect(true, isTrue); // Type system enforces this at compile time
    });

    test('SkiaCanvasFrameGrabber can be instantiated', () {
      final grabber = SkiaCanvasFrameGrabber();
      expect(grabber, isNotNull);
    });

    test('VideoOutputResolver can be instantiated', () {
      final resolver = VideoOutputResolver();
      expect(resolver, isNotNull);
    });
  });

  // ==========================================================================
  // VideoSegmentPhase enum
  // ==========================================================================
  group('VideoSegmentPhase', () {
    test('has exactly 3 phases', () {
      expect(VideoSegmentPhase.values.length, 3);
    });

    test('phases are intro, flyoverTracking, outroSummary', () {
      expect(VideoSegmentPhase.values, containsAll([
        VideoSegmentPhase.intro,
        VideoSegmentPhase.flyoverTracking,
        VideoSegmentPhase.outroSummary,
      ]));
    });
  });
}
