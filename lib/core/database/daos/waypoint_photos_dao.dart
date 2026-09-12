import 'package:drift/drift.dart';
import 'package:stravo/core/database/app_database.dart';
import 'package:stravo/core/database/tables/waypoint_photos_table.dart';

part 'waypoint_photos_dao.g.dart';

@DriftAccessor(tables: [WaypointPhotos])
class WaypointPhotosDao extends DatabaseAccessor<AppDatabase>
    with _$WaypointPhotosDaoMixin {
  WaypointPhotosDao(super.db);

  /// Simpan foto geotag baru
  Future<void> insertPhoto(WaypointPhotosCompanion entry) =>
      into(waypointPhotos).insert(entry);

  /// Ambil seluruh foto untuk aktivitas tertentu (urut berdasarkan kilometer tempuh)
  Future<List<WaypointPhoto>> getPhotosForActivity(String activityId) {
    return (select(waypointPhotos)
          ..where((t) => t.activityId.equals(activityId))
          ..orderBy([(t) => OrderingTerm.asc(t.distanceFromStartMeters)]))
        .get();
  }

  /// Hapus foto
  Future<int> deletePhoto(String photoId) {
    return (delete(waypointPhotos)..where((t) => t.id.equals(photoId))).go();
  }
}
