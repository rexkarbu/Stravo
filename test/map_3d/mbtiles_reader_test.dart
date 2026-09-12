import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:stravo/features/map_3d/mbtiles/mbtiles_reader.dart';
import 'package:stravo/features/map_3d/server/demo_pack_manager.dart';
import 'package:stravo/features/map_3d/server/local_tile_server.dart';

void main() {
  group('1. XYZ to TMS conversion math', () {
    test('zoom 0: single tile, y=0 -> tmsY=0', () {
      expect(MbtilesReader.xyzToTmsY(0, 0), equals(0));
    });

    test('zoom 1: y=0 -> tmsY=1, y=1 -> tmsY=0', () {
      expect(MbtilesReader.xyzToTmsY(1, 0), equals(1));
      expect(MbtilesReader.xyzToTmsY(1, 1), equals(0));
    });

    test('zoom 12: Kamojang y=2129 -> tmsY=1966', () {
      expect(MbtilesReader.xyzToTmsY(12, 2129), equals(1966));
    });

    test('zoom 13: Kamojang y=4258 -> tmsY=3933', () {
      expect(MbtilesReader.xyzToTmsY(13, 4258), equals(3933));
    });
  });

  group('2. Terrarium elevation encoding math', () {
    const base = -32768.0;
    const interval = 0.00390625; // 1/256

    double decodeTerrarium(int r, int g, int b) {
      return (r * 256.0 + g + b / 256.0) + base;
    }

    List<int> encodeTerrarium(double elev) {
      final val = ((elev - base) / interval).round();
      final r = (val >> 16) & 0xFF;
      final g = (val >> 8) & 0xFF;
      final b = val & 0xFF;
      return [r, g, b];
    }

    test('Sea level 0m: RGB (128, 0, 0)', () {
      final rgb = encodeTerrarium(0.0);
      expect(rgb, equals([128, 0, 0]));
      expect(decodeTerrarium(rgb[0], rgb[1], rgb[2]), equals(0.0));
    });

    test('Kamojang center 1585m: decoded value matches within interval', () {
      final rgb = encodeTerrarium(1585.0);
      final decoded = decodeTerrarium(rgb[0], rgb[1], rgb[2]);
      expect(decoded, closeTo(1585.0, interval));
    });

    test('Mount Everest 8848m: roundtrip accurate', () {
      final rgb = encodeTerrarium(8848.0);
      final decoded = decodeTerrarium(rgb[0], rgb[1], rgb[2]);
      expect(decoded, closeTo(8848.0, interval));
    });

    test('Dead Sea -413m: roundtrip accurate', () {
      final rgb = encodeTerrarium(-413.0);
      final decoded = decodeTerrarium(rgb[0], rgb[1], rgb[2]);
      expect(decoded, closeTo(-413.0, interval));
    });
  });

  group('3. SQLite MBTiles Fixture Integration Tests', () {
    late Directory tempDir;
    late String mbtilesPath;
    final sampleVectorData = Uint8List.fromList(gzip.encode([1, 2, 3, 4]));

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('stravo_mbtiles_test_');
      mbtilesPath = p.join(tempDir.path, 'test.mbtiles');

      final db = sqlite3.open(mbtilesPath);
      db.execute('CREATE TABLE metadata (name text, value text);');
      db.execute(
          'CREATE TABLE tiles (zoom_level integer, tile_column integer, tile_row integer, tile_data blob);');
      db.execute(
          'CREATE UNIQUE INDEX tile_index ON tiles (zoom_level, tile_column, tile_row);');

      db.execute(
          "INSERT INTO metadata VALUES ('name', 'Test Pack'), ('format', 'pbf'), ('minzoom', '11'), ('maxzoom', '13');");

      final tmsY = MbtilesReader.xyzToTmsY(12, 2129);
      final stmt = db.prepare(
          'INSERT INTO tiles (zoom_level, tile_column, tile_row, tile_data) VALUES (?, ?, ?, ?)');
      stmt.execute([12, 3274, tmsY, sampleVectorData]);
      stmt.dispose();
      db.dispose();
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('MbtilesReader opens and reads metadata correctly', () {
      final reader = MbtilesReader.open(mbtilesPath);
      final meta = reader.getMetadata();
      expect(meta['name'], equals('Test Pack'));
      expect(meta['format'], equals('pbf'));
      expect(meta['minzoom'], equals('11'));
      reader.close();
    });

    test('MbtilesReader fetches existing tile with XYZ -> TMS mapping', () {
      final reader = MbtilesReader.open(mbtilesPath);
      final tile = reader.getTile(12, 3274, 2129);
      expect(tile, isNotNull);
      expect(tile, equals(sampleVectorData));
      reader.close();
    });

    test('MbtilesReader returns null for non-existent tile', () {
      final reader = MbtilesReader.open(mbtilesPath);
      final tile = reader.getTile(12, 9999, 9999);
      expect(tile, isNull);
      reader.close();
    });
  });

  group('4. LocalTileServer Integration Tests', () {
    late Directory tempDir;
    late String vectorMbtilesPath;
    late String demMbtilesPath;
    late String staticDir;
    late String engineDir;
    late LocalTileServer server;

    final rawPayload = [0x08, 0x01, 0x12, 0x04, 0x74, 0x65, 0x73, 0x74];
    final gzippedPbfBytes = Uint8List.fromList(gzip.encode(rawPayload));

    final pngBytes = Uint8List.fromList([
      0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, // PNG magic
      0x00, 0x00, 0x00, 0x0d, 0x49, 0x48, 0x44, 0x52,
    ]);

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('stravo_server_test_');
      vectorMbtilesPath = p.join(tempDir.path, 'vector.mbtiles');
      demMbtilesPath = p.join(tempDir.path, 'dem.mbtiles');
      staticDir = p.join(tempDir.path, 'static');
      engineDir = p.join(tempDir.path, 'engine');

      Directory(staticDir).createSync(recursive: true);
      Directory(engineDir).createSync(recursive: true);

      final vDb = sqlite3.open(vectorMbtilesPath);
      vDb.execute('CREATE TABLE metadata (name text, value text);');
      vDb.execute(
          'CREATE TABLE tiles (zoom_level integer, tile_column integer, tile_row integer, tile_data blob);');
      final tmsY = MbtilesReader.xyzToTmsY(12, 2129);
      final stmt1 = vDb.prepare('INSERT INTO tiles VALUES (?, ?, ?, ?)');
      stmt1.execute([12, 3274, tmsY, gzippedPbfBytes]);
      stmt1.dispose();
      vDb.dispose();

      final dDb = sqlite3.open(demMbtilesPath);
      dDb.execute('CREATE TABLE metadata (name text, value text);');
      dDb.execute(
          'CREATE TABLE tiles (zoom_level integer, tile_column integer, tile_row integer, tile_data blob);');
      final stmt2 = dDb.prepare('INSERT INTO tiles VALUES (?, ?, ?, ?)');
      stmt2.execute([12, 3274, tmsY, pngBytes]);
      stmt2.dispose();
      dDb.dispose();

      File(p.join(staticDir, 'style.json'))
          .writeAsStringSync('{"tiles": "{{BASE_URL}}/tiles/dem"}');

      File(p.join(engineDir, 'maplibre-gl.js'))
          .writeAsStringSync('console.log("mock maplibre");');

      server = LocalTileServer();
      await server.start(
        mbtilesPaths: {
          'vector': vectorMbtilesPath,
          'dem': demMbtilesPath,
        },
        staticDir: staticDir,
        engineDir: engineDir,
      );
    });

    tearDown(() async {
      await server.stop();
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('Tile endpoint returns 200 with gzip headers for gzipped vector tiles',
        () async {
      final client = HttpClient();
      final req = await client
          .getUrl(Uri.parse('${server.baseUrl}/tiles/vector/12/3274/2129.pbf'));
      final resp = await req.close();

      expect(resp.statusCode, equals(200));
      expect(resp.headers.value('content-type'),
          equals('application/x-protobuf'));
      expect(resp.headers.value('content-encoding'), equals('gzip'));

      final body = await resp.fold<List<int>>(
          <int>[], (buffer, data) => buffer..addAll(data));
      expect(body, equals(rawPayload));
      client.close();
    });

    test('Tile endpoint returns 200 with image/png for raster-dem tiles',
        () async {
      final client = HttpClient();
      final req = await client
          .getUrl(Uri.parse('${server.baseUrl}/tiles/dem/12/3274/2129.png'));
      final resp = await req.close();

      expect(resp.statusCode, equals(200));
      expect(resp.headers.value('content-type'), equals('image/png'));
      client.close();
    });

    test('Tile endpoint returns 404 for missing tiles (never fake 200)',
        () async {
      final client = HttpClient();
      final req = await client
          .getUrl(Uri.parse('${server.baseUrl}/tiles/vector/12/9999/9999.pbf'));
      final resp = await req.close();

      expect(resp.statusCode, equals(404));
      client.close();
    });

    test('Style endpoint replaces {{BASE_URL}} with server address', () async {
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse('${server.baseUrl}/style.json'));
      final resp = await req.close();

      expect(resp.statusCode, equals(200));
      final bodyStr = await resp.transform(utf8.decoder).join();
      expect(bodyStr, contains(server.baseUrl));
      expect(bodyStr, isNot(contains('{{BASE_URL}}')));
      client.close();
    });

    test('Missing glyph returns 404 (never fake empty 200)', () async {
      final client = HttpClient();
      final req = await client.getUrl(
          Uri.parse('${server.baseUrl}/glyphs/Open%20Sans%20Regular/0-255.pbf'));
      final resp = await req.close();

      expect(resp.statusCode, equals(404));
      client.close();
    });

    test('Engine endpoint serves maplibre-gl.js', () async {
      final client = HttpClient();
      final req = await client
          .getUrl(Uri.parse('${server.baseUrl}/engine/maplibre-gl.js'));
      final resp = await req.close();

      expect(resp.statusCode, equals(200));
      expect(
          resp.headers.value('content-type'), equals('application/javascript'));
      client.close();
    });
  });

  group('5. DemoPackManager Checksum & Verification Tests', () {
    late Directory tempDir;
    late DemoPackManager manager;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('stravo_pack_test_');
      manager = DemoPackManager();
    });

    tearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('computeFileHash returns correct SHA-256 for known file', () async {
      final testFile = File(p.join(tempDir.path, 'test.txt'));
      const testContent = 'Stravo Pro Offline 3D Maps';
      testFile.writeAsStringSync(testContent);

      final expectedHash = sha256.convert(utf8.encode(testContent)).toString();
      final actualHash = await manager.computeFileHash(testFile.path);

      expect(actualHash, equals(expectedHash));
    });

    test('computeFileHash returns empty string for non-existent file', () async {
      final hash =
          await manager.computeFileHash(p.join(tempDir.path, 'nonexistent'));
      expect(hash, isEmpty);
    });

    test('Ekstraksi awal extracts all assets and validates checksums against manifest', () async {
      final bundle = _createValidMockBundle();
      final packDir = p.join(tempDir.path, 'demo_pack', 'kamojang');
      final engineDir = p.join(tempDir.path, 'map_engine');
      final mgr = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: bundle);

      final resultPath = await mgr.initialize();
      expect(resultPath, equals(packDir));

      final assets = await mgr.checkAssets();
      expect(assets['dem.mbtiles'], isTrue);
      expect(assets['vector.mbtiles'], isTrue);
      expect(assets['style.json'], isTrue);
      expect(assets['manifest.json'], isTrue);
      expect(assets['0-255.pbf'], isTrue);
      expect(assets['maplibre-gl.js'], isTrue);
      expect(assets['maplibre-gl.css'], isTrue);

      expect(File(p.join(packDir, 'dem.mbtiles')).readAsStringSync(), equals('mock_dem_data_z11_z13'));
      expect(File(p.join(packDir, 'vector.mbtiles')).readAsStringSync(), equals('mock_vector_data_z11_z13'));
      expect(File(p.join(packDir, 'style.json')).readAsStringSync(), contains('mock_style'));

      await expectLater(mgr.validatePack(), completes);
    });

    test('Berkas existing valid skips redundant extraction and preserves files', () async {
      final bundle = _createValidMockBundle();
      final packDir = p.join(tempDir.path, 'demo_pack', 'kamojang');
      final engineDir = p.join(tempDir.path, 'map_engine');
      final mgr = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: bundle);

      await mgr.initialize();

      final demFile = File(p.join(packDir, 'dem.mbtiles'));
      final originalTimestamp = demFile.lastModifiedSync();

      // Delay slightly so a file write would produce a newer timestamp
      await Future.delayed(const Duration(milliseconds: 30));

      // Run initialize again on already verified files
      await mgr.initialize();

      expect(demFile.lastModifiedSync(), equals(originalTimestamp));
      await expectLater(mgr.validatePack(), completes);
    });

    test('Pembaruan aset lama safely updates outdated asset and passes validation', () async {
      final oldBundle = _createValidMockBundle(styleContent: '{"version": 7, "name": "outdated_style"}');
      final packDir = p.join(tempDir.path, 'demo_pack', 'kamojang');
      final engineDir = p.join(tempDir.path, 'map_engine');
      final mgr1 = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: oldBundle);

      await mgr1.initialize();
      expect(File(p.join(packDir, 'style.json')).readAsStringSync(), contains('outdated_style'));

      // New updated bundle with version 8 style
      const newStyle = '{"version": 8, "name": "updated_v8_style"}';
      final newBundle = _createValidMockBundle(styleContent: newStyle);
      final mgr2 = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: newBundle);

      await mgr2.initialize();

      expect(File(p.join(packDir, 'style.json')).readAsStringSync(), equals(newStyle));
      expect(File(p.join(packDir, 'style.json.bak')).existsSync(), isFalse);
      expect(File(p.join(packDir, 'style.json.tmp')).existsSync(), isFalse);
      await expectLater(mgr2.validatePack(), completes);
    });

    test('Checksum mismatch menolak aset, cleans temp file, and preserves target', () async {
      final validBundle = _createValidMockBundle();
      final packDir = p.join(tempDir.path, 'demo_pack', 'kamojang');
      final engineDir = p.join(tempDir.path, 'map_engine');
      final mgr = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: validBundle);

      await mgr.initialize();

      const originalDem = 'mock_dem_data_z11_z13';
      final demFile = File(p.join(packDir, 'dem.mbtiles'));
      expect(demFile.readAsStringSync(), equals(originalDem));

      // Create bundle where manifest expects a new hash, but bundle delivers corrupted bytes
      final mismatchedBundle = _createValidMockBundle(demContent: 'corrupted_dem_payload');
      final manifestMap = jsonDecode(mismatchedBundle._strings['assets/demo_pack/kamojang/manifest.json']!) as Map<String, dynamic>;
      manifestMap['sources']['dem']['sha256'] = 'expected_new_hash_different_from_corrupted';
      mismatchedBundle.putString('assets/demo_pack/kamojang/manifest.json', jsonEncode(manifestMap));

      final mgrMismatched = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: mismatchedBundle);

      await expectLater(
        () => mgrMismatched.initialize(),
        throwsA(isA<ChecksumMismatchException>().having(
          (e) => e.message,
          'message',
          contains('Checksum mismatch for'),
        )),
      );

      // Target dem.mbtiles was NOT overwritten with corrupted payload
      expect(demFile.readAsStringSync(), equals(originalDem));
      // Temp file was deleted on failure
      expect(File('${demFile.path}.tmp').existsSync(), isFalse);
    });

    test('Kegagalan penggantian file mempertahankan dan memulihkan file lama via rollback', () async {
      final validBundle = _createValidMockBundle();
      final packDir = p.join(tempDir.path, 'demo_pack', 'kamojang');
      final engineDir = p.join(tempDir.path, 'map_engine');

      final mgr = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: validBundle);
      await mgr.initialize();

      const originalDem = 'mock_dem_data_z11_z13';
      final demFile = File(p.join(packDir, 'dem.mbtiles'));
      expect(demFile.readAsStringSync(), equals(originalDem));

      // Attempt update with simulated disk error during rename
      const updatedDem = 'updated_dem_bytes_attempt';
      final updatedBundle = _createValidMockBundle(demContent: updatedDem);

      final failingMgr = DemoPackManager(
        packDir: packDir,
        engineDir: engineDir,
        bundle: updatedBundle,
        onRename: (source, target) async {
          if (target.endsWith('dem.mbtiles')) {
            throw const FileSystemException('Simulated disk error during atomic rename');
          }
          await source.rename(target);
        },
      );

      await expectLater(
        () => failingMgr.initialize(),
        throwsA(isA<StorageException>().having(
          (e) => e.message,
          'message',
          contains('Failed to atomically update'),
        )),
      );

      // Rollback restored original valid dem.mbtiles!
      expect(demFile.existsSync(), isTrue);
      expect(demFile.readAsStringSync(), equals(originalDem));
      expect(File('${demFile.path}.bak').existsSync(), isFalse);
      expect(File('${demFile.path}.tmp').existsSync(), isFalse);
    });

    test('validatePack detects corrupted file on disk and throws ChecksumMismatchException', () async {
      final bundle = _createValidMockBundle();
      final packDir = p.join(tempDir.path, 'demo_pack', 'kamojang');
      final engineDir = p.join(tempDir.path, 'map_engine');

      final mgr = DemoPackManager(packDir: packDir, engineDir: engineDir, bundle: bundle);
      await mgr.initialize();

      // Tamper with dem.mbtiles directly on disk
      File(p.join(packDir, 'dem.mbtiles')).writeAsStringSync('tampered_bytes_on_disk');

      await expectLater(
        () => mgr.validatePack(),
        throwsA(isA<ChecksumMismatchException>().having(
          (e) => e.filePath,
          'filePath',
          contains('dem.mbtiles'),
        )),
      );
    });

    test('ChecksumMismatchException formats expected and actual clearly', () {
      final ex = ChecksumMismatchException('file.mbtiles', 'hash_a', 'hash_b');
      expect(ex.message, contains('hash_a'));
      expect(ex.message, contains('hash_b'));
      expect(ex.toString(), contains('Checksum mismatch for file.mbtiles'));
    });

    test('AssetNotFoundException formats missing asset path', () {
      final ex = AssetNotFoundException('assets/missing.json');
      expect(ex.toString(),
          contains('Asset not found in bundle: assets/missing.json'));
    });
  });
}

/// Helper mock AssetBundle for testing
class _MockTestAssetBundle extends CachingAssetBundle {
  final Map<String, ByteData> _binary = {};
  final Map<String, String> _strings = {};

  void putString(String key, String content) {
    _strings[key] = content;
    final bytes = Uint8List.fromList(utf8.encode(content));
    _binary[key] = ByteData.sublistView(bytes);
  }

  @override
  Future<ByteData> load(String key) async {
    final data = _binary[key];
    if (data == null) throw AssetNotFoundException(key);
    return data;
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final str = _strings[key];
    if (str == null) throw AssetNotFoundException(key);
    return str;
  }
}

/// Creates a valid mock bundle with consistent SHA-256 manifest
_MockTestAssetBundle _createValidMockBundle({
  String demContent = 'mock_dem_data_z11_z13',
  String vectorContent = 'mock_vector_data_z11_z13',
  String styleContent = '{"version": 8, "name": "mock_style"}',
  String glyphContent = 'mock_glyph_font_bytes',
  String jsContent = 'console.log("mock maplibre 4.7.1");',
  String cssContent = '.maplibregl-map { position: relative; }',
}) {
  final bundle = _MockTestAssetBundle();

  String h(String s) => sha256.convert(utf8.encode(s)).toString();

  final manifest = {
    'version': 1,
    'name': 'Kamojang Mock Demo',
    'engine': {
      'files': {
        'maplibre-gl.js': {'sha256': h(jsContent)},
        'maplibre-gl.css': {'sha256': h(cssContent)},
      }
    },
    'style': {'sha256': h(styleContent)},
    'glyphs': {
      'Open Sans Regular': {'sha256': h(glyphContent)},
    },
    'sources': {
      'dem': {'sha256': h(demContent)},
      'vector': {'sha256': h(vectorContent)},
    }
  };

  bundle.putString('assets/demo_pack/kamojang/manifest.json', jsonEncode(manifest));
  bundle.putString('assets/map_engine/maplibre-gl.js', jsContent);
  bundle.putString('assets/map_engine/maplibre-gl.css', cssContent);
  bundle.putString('assets/demo_pack/kamojang/style.json', styleContent);
  bundle.putString('assets/demo_pack/kamojang/glyphs/Open Sans Regular/0-255.pbf', glyphContent);
  bundle.putString('assets/demo_pack/kamojang/dem.mbtiles', demContent);
  bundle.putString('assets/demo_pack/kamojang/vector.mbtiles', vectorContent);

  return bundle;
}
