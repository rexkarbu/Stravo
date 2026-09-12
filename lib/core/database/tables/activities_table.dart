import 'package:drift/drift.dart';

/// Tabel Activities: Menyimpan ringkasan sesi olahraga
class Activities extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get gearId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get sportType => text()(); // String representation of SportType enum
  TextColumn get status => text()(); // 'inProgress', 'completed', 'discarded'

  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();

  RealColumn get totalDistanceMeters =>
      real().withDefault(const Constant(0.0))();
  IntColumn get elapsedTimeSeconds =>
      integer().withDefault(const Constant(0))();
  IntColumn get movingTimeSeconds => integer().withDefault(const Constant(0))();

  RealColumn get elevationGainMeters =>
      real().withDefault(const Constant(0.0))();
  RealColumn get elevationLossMeters =>
      real().withDefault(const Constant(0.0))();
  RealColumn get maxElevationMeters =>
      real().withDefault(const Constant(0.0))();
  RealColumn get minElevationMeters =>
      real().withDefault(const Constant(0.0))();

  RealColumn get avgSpeedMps => real().withDefault(const Constant(0.0))();
  RealColumn get maxSpeedMps => real().withDefault(const Constant(0.0))();
  RealColumn get avgGapMps => real().nullable()();

  IntColumn get avgCadence => integer().nullable()();
  IntColumn get avgHeartRate => integer().nullable()();
  IntColumn get maxHeartRate => integer().nullable()();
  IntColumn get estimatedEnergyKj => integer().nullable()();

  RealColumn get gravelPercentage => real().withDefault(const Constant(0.0))();
  RealColumn get asphaltPercentage => real().withDefault(const Constant(0.0))();

  TextColumn get primaryPhotoPath => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
