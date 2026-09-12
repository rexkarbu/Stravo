import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/core/constants/enums.dart';
import 'package:stravo/features/heatmap/models/heatmap_models.dart';
import 'package:stravo/features/heatmap/services/personal_heatmap_engine.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

RouteCoordinate _c(double lat, double lng) =>
    RouteCoordinate(latitude: lat, longitude: lng);

void main() {
  group('HeatmapCategory filtering', () {
    test('all category matches every sport type', () {
      for (final sport in SportType.values) {
        expect(HeatmapCategory.all.matches(sport), isTrue);
      }
    });

    test('gravel category matches gravel cycling and mountain biking', () {
      expect(HeatmapCategory.gravel.matches(SportType.gravelCycling), isTrue);
      expect(HeatmapCategory.gravel.matches(SportType.mountainBiking), isTrue);
      expect(HeatmapCategory.gravel.matches(SportType.roadCycling), isFalse);
      expect(HeatmapCategory.gravel.matches(SportType.roadRunning), isFalse);
    });

    test('road category matches road cycling', () {
      expect(HeatmapCategory.road.matches(SportType.roadCycling), isTrue);
      expect(HeatmapCategory.road.matches(SportType.gravelCycling), isFalse);
      expect(HeatmapCategory.road.matches(SportType.roadRunning), isFalse);
    });

    test('run category matches running and walking/hiking', () {
      expect(HeatmapCategory.run.matches(SportType.roadRunning), isTrue);
      expect(HeatmapCategory.run.matches(SportType.trailRunning), isTrue);
      expect(HeatmapCategory.run.matches(SportType.hiking), isTrue);
      expect(HeatmapCategory.run.matches(SportType.walking), isTrue);
      expect(HeatmapCategory.run.matches(SportType.gravelCycling), isFalse);
    });
  });

  group('PersonalHeatmapEngine GeoJSON Generation', () {
    const engine = PersonalHeatmapEngine();

    final gravelTrack = HeatmapTrack(
      id: 'track_gravel_1',
      sportType: SportType.gravelCycling,
      coordinates: [
        _c(-7.1300, 107.8000),
        _c(-7.1250, 107.8050),
        _c(-7.1200, 107.8100),
      ],
    );

    final roadTrack = HeatmapTrack(
      id: 'track_road_1',
      sportType: SportType.roadCycling,
      coordinates: [
        _c(-6.9000, 107.6000),
        _c(-6.8900, 107.6100),
      ],
    );

    final runTrack = HeatmapTrack(
      id: 'track_run_1',
      sportType: SportType.roadRunning,
      coordinates: [
        _c(-6.9100, 107.6200),
        _c(-6.9050, 107.6250),
      ],
    );

    test('filters gravel tracks correctly', () {
      final geojson = engine.generateHeatmapGeoJson(
        [gravelTrack, roadTrack, runTrack],
        filter: HeatmapCategory.gravel,
      );

      final features = geojson['features'] as List;
      expect(features.length, equals(1));
      expect(features.first['properties']['id'], equals('track_gravel_1'));
    });

    test('filters run tracks correctly', () {
      final geojson = engine.generateHeatmapGeoJson(
        [gravelTrack, roadTrack, runTrack],
        filter: HeatmapCategory.run,
      );

      final features = geojson['features'] as List;
      expect(features.length, equals(1));
      expect(features.first['properties']['id'], equals('track_run_1'));
    });

    test('includes all tracks with HeatmapCategory.all', () {
      final geojson = engine.generateHeatmapGeoJson(
        [gravelTrack, roadTrack, runTrack],
        filter: HeatmapCategory.all,
      );

      final features = geojson['features'] as List;
      expect(features.length, equals(3));
    });

    test('produces valid RFC 7946 GeoJSON structure with [lng, lat]', () {
      final geojson = engine.generateHeatmapGeoJson([gravelTrack]);

      expect(geojson['type'], equals('FeatureCollection'));
      final features = geojson['features'] as List;
      expect(features, isNotEmpty);

      final feature = features.first as Map<String, dynamic>;
      expect(feature['type'], equals('Feature'));

      final geom = feature['geometry'] as Map<String, dynamic>;
      expect(geom['type'], equals('LineString'));

      final coords = geom['coordinates'] as List;
      expect(coords.length, equals(3));

      // Check RFC 7946 order: [longitude, latitude]
      final firstPoint = coords.first as List;
      expect(firstPoint[0], closeTo(107.8000, 0.0001)); // lng
      expect(firstPoint[1], closeTo(-7.1300, 0.0001));  // lat

      // Verify styling properties
      final props = feature['properties'] as Map<String, dynamic>;
      expect(props['color'], equals('#00FFA3'));
      expect(props['glowColor'], equals('#00FFA3'));
      expect(props['opacity'], isA<double>());
      expect(props['lineWidth'], equals(3.0));
      expect(props['blur'], equals(1.5));
    });

    test('handles empty track list gracefully', () {
      final geojson = engine.generateHeatmapGeoJson([]);
      expect(geojson['type'], equals('FeatureCollection'));
      expect((geojson['features'] as List), isEmpty);
    });

    test('handles track with invalid/NaN coordinates and skips single points', () {
      final badTrack = HeatmapTrack(
        id: 'bad_track',
        sportType: SportType.gravelCycling,
        coordinates: [
          _c(double.nan, 107.8000), // invalid
          _c(-7.1300, 107.8000),    // valid point 1
          _c(-7.1250, double.infinity), // invalid
          // Only 1 valid coordinate remaining -> LineString needs at least 2 -> skipped!
        ],
      );

      final geojson = engine.generateHeatmapGeoJson([badTrack]);
      final features = geojson['features'] as List;
      expect(features, isEmpty);
    });
  });
}
