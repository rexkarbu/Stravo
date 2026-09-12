import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/core/constants/enums.dart';
import '../models/colored_route_segment.dart';
import '../models/route_coordinate.dart';

/// Represents a normalized position (0.0 to 1.0) and color in a gradient.
@immutable
class ColorStop {
  final double position;
  final Color color;

  const ColorStop(this.position, this.color)
      : assert(position >= 0.0 && position <= 1.0, 'Position must be between 0.0 and 1.0');
}

/// Calculator that transforms raw route coordinates into colored polyline segments
/// for 2D/3D map rendering (MapLibre GL JS / Canvas).
///
/// Features:
/// - Supports [PolylineColorMode.speedHeat], [PolylineColorMode.elevationGradient], and [PolylineColorMode.surfaceType].
/// - Converts speed strictly from m/s to km/h ($v_{km/h} = v_{m/s} \times 3.6$).
/// - Gracefully handles empty routes, 1-point routes, constant speed/elevation, and NaN/infinite coordinates.
/// - Invalid coordinates automatically split the route into disjoint segments (no bridging lines across invalid points).
/// - Merges adjacent segments that share the same color/surface by default, while supporting unmerged pairwise mode.
class PolylineColorCalculator {
  PolylineColorCalculator._();

  // ---------------------------------------------------------------------------
  // Default Colors & Gradients
  // ---------------------------------------------------------------------------

  /// Default surface type to color mapping based on Stravo specifications:
  /// - Asphalt: Cyber Green (#00FF9D)
  /// - Smooth Gravel: Stravo Orange (#FF5500)
  /// - Rough Gravel / Makadam: Deep Rust Amber (#D84315)
  /// - Dirt / Singletrack: Earth Brown (#795548)
  /// - Cobblestone / Paving: Slate Grey (#78909C)
  /// - Unknown: Muted Text Grey (#6B7787)
  static const Map<SurfaceType, Color> defaultSurfaceColors = {
    SurfaceType.asphalt: StravoColors.cyberGreen, // #00FF9D
    SurfaceType.smoothGravel: StravoColors.orangePrimary, // #FF5500
    SurfaceType.roughGravel: Color(0xFFD84315), // Deep Rust/Amber
    SurfaceType.dirt: Color(0xFF795548), // Earth Brown
    SurfaceType.cobblestone: Color(0xFF78909C), // Slate Grey
    SurfaceType.unknown: StravoColors.textMuted, // #6B7787
  };

  /// Fallback color used when metrics cannot be determined or on empty/constant fallback.
  static const Color fallbackColor = StravoColors.cyberGreen;

  /// Default Speed Heat gradient stops:
  /// Blue (Santai/Slow) -> Green (Moderate) -> Yellow (High Tempo) -> Red (Sprint)
  static const List<ColorStop> defaultSpeedStops = [
    ColorStop(0.0, Color(0xFF007AFF)), // Santai / Recovery Blue
    ColorStop(0.33, StravoColors.cyberGreen), // Aerobic Green (#00FF9D)
    ColorStop(0.66, StravoColors.neonYellow), // Threshold Yellow (#FFD600)
    ColorStop(1.0, Color(0xFFFF0055)), // Sprint Neon Red/Pink (#FF0055)
  ];

  /// Default Elevation gradient stops:
  /// Low valley (Cyan/Green) -> Mid elevation (Yellow) -> High elevation (Orange) -> Peak (Neon Pink)
  static const List<ColorStop> defaultElevationStops = [
    ColorStop(0.0, StravoColors.electricCyan), // Valley base (#00E5FF)
    ColorStop(0.35, StravoColors.cyberGreen), // Low hill (#00FF9D)
    ColorStop(0.70, StravoColors.neonYellow), // High ridge (#FFD600)
    ColorStop(1.0, StravoColors.neonPink), // Summit peak (#FF0055)
  ];

  // ---------------------------------------------------------------------------
  // Main Calculation API
  // ---------------------------------------------------------------------------

  /// Calculates colored route segments from a list of route coordinates.
  ///
  /// - [route]: The list of coordinates.
  /// - [mode]: Color-coding mode ([PolylineColorMode.speedHeat], [elevationGradient], or [surfaceType]).
  /// - [mergeAdjacent]: If true (default), contiguous sub-segments with identical colors
  ///   are merged into a single multi-point segment to minimize WebGL draw calls.
  ///   If false, produces pairwise 2-point segments `[p_i, p_{i+1}]`.
  /// - [surfaceColors]: Custom mapping for [SurfaceType] colors (optional).
  /// - [speedStops]: Custom gradient stops for speed heat (optional).
  /// - [elevationStops]: Custom gradient stops for elevation (optional).
  /// - [minSpeedKmH] / [maxSpeedKmH]: Optional explicit speed bounds. If null, computed from route.
  /// - [minElevation] / [maxElevation]: Optional explicit elevation bounds. If null, computed from route.
  static List<ColoredRouteSegment> calculate({
    required List<RouteCoordinate> route,
    required PolylineColorMode mode,
    bool mergeAdjacent = true,
    Map<SurfaceType, Color>? surfaceColors,
    List<ColorStop>? speedStops,
    List<ColorStop>? elevationStops,
    double? minSpeedKmH,
    double? maxSpeedKmH,
    double? minElevation,
    double? maxElevation,
  }) {
    if (route.length < 2) {
      return const [];
    }

    // Step 1: Split route into continuous runs of valid coordinates.
    // An invalid coordinate (NaN, out-of-bounds, infinite) terminates the current run
    // and starts a new one, ensuring invalid points separate the polyline into disjoint segments.
    final validRuns = _extractValidRuns(route);
    if (validRuns.isEmpty) {
      return const [];
    }

    // Step 2: Precompute domain ranges (min/max) for gradient normalization across all valid points.
    final (speedMin, speedMax) = _resolveSpeedRange(validRuns, minSpeedKmH, maxSpeedKmH);
    final (elevMin, elevMax) = _resolveElevationRange(validRuns, minElevation, maxElevation);

    final resolvedSurfaceColors = surfaceColors ?? defaultSurfaceColors;
    final resolvedSpeedStops = speedStops ?? defaultSpeedStops;
    final resolvedElevationStops = elevationStops ?? defaultElevationStops;

    final allSegments = <ColoredRouteSegment>[];

    // Step 3: Process each continuous valid run independently.
    for (final run in validRuns) {
      if (run.length < 2) continue;

      final runSegments = <ColoredRouteSegment>[];

      for (int i = 0; i < run.length - 1; i++) {
        final p0 = run[i];
        final p1 = run[i + 1];

        final (color, metricValue, surface) = _evaluatePair(
          p0: p0,
          p1: p1,
          mode: mode,
          surfaceColors: resolvedSurfaceColors,
          speedStops: resolvedSpeedStops,
          elevationStops: resolvedElevationStops,
          minSpeedKmH: speedMin,
          maxSpeedKmH: speedMax,
          minElevation: elevMin,
          maxElevation: elevMax,
        );

        runSegments.add(ColoredRouteSegment(
          points: [p0, p1],
          color: color,
          mode: mode,
          metricValue: metricValue,
          surfaceType: surface,
        ));
      }

      if (mergeAdjacent) {
        allSegments.addAll(_mergeContiguousSegments(runSegments));
      } else {
        allSegments.addAll(runSegments);
      }
    }

    return allSegments;
  }

  // ---------------------------------------------------------------------------
  // Helper API for single values
  // ---------------------------------------------------------------------------

  /// Evaluates color for a given speed in km/h.
  static Color getSpeedColor(
    double speedKmH, {
    double minSpeedKmH = 0.0,
    double maxSpeedKmH = 50.0,
    List<ColorStop>? stops,
  }) {
    if (speedKmH.isNaN || !speedKmH.isFinite) {
      return fallbackColor;
    }
    final resolvedStops = stops ?? defaultSpeedStops;
    if (maxSpeedKmH <= minSpeedKmH) {
      return interpolateGradient(0.5, resolvedStops);
    }
    final t = ((speedKmH - minSpeedKmH) / (maxSpeedKmH - minSpeedKmH)).clamp(0.0, 1.0);
    return interpolateGradient(t, resolvedStops);
  }

  /// Evaluates color for a given elevation in meters.
  static Color getElevationColor(
    double elevation, {
    required double minElevation,
    required double maxElevation,
    List<ColorStop>? stops,
  }) {
    if (elevation.isNaN || !elevation.isFinite) {
      return fallbackColor;
    }
    final resolvedStops = stops ?? defaultElevationStops;
    if (maxElevation <= minElevation) {
      return interpolateGradient(0.5, resolvedStops);
    }
    final t = ((elevation - minElevation) / (maxElevation - minElevation)).clamp(0.0, 1.0);
    return interpolateGradient(t, resolvedStops);
  }

  /// Evaluates color for a given surface type.
  static Color getSurfaceColor(
    SurfaceType surfaceType, {
    Map<SurfaceType, Color>? surfaceColors,
  }) {
    final map = surfaceColors ?? defaultSurfaceColors;
    return map[surfaceType] ?? map[SurfaceType.unknown] ?? fallbackColor;
  }

  /// Interpolates a color from normalized position [t] (0.0 to 1.0) along [stops].
  static Color interpolateGradient(double t, List<ColorStop> stops) {
    if (stops.isEmpty) return fallbackColor;
    if (stops.length == 1) return stops.first.color;
    if (t <= stops.first.position) return stops.first.color;
    if (t >= stops.last.position) return stops.last.color;

    for (int i = 0; i < stops.length - 1; i++) {
      final s0 = stops[i];
      final s1 = stops[i + 1];

      if (t >= s0.position && t <= s1.position) {
        final span = s1.position - s0.position;
        if (span <= 0.0) return s0.color;
        final localT = (t - s0.position) / span;
        return Color.lerp(s0.color, s1.color, localT) ?? s0.color;
      }
    }

    return stops.last.color;
  }

  // ---------------------------------------------------------------------------
  // Internal Calculations
  // ---------------------------------------------------------------------------

  /// Extracts contiguous runs of valid coordinates.
  /// Any invalid coordinate terminates the run, causing a polyline split.
  static List<List<RouteCoordinate>> _extractValidRuns(List<RouteCoordinate> route) {
    final runs = <List<RouteCoordinate>>[];
    List<RouteCoordinate>? currentRun;

    for (final coord in route) {
      if (coord.isValid) {
        currentRun ??= <RouteCoordinate>[];
        currentRun.add(coord);
      } else {
        if (currentRun != null) {
          if (currentRun.length >= 2) {
            runs.add(currentRun);
          }
          currentRun = null;
        }
      }
    }

    if (currentRun != null && currentRun.length >= 2) {
      runs.add(currentRun);
    }

    return runs;
  }

  static (double, double) _resolveSpeedRange(
    List<List<RouteCoordinate>> runs,
    double? minOverride,
    double? maxOverride,
  ) {
    if (minOverride != null && maxOverride != null) {
      return (minOverride, maxOverride);
    }

    double minV = double.infinity;
    double maxV = -double.infinity;

    for (final run in runs) {
      for (final p in run) {
        final v = p.speedKmPerHour;
        if (v != null) {
          if (v < minV) minV = v;
          if (v > maxV) maxV = v;
        }
      }
    }

    if (minV.isInfinite || maxV.isInfinite) {
      return (minOverride ?? 0.0, maxOverride ?? 30.0);
    }

    return (minOverride ?? minV, maxOverride ?? maxV);
  }

  static (double, double) _resolveElevationRange(
    List<List<RouteCoordinate>> runs,
    double? minOverride,
    double? maxOverride,
  ) {
    if (minOverride != null && maxOverride != null) {
      return (minOverride, maxOverride);
    }

    double minE = double.infinity;
    double maxE = -double.infinity;

    for (final run in runs) {
      for (final p in run) {
        final e = p.elevation;
        if (e != null && !e.isNaN && e.isFinite) {
          if (e < minE) minE = e;
          if (e > maxE) maxE = e;
        }
      }
    }

    if (minE.isInfinite || maxE.isInfinite) {
      return (minOverride ?? 0.0, maxOverride ?? 1000.0);
    }

    return (minOverride ?? minE, maxOverride ?? maxE);
  }

  static (Color, double?, SurfaceType?) _evaluatePair({
    required RouteCoordinate p0,
    required RouteCoordinate p1,
    required PolylineColorMode mode,
    required Map<SurfaceType, Color> surfaceColors,
    required List<ColorStop> speedStops,
    required List<ColorStop> elevationStops,
    required double minSpeedKmH,
    required double maxSpeedKmH,
    required double minElevation,
    required double maxElevation,
  }) {
    switch (mode) {
      case PolylineColorMode.speedHeat:
        final v0 = p0.speedKmPerHour;
        final v1 = p1.speedKmPerHour;
        double? avgSpeed;
        if (v0 != null && v1 != null) {
          avgSpeed = (v0 + v1) / 2.0;
        } else {
          avgSpeed = v0 ?? v1;
        }

        if (avgSpeed == null) {
          final c = interpolateGradient(0.5, speedStops);
          return (c, null, null);
        }

        final c = getSpeedColor(
          avgSpeed,
          minSpeedKmH: minSpeedKmH,
          maxSpeedKmH: maxSpeedKmH,
          stops: speedStops,
        );
        return (c, avgSpeed, null);

      case PolylineColorMode.elevationGradient:
        final e0 = (p0.elevation != null && !p0.elevation!.isNaN && p0.elevation!.isFinite)
            ? p0.elevation
            : null;
        final e1 = (p1.elevation != null && !p1.elevation!.isNaN && p1.elevation!.isFinite)
            ? p1.elevation
            : null;
        double? avgElev;
        if (e0 != null && e1 != null) {
          avgElev = (e0 + e1) / 2.0;
        } else {
          avgElev = e0 ?? e1;
        }

        if (avgElev == null) {
          final c = interpolateGradient(0.5, elevationStops);
          return (c, null, null);
        }

        final c = getElevationColor(
          avgElev,
          minElevation: minElevation,
          maxElevation: maxElevation,
          stops: elevationStops,
        );
        return (c, avgElev, null);

      case PolylineColorMode.surfaceType:
        final surface = p1.surfaceType ?? p0.surfaceType ?? SurfaceType.unknown;
        final c = surfaceColors[surface] ?? surfaceColors[SurfaceType.unknown] ?? fallbackColor;
        return (c, null, surface);
    }
  }

  static List<ColoredRouteSegment> _mergeContiguousSegments(
      List<ColoredRouteSegment> segments) {
    if (segments.isEmpty) return const [];

    final merged = <ColoredRouteSegment>[];
    ColoredRouteSegment current = segments.first;
    List<RouteCoordinate> currentPoints = List.of(current.points);

    for (int i = 1; i < segments.length; i++) {
      final next = segments[i];

      // Merge if color is identical and surfaceType is identical.
      if (current.color == next.color &&
          current.surfaceType == next.surfaceType) {
        currentPoints.add(next.points.last);
      } else {
        merged.add(ColoredRouteSegment(
          points: currentPoints,
          color: current.color,
          mode: current.mode,
          metricValue: current.metricValue,
          surfaceType: current.surfaceType,
        ));
        current = next;
        currentPoints = List.of(next.points);
      }
    }

    merged.add(ColoredRouteSegment(
      points: currentPoints,
      color: current.color,
      mode: current.mode,
      metricValue: current.metricValue,
      surfaceType: current.surfaceType,
    ));

    return merged;
  }
}
