import 'package:stravo/core/constants/enums.dart';
import '../models/heatmap_models.dart';

/// Offline engine that compiles historical route tracks into GeoJSON LineString
/// FeatureCollections with glowing neon styling ready for MapLibre GL JS layer.
class PersonalHeatmapEngine {
  const PersonalHeatmapEngine();

  /// Compiles [tracks] into an RFC 7946 GeoJSON FeatureCollection.
  ///
  /// Filters tracks by [filter], skips invalid/NaN coordinates, and applies
  /// glowing neon styling suitable for MapLibre GL JS `personal-heatmap` layers.
  Map<String, dynamic> generateHeatmapGeoJson(
    List<HeatmapTrack> tracks, {
    HeatmapCategory filter = HeatmapCategory.all,
  }) =>
      generateGeoJson(tracks, filter: filter);

  /// Static helper equivalent to [generateHeatmapGeoJson].
  static Map<String, dynamic> generateGeoJson(
    List<HeatmapTrack> tracks, {
    HeatmapCategory filter = HeatmapCategory.all,
  }) {
    final filtered = tracks.where((t) => filter.matches(t.sportType)).toList();

    if (filtered.isEmpty) {
      return {
        'type': 'FeatureCollection',
        'features': <Map<String, dynamic>>[],
      };
    }

    final features = <Map<String, dynamic>>[];
    for (final track in filtered) {
      // RFC 7946: coordinate order is [longitude, latitude].
      final validCoords = track.coordinates
          .where((c) => c.isValid)
          .map((c) => [c.longitude, c.latitude])
          .toList();

      // A valid LineString requires at least 2 coordinate points.
      if (validCoords.length < 2) continue;

      final neonColor = _getNeonColor(track.sportType);

      features.add({
        'type': 'Feature',
        'properties': {
          'id': track.id,
          'sportType': track.sportType.name,
          'color': neonColor,
          'glowColor': '#00FFA3',
          'opacity': 0.65,
          'lineWidth': 3.0,
          'blur': 1.5,
        },
        'geometry': {
          'type': 'LineString',
          'coordinates': validCoords,
        },
      });
    }

    return {
      'type': 'FeatureCollection',
      'features': features,
    };
  }

  static String _getNeonColor(SportType sportType) {
    if (sportType == SportType.gravelCycling ||
        sportType == SportType.mountainBiking) {
      return '#00FFA3'; // Neon Green
    } else if (sportType == SportType.roadCycling) {
      return '#00E5FF'; // Neon Cyan
    } else if (sportType.isRunning) {
      return '#FF9100'; // Neon Amber / Orange
    }
    return '#00FFA3';
  }
}
