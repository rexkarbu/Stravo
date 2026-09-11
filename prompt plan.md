# Product Requirements Document & Technical Architecture Plan

## Stravo Pro (Personal Edition) — 100% Offline, Zero-Server Outdoor Fitness & 3D GPS Tracker

**Platform:** Android (Primary Target) / Cross-platform Ready (Flutter)  
**Framework:** Flutter 3.38+ / Dart 3.10+  
**Status:** Active Blueprint & Engineering Specification  
**Arsitektur Inti:** **100% Standalone On-Device / Zero-Server (Serverless Lokal / Pure Edge Computing)**  
**Target Penggunaan:** Aplikasi Pribadi Berkualitas Pro (Meniru & Menggratiskan Fitur-Fitur Premium Strava Subscription & Relive Tanpa Server & Tanpa Biaya)  

---

# 1. Product Vision & Filosofi 100% Offline

Membangun aplikasi pelacak olahraga outdoor (khususnya **Gravel Cycling**, **Road Cycling**, **Trail Running**, **Road Running**, dan **Hiking**) yang menghadirkan pengalaman kelas atas setara **Strava Subscription / Summit** dan **Relive Pro** secara **100% MANDIRI DI DALAM HP (Zero-Server / Standalone)**.

### Prinsip Utama:
1. **Zero-Server & Zero-Cloud Dependency**: Tidak ada server backend, tidak ada database cloud berbayar (No Firebase, No Supabase, No AWS). Seluruh logic, database, pemrosesan sensor, dan rendering video berjalan 100% di chipset dan memori smartphone.
2. **True Offline GPS & Navigation**: GPS berjalan langsung via chipset satelit hardware HP (GNSS: GPS, GLONASS, Galileo, BeiDou) tanpa memerlukan koneksi internet, paket data, atau sinyal seluler. Tetap bekerja sempurna di tengah hutan belantara, lereng gunung, atau jalur gravel pelosok.
3. **Offline 3D Vector Maps & Terrain**: Menggunakan format file peta lokal **MBTiles / PMTiles** dan raster Digital Elevation Model (DEM) offline. Peta dan elevasi 3D dimuat langsung dari storage internal ponsel.
4. **On-Device Video & Footage Rendering**: Pembuatan animasi 3D flyover dan video rekap media sosial diproses langsung oleh GPU/CPU ponsel menggunakan Flutter Canvas & native hardware video encoder (`ffmpeg_kit_flutter` / Android MediaCodec).
5. **On-Device Gravel & Sensor Analytics**: Analisis getaran permukaan jalan (*roughness/surface detection*) dihitung langsung dari data accelerometer ponsel dan atribut peta offline.
6. **Kedaulatan Data Penuh (Data Sovereignty)**: Data pengguna 100% milik pengguna, tersimpan aman di SQLite lokal (`drift`), dengan fitur ekspor/impor universal (GPX, TCX, FIT, JSON Backup) langsung ke memori HP.

---

# 2. Perbandingan Fitur: Strava Premium vs Stravo Pro (100% Offline Lokal)

| Fitur | Strava (Wajib Langganan & Butuh Server) | Stravo Pro (100% Offline, Zero-Server di HP) |
| :--- | :--- | :--- |
| **Ketergantungan Server** | Wajib login server, data tersimpan di cloud Strava | **Zero-Server**: Berjalan mandiri di HP tanpa akun online |
| **Peta 3D & Terrain Topografi** | Terkunci di tier berbayar & butuh internet cepat | **MapLibre 3D + Offline MBTiles / DEM Tiles** (berfungsi tanpa sinyal di pelosok gunung) |
| **Video Replay / Route Flyover** | Berbayar (Relive/Strava) & di-render di cloud server | **On-Device 3D Flyover & Video Maker** langsung via GPU ponsel |
| **Personal Heatmap** | Berbayar bulanan/tahunan di server Strava | **Personal Heatmap 2D/3D** di-render instan dari SQLite lokal HP |
| **Live Segments & Ghost Pacer** | Terkunci di tier premium | **Custom Segment Matcher + Ghost Competitor** lokal di device |
| **Analisis Permukaan Gravel** | Terbatas & estimasi server | **Vibration Analyzer (Accelerometer HP) + Offline Surface Profiling** |
| **Grade Adjusted Pace (GAP)** | Berbayar | **Kalkulator GAP offline bawaan** untuk tanjakan & turunan |
| **Penyimpanan & Privasi Data** | Di cloud perusahaan | **100% Privat di HP**, ekspor/impor file GPX/FIT/TCX bebas |

---

# 3. Arsitektur 100% Offline & Komputasi On-Device

Semua fungsionalitas yang biasanya membutuhkan server dipindahkan ke pemrosesan internal smartphone:

### 3.1 Hardware Satelit GPS Murni (Tanpa Paket Data)
- Ponsel Android modern memiliki antena penerima multi-GNSS independen.
- Aplikasi membaca stream koordinat langsung dari hardware GPS internal dengan frekuensi 1 Hz (1 koordinat per detik).
- Penghitungan kecepatan, jarak lengkung bumi (*Haversine / Vincenty geodesy*), dan arah kompas (*bearing*) dihitung dengan rumus matematika native di Dart tanpa memanggil API eksternal.

### 3.2 Offline Map Engine (MBTiles / PMTiles & Offline Tile Cache)
- Peta tidak memerlukan koneksi internet aktif saat beraktivitas:
  - **Paket Peta Offline (MBTiles / PMTiles)**: File tunggal berbasis SQLite berisi tile vektor OpenStreetMap yang dapat ditaruh di memori HP (misalnya peta area Jawa Barat, Bali, atau provinsi tempat tinggal).
  - **Tile Cache Otomatis**: Saat pengguna terhubung ke Wi-Fi di rumah, peta yang pernah dilihat otomatis tersimpan di cache disk internal HP dan siap dipakai offline di rute tanpa sinyal.
  - **Offline 3D Terrain DEM**: Ketinggian kontur gunung dimuat dari tile raster DEM (Terrarium / Mapzen) yang tersimpan di storage lokal.

### 3.3 Sensor Fusion Internal & Bluetooth Low Energy (BLE)
- **Barometer Internal**: Untuk HP yang memiliki sensor barometer, elevasi dihitung langsung dari tekanan udara atmosfer lokal (sangat akurat, deviasi < 1 meter) tanpa butuh data elevasi internet.
- **Accelerometer & Gyroscope**:
  - Deteksi getaran permukaan jalan (*surface roughness*) untuk membedakan aspal mulus vs jalan makadam/gravel.
  - Estimasi *cadence* (langkah per menit untuk lari) saat HP di saku atau armband.
- **Koneksi BLE Sensor (Peer-to-Peer Tanpa Internet)**:
  - Tersambung langsung dengan *Heart Rate Strap*, *Cycling Speed Sensor*, dan *Cadence Sensor* melalui protokol Bluetooth standar.

### 3.4 On-Device Video Renderer (Auto-Footage)
- Biasanya aplikasi seperti Relive mengunggah koordinat dan foto ke server mereka untuk di-render menjadi video di cloud.
- **Stravo Pro**: Merender frame demi frame animasi 3D lintasan dan pop-up foto langsung di HP menggunakan `CustomPainter` dan menyatukannya menjadi video MP4 memakai hardware video encoder internal HP (`ffmpeg_kit_flutter` / MediaCodec).

---

# 4. Kategori Olahraga & Metrik Spesifik (Gravel & Multi-Sport)

### 4.1 Gravel Cycling (Fitur Utama)
- **Metrik**: Kecepatan, Jarak, Waktu Bergerak (*Moving Time*), Elevasi, VAM (*Vertical Ascent Meters/hour*).
- **Offline Surface Detection**:
  - Memanfaatkan sensor getaran accelerometer internal HP (analisis spektrum frekuensi getaran) dipadukan dengan data jalan lokal:
    - Aspal Mulus (Low vibration)
    - Gravel Halus / Tanah Padat (Moderate steady vibration)
    - Gravel Kasar / Makadam / Bebatuan (High amplitude random vibration)
- **Climb Gradient Index**: Pemetaan tanjakan berwarna:
  - Hijau: 0% – 4% (False Flat)
  - Kuning: 5% – 8% (Moderate Climb)
  - Oranye: 9% – 12% (Hard Climb)
  - Merah / Ungu: >13% (Extreme Wall)

### 4.2 Road Cycling
- Kecepatan instan, kecepatan rata-rata, kecepatan puncak.
- Estimasi daya tahan (*Estimated Power output* dalam watt) dihitung secara fisika lokal: daya gesek ban (*rolling resistance*), hambatan aerodinamis (*drag coefficient*), dan kemiringan jalan.

### 4.3 Mountain Biking (MTB)
- Evaluasi kecuraman turunan (*Descent Steepness %*), total turunan teknikal, dan elevasi ekstrem.

### 4.4 Road Running & Trail Running
- **Pace**: Waktu/km (misal `4:45 /km`) dengan moving-window smoothing.
- **Grade Adjusted Pace (GAP)**: Rumus fisiologis Minetti/Strava untuk menghitung ekuivalen pace datar saat menanjak atau menurun.
- **Split Per Kilometer**: Notifikasi audio lokal via Android Text-to-Speech (TTS) tanpa butuh internet.

### 4.5 Hiking & Walking
- Kecepatan vertikal menanjak (*ascent rate* m/jam), rasio waktu istirahat vs bergerak, dan puncak ketinggian.

---

# 5. Fitur GPS 3D, Animasi Rute & Peta Offline

## 5.1 3D Terrain Map Offline
- Menggunakan engine **MapLibre GL Native** dengan source offline vector + raster DEM.
- Pengguna dapat:
  - Memiringkan peta (*pitch 45°–60°*) untuk melihat gunung dan lembah dalam 3D asli.
  - Memutar peta 360° (*bearing rotation*) mengikuti arah hadap olahraga.

## 5.2 Interactive 3D Route Flyover (Replay Animasi Rute)
- Mode peninjauan aktivitas pasca-olahraga:
  - Tombol **"3D Flyover Replay"**.
  - Kamera bergerak otomatis menelusuri rute GPS dari Start hingga Finish secara halus menggunakan interpolasi kurva Bézier.
  - Kamera melakukan gerakan sinematik: memutar di tikungan tajam, mendekat di tanjakan terjal, dan menampilkan pemandangan luas di puncak elevasi.
  - **Live Telemetry HUD**: Kotak overlay transparan menampilkan kecepatan, elevasi, dan jarak tempuh yang sinkron dengan posisi kamera.
  - Kontrol interaktif: Play, Pause, Scrubbing Slider, dan kecepatan pemutaran (1x, 2x, 4x, 8x).

## 5.3 Color-Coded Polylines Dinamis
Garis lintasan di peta dapat diwarnai berdasarkan:
1. **Speed Heat**: Gradien dingin ke hangat (Biru = Santai &rarr; Hijau &rarr; Kuning &rarr; Merah = Sprint).
2. **Elevation Gradient**: Gradien warna ketinggian dari titik terendah ke tertinggi.
3. **Surface Type**: Hijau (Aspal), Oranye (Gravel), Cokelat (Tanah).

## 5.4 Personal Heatmap (2D & 3D Offline)
- Menggabungkan seluruh jalur aktivitas pengguna di dalam SQLite lokal menjadi layer heatmap bercahaya.
- Tidak ada data yang dikirim ke server luar; proses kalkulasi dilakukan di memori HP.
- Filter per kategori: Heatmap Gravel, Heatmap Lari, atau Semua.

## 5.5 Live Segments & Ghost Competitor (Offline Virtual Pacer)
- Pengguna membuat segmen rute sendiri di peta lokal (contoh: "Tanjakan Bukit X 1.5 km").
- Saat melintasi titik awal segmen secara offline:
  - Aplikasi otomatis mendeteksi segmen aktif menggunakan spatial bounding box.
  - Menampilkan selisih waktu real-time terhadap waktu terbaik (*Personal Record - PR*) pengguna di segmen tersebut.
  - Audio TTS lokal: *"Kamu 2 detik di depan Ghost Pacer!"*.

---

# 6. In-Ride Media & Auto-Footage Generator (100% On-Device)

## 6.1 Foto Waypoint Ter-Geotag Otomatis
- Tombol cepat kamera di layar tracking.
- Foto disimpan langsung di galeri/storage lokal HP dengan metadata koordinat GPS, ketinggian, dan kilometer tempuh.
- Pin foto muncul otomatis di atas garis rute 3D.

## 6.2 Generator Video Rekap Animasi (MP4/GIF Lokal)
- Pengguna menekan tombol **"Generate Footage"**.
- HP langsung merender video rekap 15–45 detik secara lokal:
  1. Intro judul aktivitas dan tanggal.
  2. Animasi rute 3D berjalan dengan garis menyala (*animated tracer*).
  3. Pop-up foto waypoint muncul saat animasi melewati lokasi foto diambil.
  4. Grafik profil elevasi bergerak di bagian bawah layar.
  5. Layar ringkasan akhir: Jarak, Elevasi, Durasi, Kecepatan Maksimum.
- Hasil video MP4 tersimpan langsung di folder galeri HP untuk siap dibagikan ke media sosial.

## 6.3 Dynamic Social Story Cards (Rasio 9:16 & 1:1)
- Generator kartu visual modern beresolusi tinggi langsung dari widget Flutter:
  - **Dark Neon Theme**: Rute berpendar neon dengan latar belakang gelap kontras.
  - **Gravel Topo Theme**: Garis kontur topografi dengan statistik jenis permukaan jalan.
  - **Minimalist Athletic Theme**: Tipografi bersih modern ala Strava Pro.
- Tombol langsung ekspor ke gambar PNG beresolusi tinggi untuk Instagram Stories, WhatsApp Status, atau TikTok.

---

# 7. Keandalan Tracking Latar Belakang & Jaminan Zero Data Loss

## 7.1 Android Foreground Service & Wakelock
- Layanan latar belakang dengan notifikasi persisten (`flutter_foreground_task`).
- Menjaga CPU tetap aktif via `PARTIAL_WAKE_LOCK` agar pelacakan tidak mati saat layar dikunci atau HP masuk kantong.
- Panduan panduan pengaturan baterai HP (agar OS seperti MIUI/OneUI tidak mematikan service).

## 7.2 Filter Kualitas GPS & Sensor Fusion
- **Accuracy Gate**: Mengabaikan titik dengan horizontal accuracy > 18 meter.
- **Speed Plausibility**: Menyaring lonjakan data akibat pantulan sinyal (*multipath error* di gedung/pepohonan).
- **Kalman Filtering**: Menghaluskan garis rute agar tidak bergerigi atau zig-zag.
- **Smart Auto-Pause**: Otomatis menjeda waktu saat berhenti dan melanjutkan kembali saat bergerak.

## 7.3 Pemulihan Crash & Baterai Habis (*Incremental Local Flush*)
- Setiap 5–10 detik, koordinat GPS baru langsung ditulis (*commit*) ke SQLite internal.
- Jika ponsel mati mendadak atau kehabisan baterai:
  - Saat ponsel dinyalakan kembali dan Stravo dibuka, aplikasi langsung mendeteksi sesi yang belum selesai.
  - Pengguna dapat memilih untuk melanjutkan pelacakan atau menyimpan sesi tersebut.
  - Tidak ada data olahraga yang hilang (*0% Data Loss Guarantee*).

---

# 8. Arsitektur Modular & Struktur Direktori Project

```text
lib/
├── app/
│   ├── config/
│   │   ├── app_theme.dart          # Tema: Dark Neon, Stravo Orange, Topo
│   │   └── routes.dart
│   └── stravo_app.dart
│
├── core/
│   ├── constants/
│   ├── database/                   # Drift SQLite schema, migrations, spatial tables
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   └── daos/
│   ├── offline_maps/               # Pengelola MBTiles, PMTiles & Tile Caching Lokal
│   │   ├── mbtiles_service.dart
│   │   └── tile_cache_manager.dart
│   ├── location/                   # GPS Streamer, Kalman Filter, Auto-Pause
│   │   ├── gps_engine.dart
│   │   ├── kalman_filter.dart
│   │   └── auto_pause_detector.dart
│   ├── permissions/                # Android 10+ background permission flow
│   ├── sensors/                    # Barometer internal & BLE Heart Rate / Cadence
│   │   ├── barometer_sensor.dart
│   │   ├── accelerometer_vibration.dart
│   │   └── ble_sensor_manager.dart
│   ├── utils/                      # Geo math, unit converters, formatting
│   └── backup/                     # Offline JSON / SQLite full database backup
│
├── features/
│   ├── recording/                  # Layar pencatatan live
│   │   ├── data/
│   │   ├── domain/models/
│   │   └── presentation/
│   │       ├── screens/recording_screen.dart
│   │       └── widgets/live_telemetry_hud.dart
│   │
│   ├── map_3d/                     # Peta 3D & Replay Animasi
│   │   ├── controllers/camera_3d_controller.dart
│   │   ├── widgets/terrain_3d_map.dart
│   │   └── widgets/flyover_player.dart
│   │
│   ├── footage_generator/          # Generator Video Rekap (MP4) & Story Cards Lokal
│   │   ├── services/on_device_video_renderer.dart
│   │   ├── painters/route_canvas_painter.dart
│   │   └── presentation/story_card_exporter_sheet.dart
│   │
│   ├── gravel_analytics/           # Analisis Getaran Permukaan Jalan & Tanjakan
│   │   ├── vibration_surface_classifier.dart
│   │   ├── climb_gradient_calculator.dart
│   │   └── wind_resistance_analyzer.dart
│   │
│   ├── heatmap/                    # Personal Heatmap 2D & 3D Lokal
│   │   ├── heatmap_tile_generator.dart
│   │   └── presentation/personal_heatmap_screen.dart
│   │
│   ├── segments/                   # Live Segments & Ghost Competitor
│   │   ├── segment_matcher.dart
│   │   ├── ghost_pacer_engine.dart
│   │   └── presentation/segment_hud_widget.dart
│   │
│   ├── activity_history/           # Riwayat aktivitas & detail
│   │   ├── presentation/activity_list_screen.dart
│   │   └── presentation/activity_detail_screen.dart
│   │
│   ├── dashboard/                  # Statistik mingguan/bulanan & PR offline
│   └── profile/                    # Profil & manajemen sepeda (Gravel, Road, MTB)
│
├── services/
│   ├── background/                 # Android Foreground Service handler
│   │   └── background_task_handler.dart
│   ├── audio_cues/                 # Android Text-To-Speech (TTS) lokal
│   └── export_import/              # Universal GPX / FIT / TCX parsers
│
└── main.dart
```

---

# 9. Rencana Fase Pengembangan (Roadmap Eksekusi)

### Phase 1: Rock-Solid Offline Tracking Engine (Fondasi Utama)
- Integrasi `geolocator` dan `flutter_foreground_task`.
- Filter akurasi GPS satelit, Kalman smoothing, dan deteksi auto-pause.
- Notifikasi persisten Android dengan timer live dan kontrol Pause/Resume.
- Drift SQLite incremental flush: jaminan 0% data hilang saat crash.

### Phase 2: Domain Multi-Sport & Sensor Accelerometer/Gravel
- Model data multi-sport: Gravel Cycling, Road Cycling, MTB, Road Run, Trail Run, Hike.
- Analisis getaran accelerometer ponsel untuk mendeteksi permukaan jalan (aspal vs gravel).
- Perhitungan Grade Adjusted Pace (GAP) dan Gradient Index tanjakan sepeda.
- Integrasi sensor Barometer internal dan BLE (Heart Rate & Cadence).

### Phase 3: Peta 3D & Terrain Offline (MBTiles / Vector Tile Cache)
- Setup **MapLibre GL** dengan dukungan offline MBTiles / PMTiles dan raster DEM lokal.
- Pengaturan tilt 3D, rotasi 360°, dan hillshading topografi.
- Dynamic polyline rendering: pewarnaan rute berdasarkan kecepatan (*Speed Heat*), elevasi, atau permukaan jalan.

### Phase 4: Cinematic 3D Route Flyover (Replay Animasi Rute)
- Pemutar animasi rute dengan pergerakan kamera dinamis yang mengikuti rute GPS secara offline.
- Floating HUD telemetri (kecepatan, gradien tanjakan, elevasi berjalan).
- Kontrol pemutaran video interaktif (Play, Pause, Scrubbing, Speed Multiplier).

### Phase 5: In-Ride Photos & On-Device Auto-Footage Generator
- Quick photo capture saat berolahraga dengan auto-geotagging & elevasi.
- Video generator on-device (`ffmpeg_kit_flutter` / Skia Canvas) untuk menghasilkan video rekap MP4 animasi rute + pop-up foto langsung di HP tanpa server.
- Generator kartu visual media sosial (9:16 Story Cards & 1:1 Feed Cards) dengan berbagai tema desain modern.

### Phase 6: Fitur Map Premium Ekstra (Personal Heatmap & Live Segments)
- Personal Heatmap 2D & 3D di-render langsung dari database SQLite lokal.
- Custom Live Segments dengan fitur **Virtual Ghost Competitor** & audio cues lokal via TTS.
- Universal GPX/FIT/TCX Export & Import langsung ke penyimpanan ponsel.

---

# 10. Indikator Keberhasilan (Definition of Success)

1. **100% Serverless & Offline**: Seluruh fitur (perekaman GPS, peta 3D, personal heatmap, segmen, pembuatan video rekap) dapat berjalan sempurna dalam mode pesawat (*Airplane Mode*) tanpa koneksi internet sama sekali.
2. **Stabilitas Latar Belakang**: 0% sesi terputus saat layar mati selama beraktivitas 1 hingga 5 jam.
3. **Akurasi Data**: Jarak dan elevasi selaras dengan unit GPS terdedikasi (Garmin / Wahoo) dengan deviasi < 3%.
4. **Performa Rendering Lokal**: Video rekap MP4 30 detik selesai di-render di HP dalam waktu kurang dari 45 detik.
5. **Privasi & Nol Biaya**: Tidak ada akun online, tidak ada data pribadi yang keluar dari ponsel pengguna, dan Rp 0 biaya operasional selamanya.
