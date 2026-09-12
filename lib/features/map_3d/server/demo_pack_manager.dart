import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Base exception for demo pack operations.
class DemoPackException implements Exception {
  final String message;
  const DemoPackException(this.message);

  @override
  String toString() => message;
}

/// Thrown when an expected asset is missing from the bundle.
class AssetNotFoundException extends DemoPackException {
  final String assetPath;
  AssetNotFoundException(this.assetPath)
      : super('Asset not found in bundle: $assetPath');
}

/// Thrown when a file fails SHA-256 validation.
class ChecksumMismatchException extends DemoPackException {
  final String filePath;
  final String expectedHash;
  final String actualHash;

  ChecksumMismatchException(this.filePath, this.expectedHash, this.actualHash)
      : super(
          'Checksum mismatch for $filePath\n'
          '  Expected: $expectedHash\n'
          '  Actual:   $actualHash',
        );
}

/// Thrown when storage or filesystem operations fail.
class StorageException extends DemoPackException {
  final dynamic cause;
  StorageException(String message, [this.cause])
      : super('Storage failure: $message${cause != null ? ' ($cause)' : ''}');
}

/// Manages extraction, safe updates, and SHA-256 verification of demo pack assets.
class DemoPackManager {
  static const String _packName = 'kamojang';
  static const String _assetBase = 'assets/demo_pack/$_packName';
  static const String _engineBase = 'assets/map_engine';

  String? _packDir;
  String? _engineLocalDir;
  Map<String, dynamic>? _manifest;
  final AssetBundle _bundle;

  /// Hook for testing atomic rename failure and rollback.
  final Future<void> Function(File source, String targetPath)? onRename;

  DemoPackManager({
    String? packDir,
    String? engineDir,
    AssetBundle? bundle,
    this.onRename,
  })  : _packDir = packDir,
        _engineLocalDir = engineDir,
        _bundle = bundle ?? rootBundle;

  /// The local filesystem path to the extracted pack directory.
  String get packDir => _packDir ?? '';

  /// The local filesystem path to the engine directory.
  String get engineDir => _engineLocalDir ?? '';

  /// The loaded manifest data.
  Map<String, dynamic>? get manifest => _manifest;

  /// Computes the SHA-256 hash of a file on disk.
  Future<String> computeFileHash(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return '';
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  /// Initializes the demo pack:
  /// 1. Reads manifest from asset bundle to obtain expected checksums.
  /// 2. Safely extracts files to storage using temporary files with rollback.
  /// 3. Validates all SHA-256 hashes against manifest before completing.
  Future<String> initialize() async {
    if (_packDir == null || _engineLocalDir == null) {
      final appDir = await getApplicationDocumentsDirectory();
      _packDir ??= p.join(appDir.path, 'demo_pack', _packName);
      _engineLocalDir ??= p.join(appDir.path, 'map_engine');
    }

    try {
      await Directory(_packDir!).create(recursive: true);
      await Directory(_engineLocalDir!).create(recursive: true);
      await Directory(p.join(_packDir!, 'glyphs', 'Open Sans Regular'))
          .create(recursive: true);
    } catch (e) {
      throw StorageException('Failed to create target directories', e);
    }

    // Load manifest from bundle first to know expected checksums
    String manifestStr;
    try {
      manifestStr = await _bundle.loadString('$_assetBase/manifest.json');
      _manifest = jsonDecode(manifestStr) as Map<String, dynamic>;
    } catch (e) {
      throw AssetNotFoundException('$_assetBase/manifest.json');
    }

    // Extract manifest to disk
    await _extractAsset(
      assetPath: '$_assetBase/manifest.json',
      targetPath: p.join(_packDir!, 'manifest.json'),
    );

    // Extract engine files with checksums from manifest
    final engineFiles = _manifest?['engine']?['files'] as Map<String, dynamic>?;
    final jsHash = engineFiles?['maplibre-gl.js']?['sha256'] as String?;
    final cssHash = engineFiles?['maplibre-gl.css']?['sha256'] as String?;

    if (jsHash == null || jsHash.isEmpty) {
      throw ChecksumMismatchException('maplibre-gl.js', 'VALID_SHA256', 'EMPTY');
    }
    if (cssHash == null || cssHash.isEmpty) {
      throw ChecksumMismatchException('maplibre-gl.css', 'VALID_SHA256', 'EMPTY');
    }

    await _extractAsset(
      assetPath: '$_engineBase/maplibre-gl.js',
      targetPath: p.join(_engineLocalDir!, 'maplibre-gl.js'),
      expectedSha256: jsHash,
    );
    await _extractAsset(
      assetPath: '$_engineBase/maplibre-gl.css',
      targetPath: p.join(_engineLocalDir!, 'maplibre-gl.css'),
      expectedSha256: cssHash,
    );

    // Extract style.json with checksum
    final styleHash = _manifest?['style']?['sha256'] as String?;
    if (styleHash == null || styleHash.isEmpty) {
      throw ChecksumMismatchException('style.json', 'VALID_SHA256', 'EMPTY');
    }

    await _extractAsset(
      assetPath: '$_assetBase/style.json',
      targetPath: p.join(_packDir!, 'style.json'),
      expectedSha256: styleHash,
    );

    // Extract glyphs with checksum
    final glyphsMeta = _manifest?['glyphs'] as Map<String, dynamic>?;
    final openSansMeta =
        glyphsMeta?['Open Sans Regular'] as Map<String, dynamic>?;
    final glyphHash = openSansMeta?['sha256'] as String?;

    if (glyphHash == null || glyphHash.isEmpty) {
      throw ChecksumMismatchException('glyphs/Open Sans Regular/0-255.pbf', 'VALID_SHA256', 'EMPTY');
    }

    await _extractAsset(
      assetPath: '$_assetBase/glyphs/Open Sans Regular/0-255.pbf',
      targetPath: p.join(_packDir!, 'glyphs', 'Open Sans Regular', '0-255.pbf'),
      expectedSha256: glyphHash,
    );

    // Extract MBTiles files with checksums
    final sources = _manifest?['sources'] as Map<String, dynamic>?;
    final demHash = sources?['dem']?['sha256'] as String?;
    final vectorHash = sources?['vector']?['sha256'] as String?;

    if (demHash == null || demHash.isEmpty) {
      throw ChecksumMismatchException('dem.mbtiles', 'VALID_SHA256', 'EMPTY');
    }
    if (vectorHash == null || vectorHash.isEmpty) {
      throw ChecksumMismatchException('vector.mbtiles', 'VALID_SHA256', 'EMPTY');
    }

    await _extractAsset(
      assetPath: '$_assetBase/dem.mbtiles',
      targetPath: p.join(_packDir!, 'dem.mbtiles'),
      expectedSha256: demHash,
    );
    await _extractAsset(
      assetPath: '$_assetBase/vector.mbtiles',
      targetPath: p.join(_packDir!, 'vector.mbtiles'),
      expectedSha256: vectorHash,
    );

    // Post-extraction integrity check
    await validatePack();

    return _packDir!;
  }

  /// Safely extracts an asset using temporary and backup files for atomic update.
  Future<void> _extractAsset({
    required String assetPath,
    required String targetPath,
    String? expectedSha256,
  }) async {
    final targetFile = File(targetPath);

    // 1. If target file already exists, check if it matches the expected hash
    if (await targetFile.exists()) {
      if (expectedSha256 != null && expectedSha256.isNotEmpty) {
        final existingHash = await computeFileHash(targetPath);
        if (existingHash == expectedSha256) {
          debugPrint('[DemoPackManager] File already verified: $targetPath');
          return;
        }
        debugPrint(
            '[DemoPackManager] Hash mismatch on existing file ($existingHash != $expectedSha256). Updating: $targetPath');
      }
    }

    // 2. Load from bundle
    Uint8List bytes;
    try {
      final byteData = await _bundle.load(assetPath);
      bytes = byteData.buffer.asUint8List();
    } catch (e) {
      throw AssetNotFoundException(assetPath);
    }

    // 3. Write to temporary file
    final tempPath = '$targetPath.tmp';
    final tempFile = File(tempPath);
    try {
      if (await tempFile.exists()) await tempFile.delete();
      await tempFile.writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw StorageException('Failed to write temp file: $tempPath', e);
    }

    // 4. Validate hash of temp file
    if (expectedSha256 != null && expectedSha256.isNotEmpty) {
      final tempHash = await computeFileHash(tempPath);
      if (tempHash != expectedSha256) {
        try {
          await tempFile.delete();
        } catch (_) {}
        throw ChecksumMismatchException(targetPath, expectedSha256, tempHash);
      }
    }

    // 5. Safe atomic update with backup recovery
    final bakPath = '$targetPath.bak';
    final bakFile = File(bakPath);
    try {
      if (await bakFile.exists()) await bakFile.delete();
      if (await targetFile.exists()) {
        await targetFile.rename(bakPath);
      }
      if (onRename != null) {
        await onRename!(tempFile, targetPath);
      } else {
        await tempFile.rename(targetPath);
      }
      if (await bakFile.exists()) {
        await bakFile.delete();
      }
    } catch (e) {
      // Clean up temp file if still present
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      // Rollback from backup if rename failed
      if (await bakFile.exists() && !await targetFile.exists()) {
        try {
          await bakFile.rename(targetPath);
        } catch (_) {}
      }
      throw StorageException('Failed to atomically update $targetPath', e);
    }
  }

  /// Verifies all extracted files against the manifest checksums.
  Future<void> validatePack() async {
    if (_manifest == null) {
      throw StorageException('Manifest is null during validation');
    }

    // Check dem.mbtiles
    final demHash = _manifest?['sources']?['dem']?['sha256'] as String?;
    if (demHash != null && demHash.isNotEmpty) {
      final actual = await computeFileHash(p.join(_packDir!, 'dem.mbtiles'));
      if (actual != demHash) {
        throw ChecksumMismatchException(
            p.join(_packDir!, 'dem.mbtiles'), demHash, actual);
      }
    }

    // Check vector.mbtiles
    final vectorHash = _manifest?['sources']?['vector']?['sha256'] as String?;
    if (vectorHash != null && vectorHash.isNotEmpty) {
      final actual = await computeFileHash(p.join(_packDir!, 'vector.mbtiles'));
      if (actual != vectorHash) {
        throw ChecksumMismatchException(
            p.join(_packDir!, 'vector.mbtiles'), vectorHash, actual);
      }
    }

    // Check style.json
    final styleHash = _manifest?['style']?['sha256'] as String?;
    if (styleHash != null && styleHash.isNotEmpty) {
      final actual = await computeFileHash(p.join(_packDir!, 'style.json'));
      if (actual != styleHash) {
        throw ChecksumMismatchException(
            p.join(_packDir!, 'style.json'), styleHash, actual);
      }
    }

    // Check glyphs
    final glyphsMeta = _manifest?['glyphs'] as Map<String, dynamic>?;
    final openSansMeta =
        glyphsMeta?['Open Sans Regular'] as Map<String, dynamic>?;
    final glyphHash = openSansMeta?['sha256'] as String?;
    if (glyphHash != null && glyphHash.isNotEmpty) {
      final actual = await computeFileHash(
          p.join(_packDir!, 'glyphs', 'Open Sans Regular', '0-255.pbf'));
      if (actual != glyphHash) {
        throw ChecksumMismatchException(
            p.join(_packDir!, 'glyphs', 'Open Sans Regular', '0-255.pbf'),
            glyphHash,
            actual);
      }
    }
  }

  /// Returns paths to verified MBTiles files.
  Map<String, String> getMbtilesPaths() {
    final paths = <String, String>{};
    final demPath = p.join(_packDir!, 'dem.mbtiles');
    final vectorPath = p.join(_packDir!, 'vector.mbtiles');

    if (File(demPath).existsSync()) {
      paths['dem'] = demPath;
    }
    if (File(vectorPath).existsSync()) {
      paths['vector'] = vectorPath;
    }
    return paths;
  }

  /// Checks if all required assets are present and valid on disk.
  Future<Map<String, bool>> checkAssets() async {
    return {
      'style.json': await File(p.join(_packDir!, 'style.json')).exists(),
      'manifest.json': await File(p.join(_packDir!, 'manifest.json')).exists(),
      'vector.mbtiles':
          await File(p.join(_packDir!, 'vector.mbtiles')).exists(),
      'dem.mbtiles': await File(p.join(_packDir!, 'dem.mbtiles')).exists(),
      '0-255.pbf': await File(
              p.join(_packDir!, 'glyphs', 'Open Sans Regular', '0-255.pbf'))
          .exists(),
      'maplibre-gl.js':
          await File(p.join(_engineLocalDir!, 'maplibre-gl.js')).exists(),
      'maplibre-gl.css':
          await File(p.join(_engineLocalDir!, 'maplibre-gl.css')).exists(),
    };
  }

  /// Extracts an asset with verification and atomic update (visible for testing).
  @visibleForTesting
  Future<void> extractAssetForTesting({
    required String assetPath,
    required String targetPath,
    String? expectedSha256,
  }) =>
      _extractAsset(
        assetPath: assetPath,
        targetPath: targetPath,
        expectedSha256: expectedSha256,
      );

  /// Sets manifest directly for unit testing validation flows.
  @visibleForTesting
  void setManifestForTesting(Map<String, dynamic> manifest) {
    _manifest = manifest;
  }
}
