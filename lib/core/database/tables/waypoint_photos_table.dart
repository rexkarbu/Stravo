import 'package:drift/drift.dart';
import 'package:stravo/core/database/tables/activities_table.dart';

/// Tabel WaypointPhotos: Menyimpan foto-foto geotagged di rute
class WaypointPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get activityId =>
      text().references(Activities, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();

  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitudeMeters => real()();
  RealColumn get distanceFromStartMeters => real()();

  DateTimeColumn get takenAt => dateTime()();
  TextColumn get caption => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
