import 'package:drift/drift.dart';

/// Tabel UserProfiles: Data atlet offline lokal
class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text()();
  RealColumn get weightKg => real().withDefault(const Constant(70.0))();
  IntColumn get maxHeartRate => integer().withDefault(const Constant(190))();
  IntColumn get ftpWatts => integer().nullable()();
  TextColumn get preferredUnit =>
      text().withDefault(const Constant('metric'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
