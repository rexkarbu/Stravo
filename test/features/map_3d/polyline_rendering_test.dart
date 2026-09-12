import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/core/constants/enums.dart';
import 'package:stravo/features/map_3d/domain/models/colored_route_segment.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';
import 'package:stravo/features/map_3d/widgets/terrain_map_webview.dart';

void main() {
  group('Polyline Rendering - GeoJSON FeatureCollection Serialization Tests', () {
    test('Empty segments list produces valid empty FeatureCollection', () {
      final geoJsonStr = TerrainMapWebViewState.segmentsToGeoJson([]);
      final geoJson = jsonDecode(geoJsonStr) as Map<String, dynamic>;

      expect(geoJson['type'], 'FeatureCollection');
      expect(geoJson['features'], isEmpty);
    });

    test('Segments are properly serialized to RFC 7946 LineString features with color property', () {
      final segments = [
        ColoredRouteSegment(
          points: const [
            RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1400.0),
            RouteCoordinate(latitude: -7.151, longitude: 107.781, elevation: 1420.0),
          ],
          color: const Color(0xFF00FF9D), // Cyber green
          mode: PolylineColorMode.surfaceType,
          surfaceType: SurfaceType.asphalt,
        ),
        ColoredRouteSegment(
          points: const [
            RouteCoordinate(latitude: -7.151, longitude: 107.781, elevation: 1420.0),
            RouteCoordinate(latitude: -7.152, longitude: 107.782, elevation: 1450.0),
          ],
          color: const Color(0xFFFF5500), // Stravo orange
          mode: PolylineColorMode.surfaceType,
          surfaceType: SurfaceType.smoothGravel,
        ),
      ];

      final geoJsonStr = TerrainMapWebViewState.segmentsToGeoJson(segments);
      final geoJson = jsonDecode(geoJsonStr) as Map<String, dynamic>;

      expect(geoJson['type'], 'FeatureCollection');
      final features = geoJson['features'] as List<dynamic>;
      expect(features.length, 2);

      // Feature 0
      final f0 = features[0] as Map<String, dynamic>;
      expect(f0['type'], 'Feature');
      final geom0 = f0['geometry'] as Map<String, dynamic>;
      expect(geom0['type'], 'LineString');
      final coords0 = geom0['coordinates'] as List<dynamic>;
      expect(coords0.length, 2);
      // RFC 7946: [longitude, latitude]
      expect(coords0[0], [107.780, -7.150]);
      expect(coords0[1], [107.781, -7.151]);

      final props0 = f0['properties'] as Map<String, dynamic>;
      expect(props0['color'], '#00FF9D');
      expect(props0['surface'], 'asphalt');

      // Feature 1
      final f1 = features[1] as Map<String, dynamic>;
      expect(f1['type'], 'Feature');
      final geom1 = f1['geometry'] as Map<String, dynamic>;
      expect(geom1['type'], 'LineString');
      final coords1 = geom1['coordinates'] as List<dynamic>;
      expect(coords1.length, 2);
      expect(coords1[0], [107.781, -7.151]);
      expect(coords1[1], [107.782, -7.152]);

      final props1 = f1['properties'] as Map<String, dynamic>;
      expect(props1['color'], '#FF5500');
      expect(props1['surface'], 'smoothGravel');
    });

    test('Metric value is included in GeoJSON properties when present', () {
      final segment = ColoredRouteSegment(
        points: const [
          RouteCoordinate(latitude: -7.150, longitude: 107.780),
          RouteCoordinate(latitude: -7.151, longitude: 107.781),
        ],
        color: const Color(0xFFFFD600),
        mode: PolylineColorMode.speedHeat,
        metricValue: 36.5,
      );

      final geoJsonStr = TerrainMapWebViewState.segmentsToGeoJson([segment]);
      final geoJson = jsonDecode(geoJsonStr) as Map<String, dynamic>;
      final feature = (geoJson['features'] as List<dynamic>).first as Map<String, dynamic>;

      expect(feature['properties']['metric'], 36.5);
      expect(feature['properties']['color'], '#FFD600');
    });
  });
}
