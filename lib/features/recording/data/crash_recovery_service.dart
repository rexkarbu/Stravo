import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stravo/core/database/app_database.dart';
import 'package:stravo/core/database/daos/activities_dao.dart';
import 'package:stravo/core/database/daos/track_points_dao.dart';

/// State hasil pemeriksaan pemulihan sesi crash
class CrashRecoveryState {
  final bool hasUnfinishedSession;
  final Activity? unfinishedActivity;
  final int recoveredPointsCount;

  const CrashRecoveryState({
    required this.hasUnfinishedSession,
    this.unfinishedActivity,
    this.recoveredPointsCount = 0,
  });

  factory CrashRecoveryState.clean() {
    return const CrashRecoveryState(
      hasUnfinishedSession: false,
      unfinishedActivity: null,
      recoveredPointsCount: 0,
    );
  }
}

/// Crash Recovery Service (Layanan Pemulihan Sesi Pasca Crash / Mati Lampu / Habis Baterai)
/// Penanggung Jawab: Rouf (Fullstack Core & Data Engine)
///
/// Setiap kali Stravo Pro dibuka, layanan ini mendeteksi apakah ada aktivitas
/// dengan status 'inProgress'. Jika ada, pengguna diberikan opsi:
/// 1. Lanjutkan sesi pelacakan (Resume)
/// 2. Simpan sesi yang terputus (Finalize & Save)
/// 3. Batalkan/buang sesi tersebut (Discard)
class CrashRecoveryService {
  final ActivitiesDao _activitiesDao;
  final TrackPointsDao _trackPointsDao;

  CrashRecoveryService({
    required ActivitiesDao activitiesDao,
    required TrackPointsDao trackPointsDao,
  })  : _activitiesDao = activitiesDao,
        _trackPointsDao = trackPointsDao;

  /// Periksa apakah ada sesi yang belum selesai
  Future<CrashRecoveryState> checkUnfinishedSession() async {
    final unfinishedActivity = await _activitiesDao.getUnfinishedActivity();
    if (unfinishedActivity == null) {
      return CrashRecoveryState.clean();
    }

    // Hitung berapa titik koordinat GPS yang berhasil diselamatkan dari SQLite
    final pointsCount =
        await _trackPointsDao.countPointsForActivity(unfinishedActivity.id);

    return CrashRecoveryState(
      hasUnfinishedSession: true,
      unfinishedActivity: unfinishedActivity,
      recoveredPointsCount: pointsCount,
    );
  }

  /// Simpan sesi terputus sebagai selesai (Mark as completed)
  Future<void> finalizeAndSave(Activity activity) async {
    await _activitiesDao.completeActivity(
      id: activity.id,
      endTime: DateTime.now(),
      totalDistanceMeters: activity.totalDistanceMeters,
      elapsedTimeSeconds: activity.elapsedTimeSeconds,
      movingTimeSeconds: activity.movingTimeSeconds,
      elevationGainMeters: activity.elevationGainMeters,
      avgSpeedMps: activity.avgSpeedMps,
      maxSpeedMps: activity.maxSpeedMps,
      gravelPercentage: activity.gravelPercentage,
      asphaltPercentage: activity.asphaltPercentage,
    );
  }

  /// Buang sesi terputus (Hapus dari database)
  Future<void> discardSession(String activityId) async {
    await _activitiesDao.deleteActivity(activityId);
  }
}

/// Riverpod Provider untuk CrashRecoveryService
final crashRecoveryServiceProvider = Provider<CrashRecoveryService>((ref) {
  final activitiesDao = ref.watch(activitiesDaoProvider);
  final trackPointsDao = ref.watch(trackPointsDaoProvider);
  return CrashRecoveryService(
    activitiesDao: activitiesDao,
    trackPointsDao: trackPointsDao,
  );
});
