import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:stravo/core/database/daos/activities_dao.dart';
import 'package:stravo/core/database/daos/gears_dao.dart';
import 'package:stravo/core/database/daos/track_points_dao.dart';
import 'package:stravo/core/database/daos/waypoint_photos_dao.dart';
import 'package:stravo/core/database/tables/activities_table.dart';
import 'package:stravo/core/database/tables/gears_table.dart';
import 'package:stravo/core/database/tables/track_points_table.dart';
import 'package:stravo/core/database/tables/user_profile_table.dart';
import 'package:stravo/core/database/tables/waypoint_photos_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Activities, TrackPoints, WaypointPhotos, Gears, UserProfiles],
  daos: [ActivitiesDao, TrackPointsDao, WaypointPhotosDao, GearsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Konstruktor khusus untuk unit testing dan in-memory database
  AppDatabase.forTesting(super.e);

  /// Factory untuk in-memory SQLite database (sangat cepat untuk unit test)
  factory AppDatabase.memory() {
    return AppDatabase.forTesting(
      NativeDatabase.memory(),
    );
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Index performa tinggi untuk rute 3D, flyover, dan query realtime
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_trackpoints_activity_seq '
            'ON track_points (activity_id, sequence_idx ASC);',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_activities_sport_status '
            'ON activities (sport_type, status);',
          );
        },
        beforeOpen: (details) async {
          // Aktifkan Foreign Keys di SQLite
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// Fungsi pembuka koneksi file database lokal di storage internal ponsel
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'stravo_local.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Riverpod Providers untuk Dependency Injection
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final activitiesDaoProvider = Provider<ActivitiesDao>((ref) {
  return ref.watch(databaseProvider).activitiesDao;
});

final trackPointsDaoProvider = Provider<TrackPointsDao>((ref) {
  return ref.watch(databaseProvider).trackPointsDao;
});

final waypointPhotosDaoProvider = Provider<WaypointPhotosDao>((ref) {
  return ref.watch(databaseProvider).waypointPhotosDao;
});

final gearsDaoProvider = Provider<GearsDao>((ref) {
  return ref.watch(databaseProvider).gearsDao;
});
