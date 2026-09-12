import 'package:flutter/foundation.dart';
import 'package:stravo/core/constants/enums.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

/// Categories for filtering personal heatmap tracks.
enum HeatmapCategory {
  all,
  gravel,
  road,
  run;

  /// Returns true if [sportType] falls under this category.
  bool matches(SportType sportType) {
    switch (this) {
      case HeatmapCategory.all:
        return true;
      case HeatmapCategory.gravel:
        return sportType == SportType.gravelCycling ||
            sportType == SportType.mountainBiking;
      case HeatmapCategory.road:
        return sportType == SportType.roadCycling;
      case HeatmapCategory.run:
        return sportType.isRunning ||
            sportType == SportType.hiking ||
            sportType == SportType.walking;
    }
  }
}

/// Represents an offline historical activity track to be rendered in the heatmap.
@immutable
class HeatmapTrack {
  final String id;
  final SportType sportType;
  final List<RouteCoordinate> coordinates;
  final DateTime timestamp;

  HeatmapTrack({
    required this.id,
    required this.sportType,
    required this.coordinates,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeatmapTrack &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'HeatmapTrack(id: $id, sport: $sportType, points: ${coordinates.length})';
}
