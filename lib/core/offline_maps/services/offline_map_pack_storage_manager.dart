import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../models/offline_map_pack.dart';

/// Storage manager that scans, catalogues, and manages offline map pack
/// files (.mbtiles and .pmtiles) stored in internal/external device directories.
class OfflineMapPackStorageManager {
  final Directory? _defaultDirectory;
  final List<OfflineMapPack> _catalog = [];

  OfflineMapPackStorageManager({
    Directory? defaultDirectory,
  }) : _defaultDirectory = defaultDirectory;

  /// Returns an unmodifiable view of currently available/scanned map packs.
  List<OfflineMapPack> getAvailablePacks() => List.unmodifiable(_catalog);

  /// Retrieves a map pack by its unique [id], or null if not found.
  OfflineMapPack? getPackById(String id) {
    for (final pack in _catalog) {
      if (pack.id == id) return pack;
    }
    return null;
  }

  /// Finds all available map packs whose bounding box covers [lat] and [lng].
  List<OfflineMapPack> findPacksForCoordinate(double lat, double lng) {
    return _catalog.where((pack) => pack.containsCoordinate(lat, lng)).toList();
  }

  /// Scans the target storage directory for .mbtiles and .pmtiles map packs.
  ///
  /// Extracts header metadata using `sqlite3` for MBTiles, classifies layer
  /// types (terrainDem vs vector vs composite), and updates the internal catalog.
  Future<List<OfflineMapPack>> scanDirectory({Directory? targetDirectory}) async {
    final dir = targetDirectory ?? _defaultDirectory ?? await _resolveDefaultDirectory();

    if (!await dir.exists()) {
      _catalog.clear();
      return getAvailablePacks();
    }

    final entities = dir.listSync(followLinks: false);
    final scannedPacks = <OfflineMapPack>[];

    for (final entity in entities) {
      if (entity is! File) continue;

      final ext = p.extension(entity.path).toLowerCase();
      if (ext != '.mbtiles' && ext != '.pmtiles') continue;

      try {
        final pack = _parsePackFile(entity, ext);
        if (pack != null) {
          scannedPacks.add(pack);
        }
      } catch (_) {
        // Skip unreadable or corrupted files gracefully.
      }
    }

    _catalog
      ..clear()
      ..addAll(scannedPacks);

    return getAvailablePacks();
  }

  /// Deletes a map pack file from disk and removes it from the catalog.
  Future<bool> deletePack(String id) async {
    final pack = getPackById(id);
    if (pack == null) return false;

    try {
      final file = File(pack.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      _catalog.removeWhere((p) => p.id == id);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Internal File Parsers & Helpers
  // ---------------------------------------------------------------------------

  OfflineMapPack? _parsePackFile(File file, String ext) {
    final stat = file.statSync();
    final fileName = p.basename(file.path);
    final id = p.basenameWithoutExtension(file.path);

    if (ext == '.mbtiles') {
      return _parseMbtiles(file, id, fileName, stat);
    } else if (ext == '.pmtiles') {
      return _parsePmtiles(file, id, fileName, stat);
    }
    return null;
  }

  OfflineMapPack _parseMbtiles(
    File file,
    String id,
    String fileName,
    FileStat stat,
  ) {
    final metadata = <String, String>{};
    Database? db;

    try {
      db = sqlite3.open(file.path, mode: OpenMode.readOnly);
      final result = db.select('SELECT name, value FROM metadata');
      for (final row in result) {
        final name = row['name'];
        final value = row['value'];
        if (name is String && value is String) {
          metadata[name] = value;
        }
      }
    } catch (_) {
      // If metadata table is missing or unreadable, continue with filename heuristics
    } finally {
      try {
        db?.dispose();
      } catch (_) {}
    }

    final name = metadata['name'] ?? _formatHumanName(id);
    final formatStr = metadata['format']?.toLowerCase() ?? '';
    final minZoom = int.tryParse(metadata['minzoom'] ?? '');
    final maxZoom = int.tryParse(metadata['maxzoom'] ?? '');
    final bounds = _parseBounds(metadata['bounds']);

    final lowerName = name.toLowerCase();
    final lowerFile = fileName.toLowerCase();

    final isDemFormat = formatStr == 'png' ||
        formatStr == 'webp' ||
        lowerName.contains('dem') ||
        lowerName.contains('terrain') ||
        lowerFile.contains('dem') ||
        lowerFile.contains('terrain');

    final isVectorFormat = formatStr == 'pbf' ||
        lowerName.contains('vector') ||
        lowerFile.contains('vector') ||
        metadata['type'] == 'overlay';

    MapPackLayerType layerType;
    if (isDemFormat && isVectorFormat) {
      layerType = MapPackLayerType.composite;
    } else if (isDemFormat) {
      layerType = MapPackLayerType.terrainDem;
    } else {
      layerType = MapPackLayerType.vector;
    }

    return OfflineMapPack(
      id: id,
      name: name,
      filePath: file.path,
      format: MapPackFormat.mbtiles,
      layerType: layerType,
      sizeBytes: stat.size,
      lastModified: stat.modified,
      hasTerrainDem: layerType == MapPackLayerType.terrainDem ||
          layerType == MapPackLayerType.composite,
      hasVector: layerType == MapPackLayerType.vector ||
          layerType == MapPackLayerType.composite,
      minZoom: minZoom,
      maxZoom: maxZoom,
      bounds: bounds,
      metadata: metadata,
    );
  }

  OfflineMapPack _parsePmtiles(
    File file,
    String id,
    String fileName,
    FileStat stat,
  ) {
    final lowerFile = fileName.toLowerCase();
    final isDem = lowerFile.contains('dem') || lowerFile.contains('terrain');
    final isVector = lowerFile.contains('vector') || !isDem;

    MapPackLayerType layerType;
    if (isDem && lowerFile.contains('vector')) {
      layerType = MapPackLayerType.composite;
    } else if (isDem) {
      layerType = MapPackLayerType.terrainDem;
    } else {
      layerType = MapPackLayerType.vector;
    }

    return OfflineMapPack(
      id: id,
      name: _formatHumanName(id),
      filePath: file.path,
      format: MapPackFormat.pmtiles,
      layerType: layerType,
      sizeBytes: stat.size,
      lastModified: stat.modified,
      hasTerrainDem: isDem,
      hasVector: isVector,
      metadata: const {'format': 'pmtiles'},
    );
  }

  static List<double>? _parseBounds(String? boundsStr) {
    if (boundsStr == null || boundsStr.trim().isEmpty) return null;
    final parts = boundsStr.split(',');
    if (parts.length < 4) return null;
    final parsed = <double>[];
    for (final p in parts) {
      final val = double.tryParse(p.trim());
      if (val == null) return null;
      parsed.add(val);
    }
    return parsed;
  }

  static String _formatHumanName(String id) {
    return id
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Future<Directory> _resolveDefaultDirectory() async {
    try {
      final appDoc = await getApplicationDocumentsDirectory();
      return Directory(p.join(appDoc.path, 'Stravo', 'maps'));
    } catch (_) {
      return Directory('/storage/emulated/0/Stravo/maps');
    }
  }
}
