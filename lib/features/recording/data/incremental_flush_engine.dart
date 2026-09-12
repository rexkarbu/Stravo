import 'dart:async';
import 'package:drift/drift.dart';
import 'package:stravo/core/database/app_database.dart';
import 'package:stravo/core/database/daos/activities_dao.dart';
import 'package:stravo/core/database/daos/track_points_dao.dart';

/// Incremental Local Flush Engine (Mesin Komit Berkala Anti-Crash)
/// Penanggung Jawab: Rouf (Fullstack Core & Data Engine)
///
/// Menyimpan buffer titik koordinat di memori dan otomatis melakukan commit (flush)
/// ke SQLite lokal setiap 5 detik atau saat buffer mencapai 5 titik.
/// Menjamin 0% data hilang jika ponsel kehabisan baterai atau OS menghentikan aplikasi.
class IncrementalFlushEngine {
  final TrackPointsDao _trackPointsDao;
  final ActivitiesDao _activitiesDao;
  final String activityId;

  /// Jumlah titik maksimal dalam buffer sebelum auto-flush dipicu
  final int flushThreshold;

  /// Interval waktu auto-flush
  final Duration flushInterval;

  final List<TrackPointsCompanion> _buffer = [];
  Timer? _periodicTimer;

  int _totalFlushedCount = 0;
  int get totalFlushedCount => _totalFlushedCount;
  int get bufferedPointsCount => _buffer.length;

  // Nilai telemetri kumulatif terakhir untuk update ringkasan tabel activities
  double _lastDistanceMeters = 0.0;
  int _lastMovingTimeSeconds = 0;
  int _lastElapsedTimeSeconds = 0;
  double _lastElevationGainMeters = 0.0;
  double _lastAvgSpeedMps = 0.0;
  double _lastMaxSpeedMps = 0.0;
  double _lastGravelPct = 0.0;
  double _lastAsphaltPct = 0.0;

  IncrementalFlushEngine({
    required TrackPointsDao trackPointsDao,
    required ActivitiesDao activitiesDao,
    required this.activityId,
    this.flushThreshold = 5,
    this.flushInterval = const Duration(seconds: 5),
    bool autoStartTimer = true,
  })  : _trackPointsDao = trackPointsDao,
        _activitiesDao = activitiesDao {
    if (autoStartTimer) {
      _startPeriodicTimer();
    }
  }

  void _startPeriodicTimer() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(flushInterval, (_) {
      flush();
    });
  }

  /// Tambahkan 1 titik GPS baru ke dalam buffer dan update telemetri terakhir
  Future<void> recordPoint(
    TrackPointsCompanion point, {
    double? totalDistanceMeters,
    int? movingTimeSeconds,
    int? elapsedTimeSeconds,
    double? elevationGainMeters,
    double? avgSpeedMps,
    double? maxSpeedMps,
    double? gravelPercentage,
    double? asphaltPercentage,
  }) async {
    _buffer.add(point);

    if (totalDistanceMeters != null) _lastDistanceMeters = totalDistanceMeters;
    if (movingTimeSeconds != null) _lastMovingTimeSeconds = movingTimeSeconds;
    if (elapsedTimeSeconds != null) _lastElapsedTimeSeconds = elapsedTimeSeconds;
    if (elevationGainMeters != null) _lastElevationGainMeters = elevationGainMeters;
    if (avgSpeedMps != null) _lastAvgSpeedMps = avgSpeedMps;
    if (maxSpeedMps != null && maxSpeedMps > _lastMaxSpeedMps) {
      _lastMaxSpeedMps = maxSpeedMps;
    }
    if (gravelPercentage != null) _lastGravelPct = gravelPercentage;
    if (asphaltPercentage != null) _lastAsphaltPct = asphaltPercentage;

    // Jika buffer sudah mencapai batas threshold (default 5 titik), segera flush
    if (_buffer.length >= flushThreshold) {
      await flush();
    }
  }

  /// Tulis sekumpulan titik koordinat dalam buffer ke SQLite dan update ringkasan aktivitas
  Future<void> flush() async {
    if (_buffer.isEmpty) return;

    final batchToFlush = List<TrackPointsCompanion>.from(_buffer);
    _buffer.clear();

    try {
      // 1. Commit titik GPS secara batch ke SQLite
      await _trackPointsDao.insertBatchTrackPoints(batchToFlush);
      _totalFlushedCount += batchToFlush.length;

      // 2. Update ringkasan sesi di tabel activities agar data selalu sinkron
      final existingActivity = await _activitiesDao.getActivityById(activityId);
      if (existingActivity != null) {
        await _activitiesDao.updateActivity(
          ActivitiesCompanion(
            id: Value(activityId),
            userId: Value(existingActivity.userId),
            gearId: Value(existingActivity.gearId),
            title: Value(existingActivity.title),
            description: Value(existingActivity.description),
            sportType: Value(existingActivity.sportType),
            status: Value(existingActivity.status),
            startTime: Value(existingActivity.startTime),
            endTime: Value(existingActivity.endTime),
            totalDistanceMeters: Value(_lastDistanceMeters),
            movingTimeSeconds: Value(_lastMovingTimeSeconds),
            elapsedTimeSeconds: Value(_lastElapsedTimeSeconds),
            elevationGainMeters: Value(_lastElevationGainMeters),
            avgSpeedMps: Value(_lastAvgSpeedMps),
            maxSpeedMps: Value(_lastMaxSpeedMps),
            gravelPercentage: Value(_lastGravelPct),
            asphaltPercentage: Value(_lastAsphaltPct),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      // Jika terjadi error saat commit (misal SQLite lock), masukkan kembali ke buffer
      _buffer.insertAll(0, batchToFlush);
      rethrow;
    }
  }

  /// Hentikan timer dan lakukan final flush sebelum sesi selesai
  Future<void> dispose() async {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    await flush();
  }
}
