import 'package:drift/drift.dart';

/// Tabel Gears: Garasi sepeda dan sepatu
class Gears extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get gearType => text()(); // 'gravelBike', 'roadBike', 'mtb', 'runningShoes'
  TextColumn get brandModel => text().nullable()();

  RealColumn get totalDistanceMeters =>
      real().withDefault(const Constant(0.0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isRetired => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
