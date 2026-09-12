import 'package:drift/drift.dart';
import 'package:stravo/core/database/app_database.dart';
import 'package:stravo/core/database/tables/gears_table.dart';

part 'gears_dao.g.dart';

@DriftAccessor(tables: [Gears])
class GearsDao extends DatabaseAccessor<AppDatabase> with _$GearsDaoMixin {
  GearsDao(super.db);

  /// Ambil daftar sepeda/sepatu yang aktif
  Future<List<Gear>> getActiveGears() {
    return (select(gears)
          ..where((t) => t.isRetired.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.isDefault)]))
        .get();
  }

  /// Watch daftar sepeda/sepatu aktif
  Stream<List<Gear>> watchActiveGears() {
    return (select(gears)
          ..where((t) => t.isRetired.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.isDefault)]))
        .watch();
  }

  /// Tambah gear baru ke garasi
  Future<void> insertGear(GearsCompanion entry) => into(gears).insert(entry);

  /// Tambahkan jarak tempuh ke odometer gear setelah aktivitas selesai
  Future<void> addDistanceToGear(String gearId, double distanceMeters) async {
    final gear = await (select(gears)..where((t) => t.id.equals(gearId))).getSingleOrNull();
    if (gear != null) {
      final newDistance = gear.totalDistanceMeters + distanceMeters;
      await (update(gears)..where((t) => t.id.equals(gearId))).write(
        GearsCompanion(totalDistanceMeters: Value(newDistance)),
      );
    }
  }

  /// Set default gear
  Future<void> setDefaultGear(String gearId) async {
    await (update(gears)).write(const GearsCompanion(isDefault: Value(false)));
    await (update(gears)..where((t) => t.id.equals(gearId))).write(
      const GearsCompanion(isDefault: Value(true)),
    );
  }
}
