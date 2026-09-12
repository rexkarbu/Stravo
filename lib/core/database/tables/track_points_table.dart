import 'package:drift/drift.dart';
import 'package:stravo/core/database/tables/activities_table.dart';

/// Tabel TrackPoints: Menyimpan breadcrumb GPS 1Hz dan telemetri sensor
class TrackPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get activityId =>
      text().references(Activities, #id, onDelete: KeyAction.cascade)();
  IntColumn get sequenceIdx => integer()();
  DateTimeColumn get timestamp => dateTime()();

  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitudeMeters => real()();
  RealColumn get accuracyMeters => real()();
  RealColumn get speedMps => real()();
  RealColumn get bearingDegrees => real().withDefault(const Constant(0.0))();
  RealColumn get gradePct => real().withDefault(const Constant(0.0))();

  TextColumn get surfaceType => text().withDefault(const Constant('unknown'))();
  RealColumn get vibrationRaw => real().withDefault(const Constant(0.0))();

  IntColumn get heartRate => integer().nullable()();
  IntColumn get cadence => integer().nullable()();
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
}
