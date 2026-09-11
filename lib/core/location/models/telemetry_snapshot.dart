import 'package:stravo/core/constants/enums.dart';

/// Model Snapshot Telemetri Realtime (Frekuensi 1 Hz / 1 detik)
/// Kontrak bersama: Diproduksi oleh Live Tracking Engine (Rouf)
/// dan dikonsumsi oleh Live Telemetry HUD, Peta Live, dan Live Segment Matcher (Rekan).
class LiveTelemetrySnapshot {
  /// Kecepatan saat ini dalam km/jam (misal: 28.4 km/h)
  final double currentSpeedKmh;

  /// Kecepatan rata-rata aktivitas dalam km/jam
  final double averageSpeedKmh;

  /// Total jarak kumulatif yang telah ditempuh dalam meter
  final double totalDistanceMeters;

  /// Durasi waktu bergerak (dikurangi waktu jeda/auto-pause) dalam detik
  final int movingTimeSeconds;

  /// Durasi waktu total sejak start dalam detik
  final int elapsedTimeSeconds;

  /// Ketinggian saat ini dari atas permukaan laut (meter)
  final double currentAltitudeMeters;

  /// Total akumulasi elevasi naik (elevation gain) dalam meter
  final double totalElevationGainMeters;

  /// Kemiringan tanjakan/turunan saat ini dalam persen (misal: 7.5% atau -3.2%)
  final double currentGradePct;

  /// Estimasi jenis permukaan jalan berdasarkan sensor getaran accelerometer
  final SurfaceType currentSurface;

  /// Koordinat lintang saat ini (WGS84)
  final double latitude;

  /// Koordinat bujur saat ini (WGS84)
  final double longitude;

  /// Akurasi sinyal GPS dalam radius meter
  final double accuracyMeters;

  /// Arah hadap kompas (0 - 360 derajat)
  final double bearingDegrees;

  /// Waktu titik dicatat
  final DateTime timestamp;

  /// Status apakah sistem sedang dalam mode jeda otomatis (Auto-Pause)
  final bool isAutoPaused;

  const LiveTelemetrySnapshot({
    required this.currentSpeedKmh,
    required this.averageSpeedKmh,
    required this.totalDistanceMeters,
    required this.movingTimeSeconds,
    required this.elapsedTimeSeconds,
    required this.currentAltitudeMeters,
    required this.totalElevationGainMeters,
    required this.currentGradePct,
    required this.currentSurface,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.bearingDegrees,
    required this.timestamp,
    required this.isAutoPaused,
  });

  /// Factory helper untuk inisialisasi state awal sebelum GPS lock
  factory LiveTelemetrySnapshot.initial() {
    return LiveTelemetrySnapshot(
      currentSpeedKmh: 0.0,
      averageSpeedKmh: 0.0,
      totalDistanceMeters: 0.0,
      movingTimeSeconds: 0,
      elapsedTimeSeconds: 0,
      currentAltitudeMeters: 0.0,
      totalElevationGainMeters: 0.0,
      currentGradePct: 0.0,
      currentSurface: SurfaceType.unknown,
      latitude: 0.0,
      longitude: 0.0,
      accuracyMeters: 0.0,
      bearingDegrees: 0.0,
      timestamp: DateTime.now(),
      isAutoPaused: false,
    );
  }
}
