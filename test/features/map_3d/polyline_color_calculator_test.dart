import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/core/constants/enums.dart';
import 'package:stravo/features/map_3d/domain/calculators/polyline_color_calculator.dart';
import 'package:stravo/features/map_3d/domain/models/colored_route_segment.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

void main() {
  group('RouteCoordinate tests', () {
    test('Speed conversion strictly converts m/s to km/h (factor 3.6)', () {
      const c1 = RouteCoordinate(latitude: -7.15, longitude: 107.78, speed: 0.0);
      expect(c1.speedKmPerHour, 0.0);

      const c2 = RouteCoordinate(latitude: -7.15, longitude: 107.78, speed: 10.0);
      expect(c2.speedKmPerHour, 36.0);

      const c3 = RouteCoordinate(latitude: -7.15, longitude: 107.78, speed: 25.0);
      expect(c3.speedKmPerHour, 90.0);
    });

    test('Speed conversion returns null for null, NaN, infinite, or negative values', () {
      const cNull = RouteCoordinate(latitude: -7.15, longitude: 107.78, speed: null);
      expect(cNull.speedKmPerHour, isNull);

      const cNan = RouteCoordinate(latitude: -7.15, longitude: 107.78, speed: double.nan);
      expect(cNan.speedKmPerHour, isNull);

      const cInf = RouteCoordinate(latitude: -7.15, longitude: 107.78, speed: double.infinity);
      expect(cInf.speedKmPerHour, isNull);

      const cNeg = RouteCoordinate(latitude: -7.15, longitude: 107.78, speed: -2.5);
      expect(cNeg.speedKmPerHour, isNull);
    });

    test('Coordinate validity checks geographic boundaries and finite numbers', () {
      // Valid coordinates around Kamojang
      const valid = RouteCoordinate(latitude: -7.15, longitude: 107.78);
      expect(valid.isValid, isTrue);

      // Equator / Prime Meridian boundaries
      expect(const RouteCoordinate(latitude: 90.0, longitude: 180.0).isValid, isTrue);
      expect(const RouteCoordinate(latitude: -90.0, longitude: -180.0).isValid, isTrue);

      // Invalid latitude
      expect(const RouteCoordinate(latitude: 90.001, longitude: 107.78).isValid, isFalse);
      expect(const RouteCoordinate(latitude: -90.001, longitude: 107.78).isValid, isFalse);

      // Invalid longitude
      expect(const RouteCoordinate(latitude: 0.0, longitude: 180.001).isValid, isFalse);
      expect(const RouteCoordinate(latitude: 0.0, longitude: -180.001).isValid, isFalse);

      // NaN or Infinite coordinates
      expect(const RouteCoordinate(latitude: double.nan, longitude: 107.78).isValid, isFalse);
      expect(const RouteCoordinate(latitude: -7.15, longitude: double.nan).isValid, isFalse);
      expect(const RouteCoordinate(latitude: double.infinity, longitude: 107.78).isValid, isFalse);
      expect(const RouteCoordinate(latitude: -7.15, longitude: double.negativeInfinity).isValid, isFalse);
    });
  });

  group('PolylineColorCalculator edge cases', () {
    test('Empty route returns empty segment list', () {
      final segments = PolylineColorCalculator.calculate(
        route: [],
        mode: PolylineColorMode.speedHeat,
      );
      expect(segments, isEmpty);
    });

    test('Single point route returns empty segment list', () {
      final segments = PolylineColorCalculator.calculate(
        route: [const RouteCoordinate(latitude: -7.15, longitude: 107.78)],
        mode: PolylineColorMode.speedHeat,
      );
      expect(segments, isEmpty);
    });

    test('Route with all invalid points returns empty segment list', () {
      final segments = PolylineColorCalculator.calculate(
        route: [
          const RouteCoordinate(latitude: 999.0, longitude: 107.78),
          const RouteCoordinate(latitude: double.nan, longitude: 107.78),
          const RouteCoordinate(latitude: -7.15, longitude: 999.0),
        ],
        mode: PolylineColorMode.speedHeat,
      );
      expect(segments, isEmpty);
    });

    test('Single valid point surrounded by invalid points cannot form a segment', () {
      final segments = PolylineColorCalculator.calculate(
        route: [
          const RouteCoordinate(latitude: 999.0, longitude: 107.78),
          const RouteCoordinate(latitude: -7.15, longitude: 107.78),
          const RouteCoordinate(latitude: double.nan, longitude: 107.78),
        ],
        mode: PolylineColorMode.speedHeat,
      );
      expect(segments, isEmpty);
    });

    test('Invalid coordinates split polyline into separate disjoint segments', () {
      // 2 valid points, 1 invalid point, 2 valid points
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, speed: 5.0),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, speed: 5.0),
        const RouteCoordinate(latitude: 999.0, longitude: 107.782), // INVALID!
        const RouteCoordinate(latitude: -7.153, longitude: 107.783, speed: 10.0),
        const RouteCoordinate(latitude: -7.154, longitude: 107.784, speed: 10.0),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.speedHeat,
      );

      // Must produce exactly 2 separate segments with NO bridging line across the invalid point
      expect(segments.length, 2);

      final seg1 = segments[0];
      expect(seg1.points.length, 2);
      expect(seg1.points.first.latitude, -7.150);
      expect(seg1.points.last.latitude, -7.151);

      final seg2 = segments[1];
      expect(seg2.points.length, 2);
      expect(seg2.points.first.latitude, -7.153);
      expect(seg2.points.last.latitude, -7.154);

      // Verify seg1 does NOT connect to seg2
      expect(seg1.points.last != seg2.points.first, isTrue);
    });
  });

  group('PolylineColorMode.speedHeat tests', () {
    test('Converts m/s to km/h and scales color from blue to red', () {
      // 0 m/s (0 km/h) -> 2.77 m/s (10 km/h) -> 8.33 m/s (30 km/h) -> 13.88 m/s (50 km/h)
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, speed: 0.0),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, speed: 2.777),
        const RouteCoordinate(latitude: -7.152, longitude: 107.782, speed: 8.333),
        const RouteCoordinate(latitude: -7.153, longitude: 107.783, speed: 13.888),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.speedHeat,
        mergeAdjacent: false,
      );

      expect(segments.length, 3);

      // First segment is lowest speed (blue tint)
      final firstColor = segments.first.color;
      final lastColor = segments.last.color;

      // Blue has high blue channel, low red channel
      expect(firstColor.b, greaterThan(firstColor.r));
      // Sprint red has high red channel, low blue channel
      expect(lastColor.r, greaterThan(lastColor.b));
    });

    test('Constant speed produces valid uniform color without division by zero or NaN', () {
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, speed: 5.0),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, speed: 5.0),
        const RouteCoordinate(latitude: -7.152, longitude: 107.782, speed: 5.0),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.speedHeat,
        mergeAdjacent: true,
      );

      expect(segments.length, 1);
      final seg = segments.first;
      expect(seg.points.length, 3);
      expect(seg.color, isNotNull);
      // Metric value in km/h is 5 * 3.6 = 18 km/h
      expect(seg.metricValue, closeTo(18.0, 0.01));
      expect(seg.hexColor.startsWith('#'), isTrue);
    });

    test('Route with NaN or null speeds does not crash and falls back safely', () {
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, speed: double.nan),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, speed: null),
        const RouteCoordinate(latitude: -7.152, longitude: 107.782, speed: double.nan),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.speedHeat,
      );

      expect(segments.length, 1);
      expect(segments.first.color, isNotNull);
    });
  });

  group('PolylineColorMode.elevationGradient tests', () {
    test('Scales color from low elevation (valley) to high elevation (peak)', () {
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1000.0),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, elevation: 1500.0),
        const RouteCoordinate(latitude: -7.152, longitude: 107.782, elevation: 2000.0),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.elevationGradient,
        mergeAdjacent: false,
      );

      expect(segments.length, 2);
      expect(segments[0].metricValue, 1250.0);
      expect(segments[1].metricValue, 1750.0);
      expect(segments[0].color != segments[1].color, isTrue);
    });

    test('Constant elevation handles max == min without NaN or crash', () {
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1450.0),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, elevation: 1450.0),
        const RouteCoordinate(latitude: -7.152, longitude: 107.782, elevation: 1450.0),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.elevationGradient,
        mergeAdjacent: true,
      );

      expect(segments.length, 1);
      expect(segments.first.metricValue, 1450.0);
      expect(segments.first.color, isNotNull);
    });

    test('Route with NaN or null elevations handles gracefully', () {
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: double.nan),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, elevation: null),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.elevationGradient,
      );

      expect(segments.length, 1);
      expect(segments.first.color, isNotNull);
    });
  });

  group('PolylineColorMode.surfaceType tests', () {
    test('Maps agreed surface types: Asphalt -> Green, Gravel -> Orange, Dirt -> Brown', () {
      expect(
        PolylineColorCalculator.getSurfaceColor(SurfaceType.asphalt),
        StravoColors.cyberGreen,
      );
      expect(
        PolylineColorCalculator.getSurfaceColor(SurfaceType.smoothGravel),
        StravoColors.orangePrimary,
      );
      expect(
        PolylineColorCalculator.getSurfaceColor(SurfaceType.roughGravel),
        const Color(0xFFD84315),
      );
      expect(
        PolylineColorCalculator.getSurfaceColor(SurfaceType.dirt),
        const Color(0xFF795548),
      );
      expect(
        PolylineColorCalculator.getSurfaceColor(SurfaceType.cobblestone),
        const Color(0xFF78909C),
      );
      expect(
        PolylineColorCalculator.getSurfaceColor(SurfaceType.unknown),
        StravoColors.textMuted,
      );
    });

    test('Merges adjacent points of identical surface type and transitions at boundaries', () {
      final route = [
        // 3 asphalt points
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, surfaceType: SurfaceType.asphalt),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, surfaceType: SurfaceType.asphalt),
        const RouteCoordinate(latitude: -7.152, longitude: 107.782, surfaceType: SurfaceType.asphalt),
        // 2 gravel points
        const RouteCoordinate(latitude: -7.153, longitude: 107.783, surfaceType: SurfaceType.smoothGravel),
        const RouteCoordinate(latitude: -7.154, longitude: 107.784, surfaceType: SurfaceType.smoothGravel),
      ];

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.surfaceType,
        mergeAdjacent: true,
      );

      // Should produce 2 merged segments
      expect(segments.length, 2);

      final asphaltSeg = segments[0];
      expect(asphaltSeg.surfaceType, SurfaceType.asphalt);
      expect(asphaltSeg.color, StravoColors.cyberGreen);
      expect(asphaltSeg.points.length, 3);

      final gravelSeg = segments[1];
      expect(gravelSeg.surfaceType, SurfaceType.smoothGravel);
      expect(gravelSeg.color, StravoColors.orangePrimary);
      expect(gravelSeg.points.length, 3); // includes transition point
    });

    test('Custom surface colors can be supplied and applied', () {
      final route = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, surfaceType: SurfaceType.asphalt),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781, surfaceType: SurfaceType.asphalt),
      ];

      final customColors = {
        ...PolylineColorCalculator.defaultSurfaceColors,
        SurfaceType.asphalt: Colors.purpleAccent,
      };

      final segments = PolylineColorCalculator.calculate(
        route: route,
        mode: PolylineColorMode.surfaceType,
        surfaceColors: customColors,
      );

      expect(segments.first.color, Colors.purpleAccent);
    });
  });

  group('ColoredRouteSegment helper tests', () {
    test('hexColor formats properly', () {
      final seg = ColoredRouteSegment(
        points: const [
          RouteCoordinate(latitude: -7.150, longitude: 107.780),
          RouteCoordinate(latitude: -7.151, longitude: 107.781),
        ],
        color: const Color(0xFF00FF9D),
        mode: PolylineColorMode.surfaceType,
      );
      expect(seg.hexColor, '#00FF9D');
    });

    test('toCoordinatesList outputs GeoJSON [lng, lat] and optional elevation', () {
      final seg = ColoredRouteSegment(
        points: const [
          RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1400.0),
          RouteCoordinate(latitude: -7.151, longitude: 107.781, elevation: 1420.0),
        ],
        color: Colors.blue,
        mode: PolylineColorMode.speedHeat,
      );

      final coords2D = seg.toCoordinatesList();
      expect(coords2D, [
        [107.780, -7.150],
        [107.781, -7.151],
      ]);

      final coords3D = seg.toCoordinatesList(includeElevation: true);
      expect(coords3D, [
        [107.780, -7.150, 1400.0],
        [107.781, -7.151, 1420.0],
      ]);
    });
  });
}
