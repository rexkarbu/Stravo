import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stravo/core/constants/enums.dart';
import 'route_coordinate.dart';

/// Modes for coloring dynamic route polylines.
enum PolylineColorMode {
  /// Heatmap based on speed: Blue (easy/slow) -> Green -> Yellow -> Red (sprint).
  speedHeat,

  /// Gradient based on elevation: Lowest point to highest point.
  elevationGradient,

  /// Discrete color mapping based on detected road surface (asphalt, gravel, dirt, etc.).
  surfaceType,
}

/// A contiguous segment of route coordinates rendered with a single color.
///
/// Contains at least two coordinates to form a drawable polyline section.
@immutable
class ColoredRouteSegment {
  /// Contiguous coordinates forming this polyline segment (at least 2 points).
  final List<RouteCoordinate> points;

  /// The display color for this segment.
  final Color color;

  /// The coloring mode used to produce this segment.
  final PolylineColorMode mode;

  /// The metric value represented by this segment:
  /// - For [PolylineColorMode.speedHeat]: speed in km/h.
  /// - For [PolylineColorMode.elevationGradient]: elevation in meters.
  /// - For [PolylineColorMode.surfaceType]: null.
  final double? metricValue;

  /// The surface type represented by this segment (if [mode] is [PolylineColorMode.surfaceType]).
  final SurfaceType? surfaceType;

  const ColoredRouteSegment({
    required this.points,
    required this.color,
    required this.mode,
    this.metricValue,
    this.surfaceType,
  }) : assert(points.length >= 2, 'A ColoredRouteSegment must contain at least 2 points');

  /// Starting coordinate of the segment.
  RouteCoordinate get start => points.first;

  /// Ending coordinate of the segment.
  RouteCoordinate get end => points.last;

  /// Number of coordinates in this segment.
  int get pointCount => points.length;

  /// Returns the hex color string formatted as '#RRGGBB'.
  String get hexColor {
    final argb = color.toARGB32();
    final r = ((argb >> 16) & 0xFF).toRadixString(16).padLeft(2, '0');
    final g = ((argb >> 8) & 0xFF).toRadixString(16).padLeft(2, '0');
    final b = (argb & 0xFF).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  /// Converts points to GeoJSON coordinate format: `[[lng, lat], ...]`.
  List<List<double>> toCoordinatesList({bool includeElevation = false}) {
    return points.map((p) {
      if (includeElevation && p.elevation != null) {
        return [p.longitude, p.latitude, p.elevation!];
      }
      return [p.longitude, p.latitude];
    }).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColoredRouteSegment &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          mode == other.mode &&
          surfaceType == other.surfaceType &&
          metricValue == other.metricValue &&
          listEquals(points, other.points);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(points),
        color,
        mode,
        metricValue,
        surfaceType,
      );

  @override
  String toString() =>
      'ColoredRouteSegment(mode: $mode, color: $hexColor, points: ${points.length}, metric: $metricValue, surface: $surfaceType)';
}
