import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:stravo/core/offline_maps/models/offline_map_pack.dart';
import 'package:stravo/core/offline_maps/services/offline_map_pack_storage_manager.dart';

void main() {
  late Directory tempDir;
  late OfflineMapPackStorageManager manager;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('stravo_map_pack_test_');
    manager = OfflineMapPackStorageManager(defaultDirectory: tempDir);
  });

  tearDown(() {
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  /// Helper to create a test SQLite MBTiles database file.
  void createMockMbtiles({
    required String filename,
    required String name,
    required String format,
    String? bounds,
    String minzoom = '10',
    String maxzoom = '14',
  }) {
    final filePath = p.join(tempDir.path, filename);
    final db = sqlite3.open(filePath);
    db.execute('CREATE TABLE metadata (name text, value text);');

    final stmt = db.prepare('INSERT INTO metadata (name, value) VALUES (?, ?)');
    stmt.execute(['name', name]);
    stmt.execute(['format', format]);
    stmt.execute(['minzoom', minzoom]);
    stmt.execute(['maxzoom', maxzoom]);
    if (bounds != null) {
      stmt.execute(['bounds', bounds]);
    }
    stmt.dispose();
    db.dispose();
  }

  /// Helper to create an empty dummy file.
  void createDummyFile(String filename) {
    final file = File(p.join(tempDir.path, filename));
    file.writeAsStringSync('dummy content');
  }

  group('OfflineMapPack Model Tests', () {
    test('toMap and fromMap roundtrip preserves all fields', () {
      final pack = OfflineMapPack(
        id: 'kamojang_dem',
        name: 'Kamojang 3D Terrain',
        filePath: '/storage/maps/kamojang_dem.mbtiles',
        format: MapPackFormat.mbtiles,
        layerType: MapPackLayerType.terrainDem,
        sizeBytes: 15728640,
        lastModified: DateTime(2026, 9, 13, 12, 0),
        hasTerrainDem: true,
        hasVector: false,
        minZoom: 10,
        maxZoom: 14,
        bounds: const [107.75, -7.20, 107.85, -7.10],
        metadata: const {'attribution': 'Stravo Offline'},
      );

      final map = pack.toMap();
      final restored = OfflineMapPack.fromMap(map);

      expect(restored.id, equals(pack.id));
      expect(restored.name, equals(pack.name));
      expect(restored.filePath, equals(pack.filePath));
      expect(restored.format, equals(MapPackFormat.mbtiles));
      expect(restored.layerType, equals(MapPackLayerType.terrainDem));
      expect(restored.sizeBytes, equals(15728640));
      expect(restored.hasTerrainDem, isTrue);
      expect(restored.hasVector, isFalse);
      expect(restored.minZoom, equals(10));
      expect(restored.maxZoom, equals(14));
      expect(restored.bounds, equals([107.75, -7.20, 107.85, -7.10]));
      expect(restored.metadata['attribution'], equals('Stravo Offline'));
      expect(restored.formattedSize, contains('15.0 MB'));
    });

    test('containsCoordinate checks bounds accurately', () {
      final pack = OfflineMapPack(
        id: 'jabar',
        name: 'Jawa Barat',
        filePath: '/maps/jabar.mbtiles',
        format: MapPackFormat.mbtiles,
        layerType: MapPackLayerType.vector,
        sizeBytes: 1000,
        lastModified: DateTime.now(),
        hasTerrainDem: false,
        hasVector: true,
        bounds: const [106.0, -7.5, 108.5, -6.5],
      );

      // Coordinates inside box
      expect(pack.containsCoordinate(-7.0, 107.5), isTrue);
      expect(pack.containsCoordinate(-6.5, 106.0), isTrue); // On corner

      // Coordinates outside box
      expect(pack.containsCoordinate(-8.0, 107.5), isFalse); // Too far South
      expect(pack.containsCoordinate(-6.0, 107.5), isFalse); // Too far North
      expect(pack.containsCoordinate(-7.0, 105.0), isFalse); // Too far West
      expect(pack.containsCoordinate(-7.0, 109.0), isFalse); // Too far East
    });
  });

  group('OfflineMapPackStorageManager Tests', () {
    test('1. Scanning empty directory returns empty list', () async {
      final packs = await manager.scanDirectory();
      expect(packs, isEmpty);
      expect(manager.getAvailablePacks(), isEmpty);
    });

    test('2. Scanning detects mock .mbtiles file and reads metadata', () async {
      createMockMbtiles(
        filename: 'jawa_barat_vector.mbtiles',
        name: 'Jawa Barat Vektor',
        format: 'pbf',
        bounds: '106.5,-7.8,108.8,-6.2',
        minzoom: '8',
        maxzoom: '15',
      );

      final packs = await manager.scanDirectory();
      expect(packs.length, equals(1));

      final pack = packs.first;
      expect(pack.id, equals('jawa_barat_vector'));
      expect(pack.name, equals('Jawa Barat Vektor'));
      expect(pack.format, equals(MapPackFormat.mbtiles));
      expect(pack.layerType, equals(MapPackLayerType.vector));
      expect(pack.hasVector, isTrue);
      expect(pack.hasTerrainDem, isFalse);
      expect(pack.minZoom, equals(8));
      expect(pack.maxZoom, equals(15));
      expect(pack.bounds, equals([106.5, -7.8, 108.8, -6.2]));
      expect(pack.sizeBytes, greaterThan(0));
    });

    test('3. Correctly detects DEM raster vs vector layer types', () async {
      // Vector pack
      createMockMbtiles(
        filename: 'city_streets.mbtiles',
        name: 'City Streets',
        format: 'pbf',
      );

      // DEM Raster pack (format png with dem name)
      createMockMbtiles(
        filename: 'kamojang_dem.mbtiles',
        name: 'Kamojang DEM 3D',
        format: 'png',
      );

      final packs = await manager.scanDirectory();
      expect(packs.length, equals(2));

      final vectorPack = manager.getPackById('city_streets');
      expect(vectorPack, isNotNull);
      expect(vectorPack!.layerType, equals(MapPackLayerType.vector));
      expect(vectorPack.hasVector, isTrue);
      expect(vectorPack.hasTerrainDem, isFalse);

      final demPack = manager.getPackById('kamojang_dem');
      expect(demPack, isNotNull);
      expect(demPack!.layerType, equals(MapPackLayerType.terrainDem));
      expect(demPack.hasTerrainDem, isTrue);
      expect(demPack.hasVector, isFalse);
    });

    test('4. Scanning detects .pmtiles files and ignores non-map files', () async {
      createDummyFile('papandayan_dem.pmtiles');
      createDummyFile('unrelated_document.pdf');
      createDummyFile('notes.txt');

      final packs = await manager.scanDirectory();
      expect(packs.length, equals(1));

      final pmtilesPack = packs.first;
      expect(pmtilesPack.id, equals('papandayan_dem'));
      expect(pmtilesPack.format, equals(MapPackFormat.pmtiles));
      expect(pmtilesPack.hasTerrainDem, isTrue);
      expect(pmtilesPack.name, equals('Papandayan Dem'));
    });

    test('5. findPacksForCoordinate accurately filters packs by bounds', () async {
      // Pack 1: Kamojang area
      createMockMbtiles(
        filename: 'kamojang.mbtiles',
        name: 'Kamojang Area',
        format: 'pbf',
        bounds: '107.75,-7.20,107.85,-7.10',
      );

      // Pack 2: Bali area
      createMockMbtiles(
        filename: 'bali.mbtiles',
        name: 'Bali Island',
        format: 'pbf',
        bounds: '114.4,-8.9,115.7,-8.0',
      );

      await manager.scanDirectory();

      // Query inside Kamojang: lat -7.13, lng 107.80
      final kamojangMatches = manager.findPacksForCoordinate(-7.13, 107.80);
      expect(kamojangMatches.length, equals(1));
      expect(kamojangMatches.first.id, equals('kamojang'));

      // Query inside Bali: lat -8.40, lng 115.20
      final baliMatches = manager.findPacksForCoordinate(-8.40, 115.20);
      expect(baliMatches.length, equals(1));
      expect(baliMatches.first.id, equals('bali'));

      // Query in Jakarta: lat -6.20, lng 106.85 (neither)
      final jakartaMatches = manager.findPacksForCoordinate(-6.20, 106.85);
      expect(jakartaMatches, isEmpty);
    });

    test('6. deletePack deletes physical file and updates catalog', () async {
      createMockMbtiles(
        filename: 'to_delete.mbtiles',
        name: 'Temporary Pack',
        format: 'pbf',
      );

      final packsBefore = await manager.scanDirectory();
      expect(packsBefore.length, equals(1));
      final filePath = packsBefore.first.filePath;
      expect(File(filePath).existsSync(), isTrue);

      final deleted = await manager.deletePack('to_delete');
      expect(deleted, isTrue);
      expect(manager.getAvailablePacks(), isEmpty);
      expect(File(filePath).existsSync(), isFalse);

      // Deleting non-existent pack returns false
      expect(await manager.deletePack('non_existent'), isFalse);
    });
  });
}
