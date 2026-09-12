import 'dart:typed_data';
import 'package:sqlite3/sqlite3.dart';

/// Reads tiles from an MBTiles file (SQLite) in read-only mode.
///
/// MBTiles spec uses TMS Y-axis (flipped from XYZ). This reader
/// handles the conversion transparently.
class MbtilesReader {
  final Database _db;
  final String path;

  MbtilesReader._(this._db, this.path);

  /// Opens an MBTiles file at [path] in read-only mode.
  factory MbtilesReader.open(String path) {
    final db = sqlite3.open(path, mode: OpenMode.readOnly);
    return MbtilesReader._(db, path);
  }

  /// Converts XYZ tile coordinate Y to TMS tile_row.
  /// Formula: tileRow = (1 << z) - 1 - y
  static int xyzToTmsY(int z, int y) {
    return (1 << z) - 1 - y;
  }

  /// Retrieves a tile by XYZ coordinates.
  /// Returns the raw tile bytes, or null if the tile doesn't exist.
  Uint8List? getTile(int z, int x, int y) {
    final tmsY = xyzToTmsY(z, y);
    final result = _db.select(
      'SELECT tile_data FROM tiles WHERE zoom_level = ? AND tile_column = ? AND tile_row = ?',
      [z, x, tmsY],
    );
    if (result.isEmpty) return null;
    final data = result.first['tile_data'];
    if (data is Uint8List) return data;
    if (data is List<int>) return Uint8List.fromList(data);
    return null;
  }

  /// Returns metadata from the MBTiles metadata table.
  Map<String, String> getMetadata() {
    final result = _db.select('SELECT name, value FROM metadata');
    final map = <String, String>{};
    for (final row in result) {
      map[row['name'] as String] = row['value'] as String;
    }
    return map;
  }

  /// Returns the format (pbf, png, jpg, webp) from metadata.
  String? get format {
    final meta = getMetadata();
    return meta['format'];
  }

  /// Closes the database connection.
  void close() {
    _db.dispose();
  }
}
