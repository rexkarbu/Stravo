# Product Requirements Document & Technical Architecture Plan

## Stravo Pro (Personal Edition) — High-Performance Outdoor Fitness & 3D GPS Tracker

**Platform:** Android (Primary Target) / Cross-platform Ready (Flutter)  
**Framework:** Flutter 3.38+ / Dart 3.10+  
**Status:** Active Blueprint & Engineering Specification  
**Product Type:** Advanced GPS Fitness Tracker, 3D Terrain Visualizer, & Auto-Footage Creator  
**Target Penggunaan:** Aplikasi Pribadi Berkualitas Pro (Meniru & Menggratiskan Fitur-Fitur Premium Strava Subscription & Relive)  

---

# 1. Product Vision & Philosophy

Membangun aplikasi pelacak olahraga outdoor (khususnya **Gravel Cycling**, **Road Cycling**, **Trail Running**, **Road Running**, dan **Hiking**) yang menghadirkan pengalaman kelas atas setara **Strava Subscription / Summit** dan **Relive Pro** secara **100% GRATIS dan MANDIRI (Self-Sustained)**.

### Nilai Utama:
1. **Zero-Cost & Free-Tier Architecture**: Menghindari API komersial mahal (seperti Google Maps / Mapbox billing tinggi) dengan memanfaatkan **MapLibre GL**, **OpenStreetMap Vector Tiles**, **Open-Elevation / Terrarium RGB DEM**, dan pemrosesan offline lokal di perangkat.
2. **First-Class Gravel & Trail Experience**: Memperlakukan sepeda Gravel dan Trail Run secara khusus dengan analisis tipe permukaan jalan (*Tarmac, Gravel, Dirt, Cobbles*), profil tanjakan gradien berwarna (*climb grading*), dan *Grade Adjusted Pace (GAP)*.
3. **Cinematic 3D Terrain & Route Animation**: Visualisasi topografi 3D penuh layaknya Relive / FATMAP, dengan fitur flythrough kamera 3D interaktif yang menyusuri jalur GPS.
4. **Auto-Footage & Dynamic Social Share**: Generator video rekap (MP4/GIF) otomatis on-device yang menggabungkan animasi rute 3D, foto di titik koordinat (*waypoint photo popups*), telemetri live, serta kartu statistik estetik untuk Instagram Story & WhatsApp.
5. **Local-First & Rock-Solid Reliability**: Data tracking disimpan secara lokal (SQLite/Drift). Pelacakan di latar belakang (*background foreground service*) tidak boleh mati meski layar terkunci atau aplikasi diminimalkan.

---

# 2. Perbandingan Fitur: Strava Premium vs Stravo Pro (Gratis)

| Fitur | Strava (Wajib Langganan / Bayar) | Stravo Pro (100% Gratis & Lokal) |
| :--- | :--- | :--- |
| **Peta 3D & Terrain Topografi** | Terkunci di Strava Subscription (hanya rute tertentu) | **MapLibre 3D + DEM Terrarium Terrain** (bebas putar 360°, pitch, tilt, relief shading) |
| **Video Replay / Route Flyover** | Terbatas atau butuh aplikasi luar (Relive berbayar) | **Built-in 3D Route Flyover & Auto-Footage Generator** langsung di device |
| **Personal Heatmap** | Berbayar bulanan/tahunan | **Personal Heatmap Global & Per-Sport** gratis, di-render dari database SQLite lokal |
| **Live Segments & Ghost Pacer** | Terkunci di tier premium | **Custom Segment Engine + Virtual Ghost Competitor** lokal |
| **Analisis Permukaan Gravel** | Terbatas / estimasi kasar | **Surface Profiler**: Tarmac vs Gravel vs Trail dengan estimasi rolling resistance |
| **Grade Adjusted Pace (GAP)** | Berbayar | **Kalkulator GAP bawaan** untuk lari tanjakan/turunan |
| **Weather & Wind Overlay** | Hanya rangkuman dasar | **Open-Meteo Integration**: Arah angin real-time (Headwind vs Tailwind) di atas rute |
| **Export/Import Rute** | Terbatas | **Universal GPX, TCX, FIT** Import & Export tanpa batasan |

---

# 3. Kategori Olahraga & Metrik Spesifik

Aplikasi mendukung kategori olahraga yang disesuaikan secara presisi:

### 3.1 Gravel Cycling (Fitur Unggulan)
- **Metrik Utama**: Kecepatan, Jarak, Waktu Bergerak (*Moving Time*), Elevasi, VAM (*Vertical Ascent Meters/hour*).
- **Surface Breakdown**: Estimasi persentase permukaan rute:
  - Paved / Aspal (Smooth)
  - Fine Gravel / Compact Dirt (Fast Gravel)
  - Rough Gravel / Cobblestones / Rocky (Technical)
- **Climb Gradient Index**: Pemetaan tanjakan dengan kode warna:
  - Hijau: 0% – 4% (False Flat)
  - Kuning: 5% – 8% (Moderate Climb)
  - Oranye: 9% – 12% (Hard Climb)
  - Merah / Ungu: >13% (Extreme Wall)
- **Wind Impact Analyzer**: Penentuan sudut terpaan angin terhadap lintasan sepeda (*Headwind, Crosswind, Tailwind*).

### 3.2 Road Cycling
- Kecepatan instan, kecepatan rata-rata, kecepatan maksimum.
- Daya tahan (*Power estimation* dalam watt berdasarkan kecepatan, bobot badan + sepeda, dan kemiringan jalan).
- Dukungan sensor Bluetooth Low Energy (BLE): Speed, Cadence, dan Heart Rate monitor.

### 3.3 Mountain Biking (MTB)
- Evaluasi curamnya turunan (*Descent Steepness %*).
- Kalkulasi elevasi ekstrem dan rasio waktu tanjakan vs turunan.

### 3.4 Road Running & Trail Running
- **Pace**: Waktu/km (misal `4:45 /km`) dan moving average pace.
- **Grade Adjusted Pace (GAP)**: Menghitung kecepatan ekuivalen jika lari di lintasan datar (mengkompensasi energi saat menanjak/menurun).
- **Split Per Kilometer**: Notifikasi audio setiap kelipatan 1 km dengan laporan pace split.
- **Cadence Lari**: Estimasi langkah per menit (SPM) via accelerometer internal HP.

### 3.5 Hiking & Walking
- Kecepatan vertikal, waktu istirahat vs waktu jalan, profil ketinggian titik puncak (*Summit peak elevation*).

---

# 4. Fitur GPS 3D, Animasi Rute & Peta Premium

## 4.1 3D Terrain Map Engine
- Menggunakan **MapLibre GL** (open-source fork dari Mapbox GL) yang mendukung rendering 3D terrain berbasis raster DEM / Terrarium tiles.
- Pengguna dapat mengubah perspektif peta:
  - **2D Top-Down View**: Tampilan standar navigasi.
  - **3D Isometric Tilt**: Peta dimiringkan (pitch 45°–60°) menampilkan kontur gunung, lembah, dan bukit di sekitar rute.
  - **Relief Shading & Sun Shadowing**: Bayangan matahari berdasarkan waktu recording untuk estetika visual dramatis.

## 4.2 Interactive 3D Route Flyover (Animasi Rute Menyerupai Relive)
- Mode peninjauan aktivitas pasca-olahraga:
  - Tombol **"3D Flyover Replay"**.
  - Kamera bergerak otomatis menyusuri garis lintasan GPS dari garis Start hingga Finish.
  - Kamera menerapkan sudut sinematik: memutar saat belokan tajam (*hairpin turns*), mendekat (*zoom-in*) pada titik tanjakan terberat, dan melebar (*wide angle*) pada puncak elevasi tertinggi.
  - **Live Telemetry HUD**: Kotak indikator digital transparan menampilkan kecepatan, elevasi, detak jantung, dan jarak tempuh yang berjalan sinkron dengan posisi kamera.
  - Kontrol pemutaran: Play, Pause, Scrubbing Slider (geser ke kilometer berapa pun), dan opsi kecepatan (1x, 2x, 4x, 8x).

## 4.3 Color-Coded Dynamic Polylines
Jalur lintasan di peta dapat diubah visualisasinya berdasarkan layer data:
1. **Speed Heat**: Gradien warna dingin ke hangat (Biru = Lambat &rarr; Hijau &rarr; Kuning &rarr; Merah = Sprint Maksimum).
2. **Elevation Gradient**: Gradien ketinggian dari titik terendah hingga titik tertinggi.
3. **Surface Type**: Garis hijau (Aspal), garis oranye (Gravel), garis cokelat (Tanah/Trail).
4. **Heart Rate Zones**: Warna zona 1 hingga zona 5 (bila sensor denyut jantung tersambung).

## 4.4 Personal Heatmap (2D & 3D)
- Menampilkan seluruh jejak riwayat aktivitas pengguna yang digabungkan ke dalam satu peta kanvas.
- Garis rute yang sering dilewati akan bersinar lebih terang (*dense heat effect*).
- Filter per kategori: Heatmap Gravel saja, Heatmap Lari saja, atau Semua Aktivitas.
- Dihitung secara efisien langsung dari koordinat lokal di SQLite tanpa biaya server.

## 4.5 Live Segments & Ghost Competitor (Pacer Virtual)
- Pengguna dapat menandai segmen lintasan favorit (contoh: tanjakan 2 km di daerah favorit).
- Deteksi otomatis saat GPS pengguna memasuki titik awal segmen.
- Mode **Ghost Competitor**:
  - Menampilkan selisih waktu secara real-time terhadap waktu rekor pribadi (*Personal Record - PR*) pengguna di segmen tersebut.
  - Audio cues: *"Kamu 3 detik di depan PR"* atau *"Kamu tertinggal 5 meter dari Ghost Pacer"*.

---

# 5. In-Ride Media & Auto-Footage Generator

## 5.1 In-Activity Photo Waypoint Capture
- Tombol cepat kamera langsung pada layar tracking tanpa mengganggu perekaman GPS.
- Setiap foto yang diambil secara otomatis dibubuhi metadata:
  - Koordinat lintang/bujur akurat (*Geotag*).
  - Elevasi saat foto diambil.
  - Jarak kilometer ke berapa dan durasi berjalan.
- Foto muncul sebagai pin thumbnail interaktif di sepanjang garis peta 3D.

## 5.2 On-Device Auto-Footage Generator (Video Rekap Animasi)
- **Tujuan**: Menghasilkan video MP4 pendek (15–60 detik) atau GIF animasi yang siap dibagikan ke media sosial secara instan tanpa membutuhkan server rendering berbayar.
- **Mekanisme Rendering**:
  - Menggunakan Flutter Canvas / Skia frame buffer atau rendering offscreen yang digabungkan melalui library native (`ffmpeg_kit_flutter`).
  - Video menampilkan:
    1. Logo & Judul Aktivitas + Tanggal.
    2. Rute garis bergerak yang menyala (*dynamic animated polyline drawing*).
    3. Pop-up foto waypoint saat animasi rute melewati titik foto diambil.
    4. Animasi grafik elevasi di bagian bawah layar.
    5. Rekap akhir: Total Jarak, Total Elevasi, Waktu Tempuh, Kecepatan Maksimum, dan Kalori/Work.

## 5.3 Dynamic Social Story Cards (Instagram Stories / WhatsApp / TikTok)
- Generator kartu grafis beresolusi tinggi (rasio 9:16 untuk Stories dan 1:1 untuk Feed).
- Pilihan template desain visual modern:
  - **Dark Cyberpunk / Neon**: Garis rute neon oranye/cyan dengan latar belakang gelap kontras tinggi.
  - **Minimalist Topo**: Garis kontur topografi dengan tipografi elegan modern.
  - **Gravel Explorer**: Nuansa earthy tone dengan breakdown jenis permukaan jalan (Tarmac vs Dirt).
  - **Classic Athletic**: Estetika minimalis ala Strava/Nike Run Club.
- Kemudahan ekspor: Satu tombol langsung bagikan (*Share to Instagram Stories / WhatsApp*).

---

# 6. Core GPS Engine, Filtering & Background Reliability

Aplikasi secanggih apa pun akan gagal jika pencatatan GPS hilang saat layar mati. Modul GPS adalah prioritas stabilitas nomor satu.

## 6.1 Foreground Service & Battery Optimization
- Menggunakan Android Foreground Service dengan notifikasi persisten (`flutter_foreground_task`).
- Mengatur `PARTIAL_WAKE_LOCK` dan `WIFI_LOCK` agar CPU perangkat tidak tertidur saat layar dimatikan.
- UI onboarding khusus untuk memandu pengguna menonaktifkan *Battery Optimization / Smart Battery Saver* (terutama untuk merk Xiaomi MIUI/HyperOS, Samsung OneUI, Oppo/Vivo).

## 6.2 Filter Kualitas GPS & Sensor Fusion
Aplikasi tidak boleh menerima data GPS mentah yang berantakan (*noisy zig-zag*):
1. **Accuracy Threshold**: Abaikan titik dengan horizontal accuracy > 18 meter.
2. **Speed-Based Plausibility**: Abaikan lonjakan koordinat yang mengindikasikan kecepatan mustahil (misal > 90 km/jam untuk lari, > 140 km/jam untuk sepeda).
3. **Dead Reckoning & Stationary Filter**: Jika kecepatan mendekati nol selama lebih dari 5 detik, jangan menambahkan jarak acak akibat GPS drift.
4. **Kalman Filtering**: Menghaluskan titik koordinat (*smoothing curve*) sehingga visualisasi polyline di peta terlihat mulus layaknya rute profesional.

## 6.3 Auto-Pause Cerdas
- Mode auto-pause otomatis menghentikan timer saat pengguna berhenti di lampu merah atau istirahat.
- Threshold sensitivitas yang dapat diatur:
  - Cycling: Kecepatan < 2.5 km/jam selama 3 detik &rarr; Auto Pause.
  - Running: Kecepatan < 1.0 km/jam selama 3 detik &rarr; Auto Pause.
- Auto-resume instan saat terdeteksi pergerakan kembali.

## 6.4 Pemulihan Crash & Power Loss (*Zero Data Loss Principle*)
- Setiap titik GPS yang diterima langsung dicatat ke SQLite database dalam transaksi lokal secara inkremental (*incremental flush* setiap 5–10 detik).
- Jika HP mati mendadak atau kehabisan baterai di tengah jalan:
  - Saat aplikasi dibuka kembali, Stravo mendeteksi sesi yang belum selesai.
  - Pengguna diberikan dialog: *"Sesi latihan sebelumnya ditemukan. Lanjutkan atau Simpan?"*.
  - Tidak ada riwayat olahraga yang hilang.

---

# 7. Zero-Cost Infrastructure & Open-Source Stack

Seluruh aplikasi dirancang agar tidak menimbulkan biaya langganan cloud bagi pengembang maupun pengguna:

| Komponen | Pilihan Stack | Alasan & Keuntungan |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.38+ (Dart 3.10+) | Satu codebase, performa grafis tinggi dengan engine Impeller/Skia |
| **Peta & Visualisasi 3D** | `maplibre_gl` + Raster Terrain-RGB | Bebas lisensi, mendukung 3D terrain mesh, open-source |
| **Sumber Peta Gratis** | OpenStreetMap Vector Tiles / DemTiles / MapTiler Free Tier | Menggantikan biaya ribuan dollar Google Maps API |
| **Database Lokal** | `drift` (berbasis SQLite) | Query relasional super cepat, mendukung penyimpanan ribuan titik GPS dan index spasial R-Tree |
| **State Management** | `flutter_riverpod` | Arsitektur state teruji, decoupling sempurna antara logic GPS dan tampilan UI |
| **Background Location** | `flutter_foreground_task` + `geolocator` | Layanan latar belakang stabil di Android 10, 11, 12, 13, 14, 15+ |
| **Video & Footage Maker** | Custom Flutter Canvas + `ffmpeg_kit_flutter` | Rendering MP4 lokal langsung di prosesor perangkat |
| **Cuaca & Angin** | Open-Meteo API | 100% gratis untuk penggunaan non-komersial, tanpa butuh API key |
| **Elevasi Akurat** | Open-Elevation API / Local DEM fallback | Koreksi barometrik & elevasi rute gratis |
| **Sync Opsional** | Supabase (Free Tier / Self-hosted) atau Google Drive Backup | Cadangan cloud opsional tanpa membebani biaya developer |

---

# 8. Arsitektur Modular & Struktur Direktori

Struktur project memisahkan domain logic, core engine, services, dan UI secara modular:

```text
lib/
├── app/
│   ├── config/
│   │   ├── app_theme.dart          # Tema modern: Dark Neon, Stravo Orange, Topo
│   │   └── routes.dart
│   └── stravo_app.dart
│
├── core/
│   ├── constants/
│   ├── database/                   # Drift SQLite schema, migrations, spatial tables
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   └── daos/
│   ├── error/
│   ├── location/                   # Core GPS Streamer, Kalman Filter, Plausibility Check
│   │   ├── gps_engine.dart
│   │   ├── kalman_filter.dart
│   │   └── auto_pause_detector.dart
│   ├── permissions/                # Android 10+ background permission flow
│   ├── sensors/                    # BLE Cadence, Speed & Heart Rate Monitor
│   ├── utils/                      # Geo math, unit converters, formatting
│   └── weather/                    # Open-Meteo client (Wind direction & speed)
│
├── features/
│   ├── recording/                  # Sesi pencatatan live
│   │   ├── data/
│   │   ├── domain/models/
│   │   └── presentation/
│   │       ├── screens/recording_screen.dart
│   │       └── widgets/live_telemetry_hud.dart
│   │
│   ├── map_3d/                     # Modul Peta 3D & Replay
│   │   ├── controllers/camera_3d_controller.dart
│   │   ├── widgets/terrain_3d_map.dart
│   │   └── widgets/flyover_player.dart
│   │
│   ├── footage_generator/          # Generator Video Rekap & Story Cards
│   │   ├── services/video_render_service.dart
│   │   ├── painters/route_canvas_painter.dart
│   │   └── presentation/story_card_exporter_sheet.dart
│   │
│   ├── gravel_analytics/           # Modul Khusus Sepeda Gravel & Trail
│   │   ├── surface_classifier.dart
│   │   ├── climb_gradient_calculator.dart
│   │   └── wind_resistance_analyzer.dart
│   │
│   ├── heatmap/                    # Modul Personal Heatmap (2D & 3D)
│   │   ├── heatmap_tile_generator.dart
│   │   └── presentation/personal_heatmap_screen.dart
│   │
│   ├── segments/                   # Live Segments & Ghost Competitor
│   │   ├── segment_matcher.dart
│   │   ├── ghost_pacer_engine.dart
│   │   └── presentation/segment_hud_widget.dart
│   │
│   ├── activity_history/           # Riwayat, list filter, detail activity
│   │   ├── presentation/activity_list_screen.dart
│   │   └── presentation/activity_detail_screen.dart
│   │
│   ├── dashboard/                  # Ringkasan mingguan/bulanan, PR, fitness status
│   └── profile/                    # Profil user, gear/bike management (Gravel/Road)
│
├── services/
│   ├── background/                 # Android Foreground Service task handler
│   │   └── background_task_handler.dart
│   ├── audio_cues/                 # Text-to-speech feedback (split km, ghost pacer)
│   └── export_import/              # GPX / FIT / TCX parsers
│
└── main.dart
```

---

# 9. Rencana Fase Pengembangan (Roadmap Eksekusi)

### Phase 1: Rock-Solid Tracking Engine & Foreground Service (Fondasi Utama)
- Integrasi `geolocator` dan `flutter_foreground_task`.
- Implementasi filter akurasi GPS, Kalman smoothing, dan deteksi auto-pause.
- Notifikasi status persisten Android dengan timer live dan kontrol Pause/Resume.
- SQLite incremental flush: jaminan tidak ada data hilang saat crash.

### Phase 2: Domain Metrik Multi-Sport (Spesialisasi Gravel & Trail)
- Model data multi-sport: Gravel Cycling, Road Cycling, MTB, Road Run, Trail Run, Hike.
- Algoritma Surface Profiler (klasifikasi aspal, gravel, makadam/trail).
- Perhitungan Grade Adjusted Pace (GAP) untuk lari dan Gradient Index untuk tanjakan sepeda.
- Integrasi Open-Meteo untuk arah angin (Headwind / Tailwind).

### Phase 3: Peta 3D & Terrain Topografi
- Setup **MapLibre GL** dengan raster Digital Elevation Model (DEM) / Terrarium tiles.
- Pengaturan tilt 3D, rotasi 360°, dan hillshading kontur gunung.
- Dynamic polyline rendering: pewarnaan rute berdasarkan kecepatan (*Speed Heat*), elevasi (*Elevation Shading*), atau tipe permukaan.

### Phase 4: Cinematic 3D Route Flyover (Replay Animasi Rute)
- Pemutar animasi rute dengan pergerakan kamera dinamis yang mengikuti rute GPS.
- Floating HUD telemetri (kecepatan, gradien tanjakan, elevasi berjalan).
- Kontrol pemutaran video interaktif (Play, Pause, Scrubbing, Speed Multiplier).

### Phase 5: In-Ride Photos & Auto-Footage Video Generator
- Quick photo capture saat gowes/lari dengan auto-geotagging & elevasi.
- Video generator on-device (`ffmpeg_kit_flutter` + Skia Canvas) yang menyatukan animasi rute 3D, pop-up foto, dan ringkasan metrik menjadi file MP4/GIF siap share.
- Pembuat kartu visual media sosial (9:16 Story Cards & 1:1 Feed Cards) dengan berbagai tema desain.

### Phase 6: Fitur Map Premium Ekstra (Personal Heatmap & Live Segments)
- Personal Heatmap 2D & 3D per kategori olahraga.
- Custom Live Segments dengan fitur **Virtual Ghost Competitor** & audio cues.
- Universal GPX/FIT Export & Import.

---

# 10. Indikator Keberhasilan (Definition of Success)

1. **Stabilitas Latar Belakang**: 0% sesi terputus atau terhenti saat layar mati selama gowes/lari berdurasi 1 hingga 5 jam.
2. **Kualitas Data**: Jarak dan elevasi selaras dengan unit GPS terdedikasi (Garmin / Wahoo) dengan deviasi < 3%.
3. **Performa 3D**: Render rute 3D dan animasi flyover berjalan lancar pada 60 FPS di perangkat Android kelas menengah.
4. **Kecepatan Generator Footage**: Ekspor video rekap MP4 selesai dalam waktu kurang dari 30 detik secara lokal di perangkat.
5. **Zero Bill**: Seluruh fungsionalitas berjalan lancar tanpa memerlukan satu pun langganan API berbayar.
