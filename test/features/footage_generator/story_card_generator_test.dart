import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stravo/features/footage_generator/models/story_card_data.dart';
import 'package:stravo/features/footage_generator/widgets/story_card_widget.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Creates a minimal Kamojang-like route for testing.
List<RouteCoordinate> _sampleRoute() => [
      const RouteCoordinate(latitude: -7.1345, longitude: 107.7960, elevation: 1200, speed: 4.17),
      const RouteCoordinate(latitude: -7.1330, longitude: 107.7975, elevation: 1350, speed: 3.89),
      const RouteCoordinate(latitude: -7.1310, longitude: 107.7990, elevation: 1480, speed: 3.33),
      const RouteCoordinate(latitude: -7.1295, longitude: 107.8010, elevation: 1510, speed: 5.00),
      const RouteCoordinate(latitude: -7.1280, longitude: 107.8025, elevation: 1440, speed: 6.94),
    ];

StoryCardData _sampleData({
  StoryCardAspect aspect = StoryCardAspect.story9x16,
  List<RouteCoordinate>? coords,
}) =>
    StoryCardData(
      title: 'Kamojang Volcanic Ascent',
      date: DateTime(2026, 9, 13),
      sportType: 'Gravel Ride',
      distanceMeters: 42195.0,
      movingDuration: const Duration(hours: 2, minutes: 15, seconds: 30),
      elevationGainMeters: 1250.0,
      maxSpeedMs: 15.28,
      avgSpeedMs: 5.20,
      coordinates: coords ?? _sampleRoute(),
      aspectRatio: aspect,
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ==========================================================================
  // StoryCardData metric calculations & formatting
  // ==========================================================================
  group('StoryCardData - Metric Calculations', () {
    test('distanceKm converts meters to kilometers', () {
      final d = _sampleData();
      expect(d.distanceKm, closeTo(42.195, 0.001));
    });

    test('maxSpeedKmH converts m/s to km/h', () {
      final d = _sampleData();
      // 15.28 * 3.6 = 55.008
      expect(d.maxSpeedKmH, closeTo(55.008, 0.01));
    });

    test('avgSpeedKmH converts m/s to km/h', () {
      final d = _sampleData();
      // 5.20 * 3.6 = 18.72
      expect(d.avgSpeedKmH, closeTo(18.72, 0.01));
    });

    test('formattedDuration shows HH:mm:ss for durations >= 1 hour', () {
      final d = _sampleData();
      expect(d.formattedDuration, equals('02:15:30'));
    });

    test('formattedDuration shows mm:ss for durations < 1 hour', () {
      final d = StoryCardData(
        title: 'Quick Sprint',
        date: DateTime(2026, 1, 1),
        sportType: 'Trail Run',
        distanceMeters: 5000,
        movingDuration: const Duration(minutes: 23, seconds: 5),
        elevationGainMeters: 100,
        maxSpeedMs: 4.0,
        avgSpeedMs: 3.5,
        coordinates: _sampleRoute(),
      );
      expect(d.formattedDuration, equals('23:05'));
    });

    test('formattedDuration handles zero duration', () {
      final d = StoryCardData(
        title: 'Idle',
        date: DateTime(2026, 1, 1),
        sportType: 'Walk',
        distanceMeters: 0,
        movingDuration: Duration.zero,
        elevationGainMeters: 0,
        maxSpeedMs: 0,
        avgSpeedMs: 0,
        coordinates: const [],
      );
      expect(d.formattedDuration, equals('00:00'));
    });
  });

  // ==========================================================================
  // StoryCardAspect enum
  // ==========================================================================
  group('StoryCardAspect', () {
    test('story9x16 dimensions are 1080x1920', () {
      expect(StoryCardAspect.story9x16.width, 1080);
      expect(StoryCardAspect.story9x16.height, 1920);
    });

    test('feed1x1 dimensions are 1080x1080', () {
      expect(StoryCardAspect.feed1x1.width, 1080);
      expect(StoryCardAspect.feed1x1.height, 1080);
    });

    test('ratio is correct', () {
      expect(StoryCardAspect.story9x16.ratio, closeTo(0.5625, 0.0001));
      expect(StoryCardAspect.feed1x1.ratio, closeTo(1.0, 0.0001));
    });
  });

  // ==========================================================================
  // StoryCardWidget rendering (both aspects)
  // ==========================================================================
  group('StoryCardWidget - Rendering', () {
    testWidgets('renders story 9:16 without errors', (tester) async {
      final data = _sampleData(aspect: StoryCardAspect.story9x16);
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: RepaintBoundary(child: StoryCardWidget(data: data)),
          ),
        ),
      );

      // Verify key texts are present
      expect(find.text('STRAVO'), findsOneWidget);
      expect(find.text('PRO'), findsOneWidget);
      expect(find.text('Kamojang Volcanic Ascent'), findsOneWidget);
      expect(find.text('GRAVEL RIDE'), findsOneWidget);
    });

    testWidgets('renders feed 1:1 without errors', (tester) async {
      final data = _sampleData(aspect: StoryCardAspect.feed1x1);
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: RepaintBoundary(child: StoryCardWidget(data: data)),
          ),
        ),
      );

      expect(find.text('STRAVO'), findsOneWidget);
      expect(find.text('Kamojang Volcanic Ascent'), findsOneWidget);
    });

    testWidgets('stats grid shows formatted metrics', (tester) async {
      final data = _sampleData();
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: StoryCardWidget(data: data),
          ),
        ),
      );

      expect(find.text('42.2 km'), findsOneWidget);
      expect(find.text('02:15:30'), findsOneWidget);
      expect(find.text('1250 m'), findsOneWidget);
      expect(find.text('18.7 km/h'), findsOneWidget);
      expect(find.text('DISTANCE'), findsOneWidget);
      expect(find.text('TIME'), findsOneWidget);
      expect(find.text('ELEVATION'), findsOneWidget);
      expect(find.text('AVG SPEED'), findsOneWidget);
    });
  });

  // ==========================================================================
  // CustomPainter robustness (edge cases)
  // ==========================================================================
  group('CustomPainter - Edge Case Robustness', () {
    testWidgets('RoutePathPainter handles empty coordinates', (tester) async {
      final data = _sampleData(coords: const []);
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: StoryCardWidget(data: data),
          ),
        ),
      );
      // Should not throw
      expect(tester.takeException(), isNull);
    });

    testWidgets('RoutePathPainter handles single coordinate', (tester) async {
      final data = _sampleData(coords: const [
        RouteCoordinate(latitude: -7.13, longitude: 107.80, elevation: 1000),
      ]);
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: StoryCardWidget(data: data),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('ElevationProfilePainter handles flat elevation', (tester) async {
      final flatCoords = List.generate(
        10,
        (i) => RouteCoordinate(
          latitude: -7.13 + i * 0.001,
          longitude: 107.80 + i * 0.001,
          elevation: 500.0, // constant
          speed: 4.0,
        ),
      );
      final data = _sampleData(coords: flatCoords);
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: StoryCardWidget(data: data),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Painters handle coordinates with null elevation/speed', (tester) async {
      final nullCoords = [
        const RouteCoordinate(latitude: -7.13, longitude: 107.80),
        const RouteCoordinate(latitude: -7.12, longitude: 107.81),
        const RouteCoordinate(latitude: -7.11, longitude: 107.82),
      ];
      final data = _sampleData(coords: nullCoords);
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: StoryCardWidget(data: data),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Painters handle coordinates at identical positions', (tester) async {
      final sameCoords = List.generate(
        5,
        (_) => const RouteCoordinate(
          latitude: -7.13,
          longitude: 107.80,
          elevation: 500,
        ),
      );
      final data = _sampleData(coords: sameCoords);
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: StoryCardWidget(data: data),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
