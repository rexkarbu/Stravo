import 'package:drift/drift.dart';
import 'package:stravo/core/database/app_database.dart';
import 'package:stravo/core/database/tables/track_points_table.dart';

part 'track_points_dao.g.dart';

@DriftAccessor(tables: [TrackPoints])
class TrackPointsDao extends DatabaseAccessor<AppDatabase>
    with _$TrackPointsDaoMixin {
  TrackPointsDao(super.db);

  /// Masukkan satu titik koordinat GPS
  Future<int> insertTrackPoint(TrackPointsCompanion entry) =>
      into(trackPoints).insert(entry);

  /// Masukkan sekumpulan titik sekaligus (Batch Commit tiap 5 detik)
  Future<void> insertBatchTrackPoints(List<TrackPointsCompanion> entries) {
    return batch((batch) {
      batch.insertAll(trackPoints, entries);
    });
  }

  /// Ambil seluruh titik koordinat untuk suatu aktivitas (diurutkan berdasarkan waktu/sequence)
  Future<List<TrackPoint>> getPointsForActivity(String activityId) {
    return (select(trackPoints)
          ..where((t) => t.activityId.equals(activityId))
          ..orderBy([(t) => OrderingTerm.asc(t.sequenceIdx)]))
        .get();
  }

  /// Watch stream titik koordinat untuk aktivitas aktif
  Stream<List<TrackPoint>> watchPointsForActivity(String activityId) {
    return (select(trackPoints)
          ..where((t) => t.activityId.equals(activityId))
          ..orderBy([(t) => OrderingTerm.asc(t.sequenceIdx)]))
        .watch();
  }

  /// Hitung total titik yang tersimpan untuk satu aktivitas
  Future<int> countPointsForActivity(String activityId) async {
    final countExp = trackPoints.id.count();
    final query = selectOnly(trackPoints)
      ..where(trackPoints.activityId.equals(activityId))
      ..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }
}
