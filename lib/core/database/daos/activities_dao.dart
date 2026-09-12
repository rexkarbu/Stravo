import 'package:drift/drift.dart';
import 'package:stravo/core/database/app_database.dart';
import 'package:stravo/core/database/tables/activities_table.dart';

part 'activities_dao.g.dart';

@DriftAccessor(tables: [Activities])
class ActivitiesDao extends DatabaseAccessor<AppDatabase>
    with _$ActivitiesDaoMixin {
  ActivitiesDao(super.db);

  /// Buat sesi aktivitas baru (Status: inProgress)
  Future<void> insertActivity(ActivitiesCompanion entry) =>
      into(activities).insert(entry);

  /// Update telemetry ringkasan aktivitas saat tracking berjalan (incremental update)
  Future<bool> updateActivity(ActivitiesCompanion entry) =>
      update(activities).replace(entry);

  /// Selesaikan sesi aktivitas
  Future<int> completeActivity({
    required String id,
    required DateTime endTime,
    required double totalDistanceMeters,
    required int elapsedTimeSeconds,
    required int movingTimeSeconds,
    required double elevationGainMeters,
    required double avgSpeedMps,
    required double maxSpeedMps,
    required double gravelPercentage,
    required double asphaltPercentage,
  }) {
    return (update(activities)..where((t) => t.id.equals(id))).write(
      ActivitiesCompanion(
        status: const Value('completed'),
        endTime: Value(endTime),
        totalDistanceMeters: Value(totalDistanceMeters),
        elapsedTimeSeconds: Value(elapsedTimeSeconds),
        movingTimeSeconds: Value(movingTimeSeconds),
        elevationGainMeters: Value(elevationGainMeters),
        avgSpeedMps: Value(avgSpeedMps),
        maxSpeedMps: Value(maxSpeedMps),
        gravelPercentage: Value(gravelPercentage),
        asphaltPercentage: Value(asphaltPercentage),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Ambil satu aktivitas berdasarkan ID
  Future<Activity?> getActivityById(String id) {
    return (select(activities)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Watch stream riwayat seluruh aktivitas yang selesai (terbaru ke terlama)
  Stream<List<Activity>> watchCompletedActivities() {
    return (select(activities)
          ..where((t) => t.status.equals('completed'))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .watch();
  }

  /// Ambil riwayat aktivitas selesai dengan filter sport
  Future<List<Activity>> getCompletedActivities({String? sportType}) {
    final query = select(activities)
      ..where((t) => t.status.equals('completed'));
    if (sportType != null) {
      query.where((t) => t.sportType.equals(sportType));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.startTime)]);
    return query.get();
  }

  /// Cari aktivitas yang belum selesai (Crash Recovery check)
  Future<Activity?> getUnfinishedActivity() {
    return (select(activities)
          ..where((t) => t.status.equals('inProgress'))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Hapus atau batalkan aktivitas
  Future<int> deleteActivity(String id) {
    return (delete(activities)..where((t) => t.id.equals(id))).go();
  }
}
