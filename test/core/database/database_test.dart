import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/core/database/app_database.dart';
import 'package:stravo/features/recording/data/crash_recovery_service.dart';
import 'package:stravo/features/recording/data/incremental_flush_engine.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // Inisialisasi SQLite database in-memory murni (sangat cepat untuk testing)
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  group('ActivitiesDao Tests', () {
    test('Bisa membuat sesi aktivitas inProgress dan menyelesaikannya', () async {
      final now = DateTime.now();

      // 1. Buat sesi baru
      await db.activitiesDao.insertActivity(
        ActivitiesCompanion.insert(
          id: 'act_test_001',
          title: 'Gravel Ride Garut',
          sportType: 'gravelCycling',
          status: 'inProgress',
          startTime: now,
          updatedAt: now,
        ),
      );

      final unfinished = await db.activitiesDao.getUnfinishedActivity();
      expect(unfinished, isNotNull);
      expect(unfinished!.id, 'act_test_001');
      expect(unfinished.status, 'inProgress');

      // 2. Selesaikan sesi
      await db.activitiesDao.completeActivity(
        id: 'act_test_001',
        endTime: now.add(const Duration(hours: 1)),
        totalDistanceMeters: 25400.0,
        elapsedTimeSeconds: 3600,
        movingTimeSeconds: 3400,
        elevationGainMeters: 450.0,
        avgSpeedMps: 7.47,
        maxSpeedMps: 13.8,
        gravelPercentage: 70.0,
        asphaltPercentage: 30.0,
      );

      final completed = await db.activitiesDao.getActivityById('act_test_001');
      expect(completed, isNotNull);
      expect(completed!.status, 'completed');
      expect(completed.totalDistanceMeters, 25400.0);
      expect(completed.gravelPercentage, 70.0);

      // Pastikan tidak ada lagi aktivitas inProgress
      final noUnfinished = await db.activitiesDao.getUnfinishedActivity();
      expect(noUnfinished, isNull);
    });
  });

  group('TrackPointsDao Tests', () {
    test('Bisa menyimpan batch titik GPS 1Hz dan mengambilnya secara berurutan', () async {
      final now = DateTime.now();

      // Buat parent activity
      await db.activitiesDao.insertActivity(
        ActivitiesCompanion.insert(
          id: 'act_test_points',
          title: 'Morning Ride',
          sportType: 'roadCycling',
          status: 'inProgress',
          startTime: now,
          updatedAt: now,
        ),
      );

      // Simpan 5 titik GPS 1Hz
      final points = List.generate(
        5,
        (i) => TrackPointsCompanion.insert(
          activityId: 'act_test_points',
          sequenceIdx: i,
          timestamp: now.add(Duration(seconds: i)),
          latitude: -7.2278 + (i * 0.0001),
          longitude: 107.9087 + (i * 0.0001),
          altitudeMeters: 710.0 + (i * 0.5),
          accuracyMeters: 3.5,
          speedMps: 6.8 + (i * 0.2),
          surfaceType: const Value('smoothGravel'),
        ),
      );

      await db.trackPointsDao.insertBatchTrackPoints(points);

      final savedPoints = await db.trackPointsDao.getPointsForActivity('act_test_points');
      expect(savedPoints.length, 5);
      expect(savedPoints.first.sequenceIdx, 0);
      expect(savedPoints.last.sequenceIdx, 4);
      expect(savedPoints.first.surfaceType, 'smoothGravel');

      final count = await db.trackPointsDao.countPointsForActivity('act_test_points');
      expect(count, 5);
    });
  });

  group('WaypointPhotosDao Tests', () {
    test('Bisa menyimpan foto geotagged di sepanjang rute', () async {
      final now = DateTime.now();

      await db.activitiesDao.insertActivity(
        ActivitiesCompanion.insert(
          id: 'act_photo_test',
          title: 'Photo Ride',
          sportType: 'hiking',
          status: 'inProgress',
          startTime: now,
          updatedAt: now,
        ),
      );

      await db.waypointPhotosDao.insertPhoto(
        WaypointPhotosCompanion.insert(
          id: 'photo_001',
          activityId: 'act_photo_test',
          filePath: '/storage/emulated/0/Stravo/photos/puncak.jpg',
          latitude: -7.2345,
          longitude: 107.9123,
          altitudeMeters: 1450.0,
          distanceFromStartMeters: 12500.0,
          takenAt: now,
          caption: const Value('Puncak Gunung Papandayan'),
        ),
      );

      final photos = await db.waypointPhotosDao.getPhotosForActivity('act_photo_test');
      expect(photos.length, 1);
      expect(photos.first.caption, 'Puncak Gunung Papandayan');
      expect(photos.first.altitudeMeters, 1450.0);
    });
  });

  group('GearsDao Tests', () {
    test('Bisa menambah jarak odometer pada sepeda di garasi', () async {
      await db.gearsDao.insertGear(
        GearsCompanion.insert(
          id: 'gear_polygon',
          name: 'Polygon Bend R5',
          gearType: 'gravelBike',
          brandModel: const Value('Polygon 2024'),
          createdAt: DateTime.now(),
        ),
      );

      final gears = await db.gearsDao.getActiveGears();
      expect(gears.length, 1);
      expect(gears.first.totalDistanceMeters, 0.0);

      // Tambah jarak gowes 50 km (50.000 meter)
      await db.gearsDao.addDistanceToGear('gear_polygon', 50000.0);

      final updatedGears = await db.gearsDao.getActiveGears();
      expect(updatedGears.first.totalDistanceMeters, 50000.0);
    });
  });

  group('IncrementalFlushEngine Tests', () {
    test('Auto-flush memicu commit ke SQLite saat buffer mencapai threshold', () async {
      final now = DateTime.now();

      await db.activitiesDao.insertActivity(
        ActivitiesCompanion.insert(
          id: 'act_flush_test',
          title: 'Flush Test Ride',
          sportType: 'gravelCycling',
          status: 'inProgress',
          startTime: now,
          updatedAt: now,
        ),
      );

      // Inisialisasi engine dengan threshold 3 titik, timer dinonaktifkan untuk deterministik
      final flushEngine = IncrementalFlushEngine(
        trackPointsDao: db.trackPointsDao,
        activitiesDao: db.activitiesDao,
        activityId: 'act_flush_test',
        flushThreshold: 3,
        autoStartTimer: false,
      );

      // Tambahkan 2 titik: buffer = 2, belum di-flush
      await flushEngine.recordPoint(
        TrackPointsCompanion.insert(
          activityId: 'act_flush_test',
          sequenceIdx: 0,
          timestamp: now,
          latitude: -7.1,
          longitude: 107.1,
          altitudeMeters: 700,
          accuracyMeters: 3.0,
          speedMps: 6.0,
        ),
        totalDistanceMeters: 10.0,
      );

      await flushEngine.recordPoint(
        TrackPointsCompanion.insert(
          activityId: 'act_flush_test',
          sequenceIdx: 1,
          timestamp: now.add(const Duration(seconds: 1)),
          latitude: -7.1001,
          longitude: 107.1001,
          altitudeMeters: 700.5,
          accuracyMeters: 3.0,
          speedMps: 6.2,
        ),
        totalDistanceMeters: 22.0,
      );

      expect(flushEngine.bufferedPointsCount, 2);
      expect(flushEngine.totalFlushedCount, 0);

      // Tambahkan titik ke-3: harus otomatis memicu flush!
      await flushEngine.recordPoint(
        TrackPointsCompanion.insert(
          activityId: 'act_flush_test',
          sequenceIdx: 2,
          timestamp: now.add(const Duration(seconds: 2)),
          latitude: -7.1002,
          longitude: 107.1002,
          altitudeMeters: 701.0,
          accuracyMeters: 3.0,
          speedMps: 6.5,
        ),
        totalDistanceMeters: 35.0,
        movingTimeSeconds: 3,
        elapsedTimeSeconds: 3,
        avgSpeedMps: 6.2,
        maxSpeedMps: 6.5,
      );

      // Buffer kembali kosong, 3 titik berhasil di-commit ke SQLite!
      expect(flushEngine.bufferedPointsCount, 0);
      expect(flushEngine.totalFlushedCount, 3);

      final pointsInDb = await db.trackPointsDao.getPointsForActivity('act_flush_test');
      expect(pointsInDb.length, 3);

      // Verifikasi ringkasan di tabel activities juga terupdate
      final activityInDb = await db.activitiesDao.getActivityById('act_flush_test');
      expect(activityInDb!.totalDistanceMeters, 35.0);
      expect(activityInDb.maxSpeedMps, 6.5);

      await flushEngine.dispose();
    });
  });

  group('CrashRecoveryService Tests', () {
    test('Mampu mendeteksi sesi inProgress yang belum selesai dan memulihkannya', () async {
      final now = DateTime.now();

      // Simulasikan sesi yang terputus mendadak karena baterai habis
      await db.activitiesDao.insertActivity(
        ActivitiesCompanion.insert(
          id: 'act_crashed_session',
          title: 'Crashed Gravel Session',
          sportType: 'gravelCycling',
          status: 'inProgress',
          startTime: now,
          updatedAt: now,
          totalDistanceMeters: const Value(18400.0),
          movingTimeSeconds: const Value(2800),
          elapsedTimeSeconds: const Value(3000),
          elevationGainMeters: const Value(320.0),
          avgSpeedMps: const Value(6.57),
          maxSpeedMps: const Value(12.4),
          gravelPercentage: const Value(65.0),
          asphaltPercentage: const Value(35.0),
        ),
      );

      // Tambahkan 10 titik yang sempat ter-flush sebelum crash
      final points = List.generate(
        10,
        (i) => TrackPointsCompanion.insert(
          activityId: 'act_crashed_session',
          sequenceIdx: i,
          timestamp: now.add(Duration(seconds: i)),
          latitude: -7.2 + (i * 0.0001),
          longitude: 107.9 + (i * 0.0001),
          altitudeMeters: 700.0 + i,
          accuracyMeters: 2.5,
          speedMps: 6.5,
        ),
      );
      await db.trackPointsDao.insertBatchTrackPoints(points);

      final recoveryService = CrashRecoveryService(
        activitiesDao: db.activitiesDao,
        trackPointsDao: db.trackPointsDao,
      );

      // 1. Deteksi sesi
      final recoveryState = await recoveryService.checkUnfinishedSession();
      expect(recoveryState.hasUnfinishedSession, isTrue);
      expect(recoveryState.unfinishedActivity, isNotNull);
      expect(recoveryState.unfinishedActivity!.id, 'act_crashed_session');
      expect(recoveryState.recoveredPointsCount, 10);

      // 2. Finalize & Save
      await recoveryService.finalizeAndSave(recoveryState.unfinishedActivity!);

      // Verifikasi sesi kini berstatus completed
      final stateAfterSave = await recoveryService.checkUnfinishedSession();
      expect(stateAfterSave.hasUnfinishedSession, isFalse);

      final completedAct = await db.activitiesDao.getActivityById('act_crashed_session');
      expect(completedAct!.status, 'completed');
      expect(completedAct.totalDistanceMeters, 18400.0);
    });
  });
}
