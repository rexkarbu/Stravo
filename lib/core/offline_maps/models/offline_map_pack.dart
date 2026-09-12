import 'package:flutter/foundation.dart';

/// Supported offline map pack packaging formats.
enum MapPackFormat {
  mbtiles,
  pmtiles;

  static MapPackFormat fromExtension(String ext) {
    final clean = ext.toLowerCase().replaceAll('.', '');
    if (clean == 'pmtiles') return MapPackFormat.pmtiles;
    return MapPackFormat.mbtiles;
  }
}

/// Type of map data layer contained in the pack.
enum MapPackLayerType {
  terrainDem,
  vector,
  composite;

  String get displayName {
    switch (this) {
      case MapPackLayerType.terrainDem:
        return 'Raster 3D DEM (Elevasi)';
      case MapPackLayerType.vector:
        return 'Peta Vektor';
      case MapPackLayerType.composite:
        return 'Komposit (Vektor + DEM)';
    }
  }
}

/// Metadata and catalog descriptor for an offline map pack file.
@immutable
class OfflineMapPack {
  /// Unique identifier (usually filename without extension).
  final String id;

  /// Human-readable name (e.g. "Kamojang Topo 3D", "Jawa Barat").
  final String name;

  /// Absolute file system path to the map pack file.
  final String filePath;

  /// Packaging format (mbtiles or pmtiles).
  final MapPackFormat format;

  /// Layer type (terrainDem, vector, or composite).
  final MapPackLayerType layerType;

  /// File size on disk in bytes.
  final int sizeBytes;

  /// Last modification timestamp.
  final DateTime lastModified;

  /// Whether the pack contains raster DEM tiles for 3D elevation.
  final bool hasTerrainDem;

  /// Whether the pack contains vector map tiles.
  final bool hasVector;

  /// Minimum zoom level supported.
  final int? minZoom;

  /// Maximum zoom level supported.
  final int? maxZoom;

  /// Geographic bounding box: [minLng, minLat, maxLng, maxLat].
  final List<double>? bounds;

  /// Additional metadata key-values extracted from MBTiles/PMTiles headers.
  final Map<String, String> metadata;

  const OfflineMapPack({
    required this.id,
    required this.name,
    required this.filePath,
    required this.format,
    required this.layerType,
    required this.sizeBytes,
    required this.lastModified,
    required this.hasTerrainDem,
    required this.hasVector,
    this.minZoom,
    this.maxZoom,
    this.bounds,
    this.metadata = const {},
  });

  /// Size formatted as human-readable string (KB, MB, GB).
  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Checks if given [lat] and [lng] fall inside this pack's bounding box.
  bool containsCoordinate(double lat, double lng) {
    final b = bounds;
    if (b == null || b.length < 4) return false;
    final minLng = b[0];
    final minLat = b[1];
    final maxLng = b[2];
    final maxLat = b[3];
    return lng >= minLng && lng <= maxLng && lat >= minLat && lat <= maxLat;
  }

  /// Converts this instance to a map representation for caching or persistence.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'format': format.name,
      'layerType': layerType.name,
      'sizeBytes': sizeBytes,
      'lastModified': lastModified.toIso8601String(),
      'hasTerrainDem': hasTerrainDem,
      'hasVector': hasVector,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
      'bounds': bounds,
      'metadata': metadata,
    };
  }

  /// Deserializes an [OfflineMapPack] from a map.
  factory OfflineMapPack.fromMap(Map<String, dynamic> map) {
    return OfflineMapPack(
      id: map['id'] as String,
      name: map['name'] as String,
      filePath: map['filePath'] as String,
      format: MapPackFormat.values.byName(map['format'] as String),
      layerType: MapPackLayerType.values.byName(map['layerType'] as String),
      sizeBytes: (map['sizeBytes'] as num).toInt(),
      lastModified: DateTime.parse(map['lastModified'] as String),
      hasTerrainDem: map['hasTerrainDem'] as bool? ?? false,
      hasVector: map['hasVector'] as bool? ?? false,
      minZoom: (map['minZoom'] as num?)?.toInt(),
      maxZoom: (map['maxZoom'] as num?)?.toInt(),
      bounds: (map['bounds'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      metadata: (map['metadata'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          ) ??
          const {},
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineMapPack &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          filePath == other.filePath;

  @override
  int get hashCode => Object.hash(id, filePath);

  @override
  String toString() =>
      'OfflineMapPack(id: $id, name: $name, type: $layerType, size: $formattedSize)';
}
