import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';

/// Aspect ratio presets for social media story cards.
enum StoryCardAspect {
  /// Instagram Stories / WhatsApp Status (1080 × 1920).
  story9x16(1080, 1920),

  /// Instagram Feed / Square post (1080 × 1080).
  feed1x1(1080, 1080);

  final int width;
  final int height;

  const StoryCardAspect(this.width, this.height);

  double get ratio => width / height;
}

/// Immutable data bundle fed into the story card renderer.
class StoryCardData {
  /// Activity title (e.g. "Kamojang Volcanic Ascent").
  final String title;

  /// Date when the activity was recorded.
  final DateTime date;

  /// Human-readable sport type label (e.g. "Gravel Ride", "Trail Run").
  final String sportType;

  /// Total distance in **meters**.
  final double distanceMeters;

  /// Moving time of the activity.
  final Duration movingDuration;

  /// Total elevation gain in meters.
  final double elevationGainMeters;

  /// Maximum speed in **m/s**.
  final double maxSpeedMs;

  /// Average speed in **m/s**.
  final double avgSpeedMs;

  /// GPS track coordinates for route path & elevation profile.
  final List<RouteCoordinate> coordinates;

  /// Target aspect ratio for the card.
  final StoryCardAspect aspectRatio;

  const StoryCardData({
    required this.title,
    required this.date,
    required this.sportType,
    required this.distanceMeters,
    required this.movingDuration,
    required this.elevationGainMeters,
    required this.maxSpeedMs,
    required this.avgSpeedMs,
    required this.coordinates,
    this.aspectRatio = StoryCardAspect.story9x16,
  });

  // ---------------------------------------------------------------------------
  // Computed Getters
  // ---------------------------------------------------------------------------

  /// Distance in kilometers.
  double get distanceKm => distanceMeters / 1000.0;

  /// Maximum speed in km/h.
  double get maxSpeedKmH => maxSpeedMs * 3.6;

  /// Average speed in km/h.
  double get avgSpeedKmH => avgSpeedMs * 3.6;

  /// Moving duration formatted as `HH:mm:ss` (or `mm:ss` when < 1 hour).
  String get formattedDuration {
    final total = movingDuration.inSeconds;
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final s = total % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:'
          '${m.toString().padLeft(2, '0')}:'
          '${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }
}
