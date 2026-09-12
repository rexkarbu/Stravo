import 'package:flutter/foundation.dart';
import 'package:stravo/core/constants/enums.dart';

/// Internal coordinate model for 3D terrain route polyline and navigation.
///
/// Decoupled from Rouf's database TrackPointEntity to enable independent
/// calculation and rendering of dynamic color-coded polylines.
@immutable
class RouteCoordinate {
  /// Latitude in degrees (-90.0 to +90.0).
  final double latitude;

  /// Longitude in degrees (-180.0 to +180.0).
  final double longitude;

  /// Elevation in meters above sea level (optional).
  final double? elevation;

  /// Speed in meters per second (m/s) as recorded by GPS/sensors (optional).
  final double? speed;

  /// Timestamp when this point was recorded (optional).
  final DateTime? timestamp;

  /// Road/trail surface type detected at this point (optional).
  final SurfaceType? surfaceType;

  const RouteCoordinate({
    required this.latitude,
    required this.longitude,
    this.elevation,
    this.speed,
    this.timestamp,
    this.surfaceType,
  });

  /// Converts speed strictly from meters per second (m/s) to kilometers per hour (km/h).
  ///
  /// Returns null if [speed] is null, NaN, infinite, or negative.
  double? get speedKmPerHour {
    if (speed == null || speed!.isNaN || !speed!.isFinite || speed! < 0) {
      return null;
    }
    return speed! * 3.6;
  }

  /// Whether this coordinate has valid geographic boundaries and is finite/not NaN.
  ///
  /// Valid conditions:
  /// - [latitude] is finite, not NaN, and within [-90.0, 90.0].
  /// - [longitude] is finite, not NaN, and within [-180.0, 180.0].
  bool get isValid {
    if (latitude.isNaN || !latitude.isFinite || longitude.isNaN || !longitude.isFinite) {
      return false;
    }
    return latitude >= -90.0 && latitude <= 90.0 && longitude >= -180.0 && longitude <= 180.0;
  }

  /// Whether elevation is valid (non-null, finite, not NaN).
  bool get hasValidElevation =>
      elevation != null && !elevation!.isNaN && elevation!.isFinite;

  /// Whether speed is valid (non-null, finite, not NaN, >= 0).
  bool get hasValidSpeed =>
      speed != null && !speed!.isNaN && speed!.isFinite && speed! >= 0;

  RouteCoordinate copyWith({
    double? latitude,
    double? longitude,
    double? elevation,
    double? speed,
    DateTime? timestamp,
    SurfaceType? surfaceType,
  }) {
    return RouteCoordinate(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      elevation: elevation ?? this.elevation,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
      surfaceType: surfaceType ?? this.surfaceType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteCoordinate &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          elevation == other.elevation &&
          speed == other.speed &&
          timestamp == other.timestamp &&
          surfaceType == other.surfaceType;

  @override
  int get hashCode => Object.hash(
        latitude,
        longitude,
        elevation,
        speed,
        timestamp,
        surfaceType,
      );

  @override
  String toString() =>
      'RouteCoordinate(lat: $latitude, lng: $longitude, elev: $elevation m, speed: ${speedKmPerHour?.toStringAsFixed(1)} km/h, surface: $surfaceType)';
}
