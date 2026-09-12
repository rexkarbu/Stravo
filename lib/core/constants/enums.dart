// Stravo Pro - Shared Enums
// Kontrak bersama antara Rouf & Rekan untuk memastikan konsistensi domain.

/// Jenis aktivitas olahraga luar ruangan yang didukung Stravo Pro
enum SportType {
  gravelCycling,
  roadCycling,
  mountainBiking,
  roadRunning,
  trailRunning,
  hiking,
  walking;

  String get displayName {
    switch (this) {
      case SportType.gravelCycling:
        return 'Gravel Ride';
      case SportType.roadCycling:
        return 'Road Cycling';
      case SportType.mountainBiking:
        return 'Mountain Bike (MTB)';
      case SportType.roadRunning:
        return 'Road Run';
      case SportType.trailRunning:
        return 'Trail Run';
      case SportType.hiking:
        return 'Hike';
      case SportType.walking:
        return 'Walk';
    }
  }

  bool get isCycling =>
      this == gravelCycling ||
      this == roadCycling ||
      this == mountainBiking;

  bool get isRunning => this == roadRunning || this == trailRunning;
}

/// Klasifikasi getaran permukaan jalan (Deteksi Accelerometer & Sensor Fusion)
enum SurfaceType {
  asphalt,
  smoothGravel,
  roughGravel,
  dirt,
  cobblestone,
  unknown;

  String get label {
    switch (this) {
      case SurfaceType.asphalt:
        return 'Aspal Mulus';
      case SurfaceType.smoothGravel:
        return 'Gravel Halus';
      case SurfaceType.roughGravel:
        return 'Gravel Kasar / Makadam';
      case SurfaceType.dirt:
        return 'Tanah / Singletrack';
      case SurfaceType.cobblestone:
        return 'Batu Bata / Paving';
      case SurfaceType.unknown:
        return 'Tidak Teridentifikasi';
    }
  }
}

/// Kategori Tanjakan (Climb Gradient Index)
enum ClimbCategory {
  flat, // < 3%
  cat4, // 3% - 5%
  cat3, // 5% - 8%
  cat2, // 8% - 11%
  cat1, // 11% - 15%
  hc; // Hors Catégorie (> 15% atau tanjakan ekstrem)

  String get label {
    switch (this) {
      case ClimbCategory.flat:
        return 'Datar';
      case ClimbCategory.cat4:
        return 'Cat 4 (Ringan)';
      case ClimbCategory.cat3:
        return 'Cat 3 (Sedang)';
      case ClimbCategory.cat2:
        return 'Cat 2 (Berat)';
      case ClimbCategory.cat1:
        return 'Cat 1 (Sangat Berat)';
      case ClimbCategory.hc:
        return 'Hors Catégorie (Ekstrem)';
    }
  }
}

/// Status Sesi Aktivitas Tracking
enum ActivityTrackingStatus {
  idle,
  recording,
  paused,
  stopped;
}
