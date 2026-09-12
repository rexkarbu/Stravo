/// Phase within the 30-second cinematic video timeline.
enum VideoSegmentPhase {
  /// Seconds 0 – 3: cinematic intro with title, date, logo fade-in.
  intro,

  /// Seconds 3 – 24: 3D flyover tracking along the route.
  flyoverTracking,

  /// Seconds 24 – 30: outro summary card with stats.
  outroSummary,
}

/// Describes the exact state of a single frame in the 30-second video.
class VideoTimelineFrame {
  /// Absolute timestamp in seconds (0.0 to 30.0).
  final double timestampSeconds;

  /// Which phase the frame belongs to.
  final VideoSegmentPhase currentPhase;

  /// Route progress normalised to 0.0 (at t=3s) → 1.0 (at t=24s).
  /// Outside the flyover phase this is 0.0 or 1.0 respectively.
  final double routeProgress;

  /// Index of the kilometer waypoint currently being passed, if any.
  /// `null` when no waypoint is active at this frame.
  final int? activeWaypointIndex;

  const VideoTimelineFrame({
    required this.timestampSeconds,
    required this.currentPhase,
    required this.routeProgress,
    this.activeWaypointIndex,
  });

  // -------------------------------------------------------------------------
  // Factory: calculate a frame from an absolute timestamp
  // -------------------------------------------------------------------------

  /// Maps an absolute timestamp (0 – 30 s) to the correct phase & progress.
  ///
  /// [totalDistanceMeters] is used to determine which KM waypoint (if any)
  /// is being crossed at the current route progress.
  static VideoTimelineFrame calculateFrame(
    double tSeconds, {
    double totalDistanceMeters = 0.0,
  }) {
    final t = tSeconds.clamp(0.0, 30.0);

    // Phase boundaries
    const introEnd = 3.0;
    const flyoverEnd = 24.0;
    // const outroEnd = 30.0;

    if (t < introEnd) {
      return VideoTimelineFrame(
        timestampSeconds: t,
        currentPhase: VideoSegmentPhase.intro,
        routeProgress: 0.0,
      );
    }

    if (t < flyoverEnd) {
      final flyoverDuration = flyoverEnd - introEnd; // 21 seconds
      final progress = ((t - introEnd) / flyoverDuration).clamp(0.0, 1.0);

      // Determine active waypoint (every 1 km)
      int? waypoint;
      if (totalDistanceMeters > 0) {
        final coveredMeters = progress * totalDistanceMeters;
        final kmIndex = (coveredMeters / 1000.0).floor();
        if (kmIndex > 0) {
          // Check if we're within 50m of crossing a KM boundary
          final kmBoundary = kmIndex * 1000.0;
          final delta = (coveredMeters - kmBoundary).abs();
          if (delta < 50.0) {
            waypoint = kmIndex;
          }
        }
      }

      return VideoTimelineFrame(
        timestampSeconds: t,
        currentPhase: VideoSegmentPhase.flyoverTracking,
        routeProgress: progress,
        activeWaypointIndex: waypoint,
      );
    }

    // Outro: t >= 24.0
    return VideoTimelineFrame(
      timestampSeconds: t,
      currentPhase: VideoSegmentPhase.outroSummary,
      routeProgress: 1.0,
    );
  }
}
