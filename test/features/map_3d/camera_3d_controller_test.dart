import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/features/map_3d/controllers/camera_3d_controller.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

void main() {
  group('Camera3DController - Progress Interpolation Tests', () {
    // 4-point straight eastbound route around Kamojang
    final route = [
      const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1400.0),
      const RouteCoordinate(latitude: -7.150, longitude: 107.785, elevation: 1450.0),
      const RouteCoordinate(latitude: -7.150, longitude: 107.790, elevation: 1500.0),
      const RouteCoordinate(latitude: -7.150, longitude: 107.795, elevation: 1550.0),
    ];

    late Camera3DController controller;

    setUp(() {
      controller = Camera3DController(route: route);
    });

    test('Progress 0.0 matches start coordinate', () {
      final state = controller.getStateAtProgress(0.0);
      expect(state.progress, 0.0);
      expect(state.latitude, closeTo(-7.150, 0.0001));
      expect(state.longitude, closeTo(107.780, 0.0001));
      expect(state.elevation, closeTo(1400.0, 0.1));
    });

    test('Progress 1.0 matches finish coordinate', () {
      final state = controller.getStateAtProgress(1.0);
      expect(state.progress, 1.0);
      expect(state.latitude, closeTo(-7.150, 0.0001));
      expect(state.longitude, closeTo(107.795, 0.0001));
      expect(state.elevation, closeTo(1550.0, 0.1));
    });

    test('Progress 0.5 smoothly interpolates midway along the route', () {
      final state = controller.getStateAtProgress(0.5);
      expect(state.progress, 0.5);
      // Midway between 107.780 and 107.795 is ~107.7875
      expect(state.longitude, closeTo(107.7875, 0.002));
      expect(state.elevation, closeTo(1475.0, 20.0));
      expect(state.bearing, closeTo(90.0, 5.0)); // Heading East
    });

    test('toJson serializes state correctly for MapLibre bridge', () {
      final state = controller.getStateAtProgress(0.0);
      final json = state.toJson();
      expect(json['center'], [closeTo(107.780, 0.0001), closeTo(-7.150, 0.0001)]);
      expect(json['bearing'], closeTo(90.0, 5.0));
      expect(json['pitch'], inInclusiveRange(45.0, 65.0));
      expect(json['zoom'], inInclusiveRange(13.0, 17.5));
      expect(json['progress'], 0.0);
    });
  });

  group('Camera3DController - Bearing Continuity & North-Crossing Tests', () {
    test('shortestAngleDelta calculates correct shortest rotation across North', () {
      // 350° to 10° should be +20° (clockwise), NOT -340°
      expect(Camera3DController.shortestAngleDelta(350.0, 10.0), closeTo(20.0, 0.01));

      // 10° to 350° should be -20° (counter-clockwise)
      expect(Camera3DController.shortestAngleDelta(10.0, 350.0), closeTo(-20.0, 0.01));

      // 10° to 30° should be +20°
      expect(Camera3DController.shortestAngleDelta(10.0, 30.0), closeTo(20.0, 0.01));

      // Opposite angles (180°)
      expect(Camera3DController.shortestAngleDelta(0.0, 180.0).abs(), closeTo(180.0, 0.01));
    });

    test('interpolateBearing smoothly rotates across North without spinning 360° backwards', () {
      // Halfway between 350° and 10° must be 0° / 360° (due North)
      final mid = Camera3DController.interpolateBearing(350.0, 10.0, 0.5);
      expect(mid, closeTo(0.0, 0.01));

      // Quarter way: 350 + 5 = 355°
      final quarter = Camera3DController.interpolateBearing(350.0, 10.0, 0.25);
      expect(quarter, closeTo(355.0, 0.01));

      // Three-quarter way: 350 + 15 = 5°
      final threeQuarter = Camera3DController.interpolateBearing(350.0, 10.0, 0.75);
      expect(threeQuarter, closeTo(5.0, 0.01));
    });

    test('Bearing follows tangent vector along route crossing North', () {
      // Route starting slightly NNW (bearing ~350°) and bending towards NNE (bearing ~10°)
      final northBendingRoute = [
        const RouteCoordinate(latitude: 0.000, longitude: 0.000),
        const RouteCoordinate(latitude: 0.010, longitude: -0.001), // heading ~354°
        const RouteCoordinate(latitude: 0.020, longitude: 0.000),  // heading ~0°
        const RouteCoordinate(latitude: 0.030, longitude: 0.001),  // heading ~6°
      ];

      final ctrl = Camera3DController(route: northBendingRoute);
      final s0 = ctrl.getStateAtProgress(0.1);
      final sMid = ctrl.getStateAtProgress(0.5);
      final sEnd = ctrl.getStateAtProgress(0.9);

      // Bearing at start should be near 350°-360°
      expect(s0.bearing, anyOf(greaterThan(340.0), lessThan(5.0)));
      // Bearing near mid has smoothly crossed North into NNE (0° to 10°)
      expect(sMid.bearing, inInclusiveRange(0.0, 10.0));
      // Bearing at end should be NNE (1° to 15°)
      expect(sEnd.bearing, inInclusiveRange(0.0, 20.0));
    });
  });

  group('Camera3DController - Dynamic Camera Choreography (Climb vs Descent vs Summit)', () {
    test('Steep climb tilts down (higher pitch) and zooms in compared to downhill descent', () {
      // Steep uphill route (+200m in ~500m distance = ~40% steep slope)
      final uphillRoute = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1000.0),
        const RouteCoordinate(latitude: -7.150, longitude: 107.782, elevation: 1100.0),
        const RouteCoordinate(latitude: -7.150, longitude: 107.784, elevation: 1200.0),
      ];

      // Downhill route (-200m in ~500m distance)
      final downhillRoute = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1200.0),
        const RouteCoordinate(latitude: -7.150, longitude: 107.782, elevation: 1100.0),
        const RouteCoordinate(latitude: -7.150, longitude: 107.784, elevation: 1000.0),
      ];

      final uphillCtrl = Camera3DController(route: uphillRoute);
      final downhillCtrl = Camera3DController(route: downhillRoute);

      final uphillMid = uphillCtrl.getStateAtProgress(0.5);
      final downhillMid = downhillCtrl.getStateAtProgress(0.5);

      // Pitch on uphill must be higher (tilted down to terrain) than on downhill
      expect(uphillMid.pitch, greaterThan(downhillMid.pitch));
      expect(uphillMid.pitch, greaterThanOrEqualTo(55.0));
      expect(downhillMid.pitch, lessThanOrEqualTo(52.0));

      // Zoom on uphill must be tighter (zoomed in) than downhill
      expect(uphillMid.zoom, greaterThan(downhillMid.zoom));
    });

    test('Summit / high elevation peak zooms out for sweeping landscape panorama', () {
      // Route climbing to a mountain peak and descending
      final mountainRoute = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1000.0), // Valley base
        const RouteCoordinate(latitude: -7.150, longitude: 107.785, elevation: 1800.0), // Near peak
        const RouteCoordinate(latitude: -7.150, longitude: 107.790, elevation: 2000.0), // Summit peak
        const RouteCoordinate(latitude: -7.150, longitude: 107.795, elevation: 1800.0), // Descending
      ];

      final ctrl = Camera3DController(route: mountainRoute);

      final valleyState = ctrl.getStateAtProgress(0.0);
      final summitState = ctrl.getStateAtProgress(0.66); // at summit peak

      // At summit peak (highest elevation), zoom should be zoomed out relative to base climbing zoom
      expect(summitState.elevation, greaterThan(1800.0));
      expect(summitState.zoom, lessThan(valleyState.zoom));
    });

    test('Pitch stays strictly clamped within 45° to 65° range', () {
      final extremeRoute = [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 0.0),
        const RouteCoordinate(latitude: -7.150, longitude: 107.781, elevation: 1000.0), // Extreme cliff
        const RouteCoordinate(latitude: -7.150, longitude: 107.782, elevation: 0.0),    // Extreme drop
      ];

      final ctrl = Camera3DController(route: extremeRoute);
      for (double p = 0.0; p <= 1.0; p += 0.1) {
        final s = ctrl.getStateAtProgress(p);
        expect(s.pitch, inInclusiveRange(45.0, 65.0));
      }
    });
  });

  group('Camera3DController - Boundary Stability & Edge Cases Tests', () {
    test('Empty route returns safe default state without crashing', () {
      final ctrl = Camera3DController(route: []);
      final state = ctrl.getStateAtProgress(0.5);
      expect(state.latitude, 0.0);
      expect(state.longitude, 0.0);
      expect(state.bearing, 0.0);
      expect(state.progress, 0.5);
    });

    test('Single coordinate route returns centered state without crashing', () {
      final ctrl = Camera3DController(route: [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1450.0),
      ]);
      final state = ctrl.getStateAtProgress(0.5);
      expect(state.latitude, -7.150);
      expect(state.longitude, 107.780);
      expect(state.elevation, 1450.0);
      expect(state.bearing, 0.0);
    });

    test('Progress outside [0.0, 1.0] is clamped cleanly', () {
      final ctrl = Camera3DController(route: [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780),
        const RouteCoordinate(latitude: -7.151, longitude: 107.781),
      ]);

      final underflow = ctrl.getStateAtProgress(-0.5);
      expect(underflow.progress, 0.0);
      expect(underflow.latitude, closeTo(-7.150, 0.0001));

      final overflow = ctrl.getStateAtProgress(1.5);
      expect(overflow.progress, 1.0);
      expect(overflow.latitude, closeTo(-7.151, 0.0001));
    });

    test('Route with duplicate coordinates (distance 0) does not divide by zero or produce NaN', () {
      final ctrl = Camera3DController(route: [
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1400.0),
        const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1400.0), // Duplicate point!
        const RouteCoordinate(latitude: -7.152, longitude: 107.782, elevation: 1420.0),
      ]);

      final s0 = ctrl.getStateAtProgress(0.0);
      final sMid = ctrl.getStateAtProgress(0.5);
      final sEnd = ctrl.getStateAtProgress(1.0);

      expect(s0.latitude.isNaN, isFalse);
      expect(sMid.latitude.isNaN, isFalse);
      expect(sEnd.latitude.isNaN, isFalse);
      expect(sMid.bearing.isNaN, isFalse);
      expect(sMid.zoom.isNaN, isFalse);
      expect(sMid.pitch.isNaN, isFalse);
    });
  });
}
