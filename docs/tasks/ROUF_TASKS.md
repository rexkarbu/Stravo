# Lembar Kerja & Checklist Tugas: Rouf (Fullstack Core, Sensors & Data Engine)
### Tanggung Jawab: GPS GNSS Hardware 1Hz, Kalman Filter, Auto-Pause, Android Foreground Service, Sensor Getaran Accelerometer, TTS Audio, Drift SQLite & Backup Lokal 100%

> **PENTING UNTUK ROUF:**  
> Anda bertanggung jawab atas mesin inti pelacakan (*heartbeat*) dan kedaulatan data di HP. Seluruh data disimpan 100% lokal tanpa server cloud dengan garansi 0% data hilang saat crash.

---

## 💾 Fase 1: Drift SQLite Persistence & Skema Database Lokal
Tujuan: Membangun fondasi database SQLite lokal yang sangat cepat, aman dari crash, dan siap menampung ribuan titik GPS.

- [x] **Setup Dependensi Database di `pubspec.yaml`**
  - [x] Pasang `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`
  - [x] Pasang `drift_dev`, `build_runner` di `dev_dependencies`
- [x] **Implementasi Definisi Tabel Drift (`lib/core/database/tables/`)**
  - [x] Tabel `activities`: ID UUID, sport_type, jarak, waktu bergerak, elevasi, kecepatan, komposisi gravel/aspal
  - [x] Tabel `track_points`: Titik GPS 1Hz, lat, lng, elevasi, akurasi, kecepatan, tanjakan %, tag permukaan jalan
  - [x] Tabel `waypoint_photos`: Foto geotagged, file_path lokal, lat, lng, km tempuh
  - [x] Tabel `gears`: Sepeda & sepatu, odometer jarak total, status aktif/pensiun
  - [x] Tabel `user_profile`: Data fisik atlet lokal (berat badan, Max HR, FTP)
- [x] **Data Access Objects (DAOs) (`lib/core/database/daos/`)**
  - [x] `ActivitiesDao`: CRUD aktivitas, filter multi-sport, query total statistik seumur hidup
  - [x] `TrackPointsDao`: Insert batch titik koordinat, query titik berurutan berdasarkan `sequence_idx`
  - [x] `PhotosDao`: Simpan metadata foto geotagged
- [x] **Incremental Local Flush Mechanism (Jaminan 0% Data Loss)**
  - [x] Auto-commit setiap 5 detik: Menulis buffer koordinat GPS ke SQLite agar jika HP mati mendadak atau kehabisan baterai, data tidak hilang
- [x] **Crash Recovery Detector**
  - [x] Saat aplikasi dibuka, periksa apakah ada record di `activities` dengan status `inProgress`
  - [x] Jika ada, munculkan prompt: *"Lanjutkan sesi yang terputus atau simpan sekarang?"*

---

## 🛰️ Fase 2: GNSS Satellite Tracking Engine & Android Background Service
Tujuan: Memastikan pelacakan GPS tetap berjalan akurat dan stabil saat HP dimasukkan ke kantong celana atau layar dimatikan.

- [ ] **Setup Hardware GPS Satelit Murni**
  - [ ] Integrasi `geolocator` dengan frekuensi sampling 1 Hz (1 koordinat per detik)
  - [ ] Pengaturan akurasi tinggi (`LocationAccuracy.bestForNavigation`) tanpa butuh koneksi internet
- [ ] **Android Foreground Service & Wakelock (`lib/services/background/`)**
  - [ ] Integrasi `flutter_foreground_task`
  - [ ] Konfigurasi `PARTIAL_WAKE_LOCK` di Android agar CPU tetap hidup saat layar mati
  - [ ] Notifikasi persisten Android di status bar dengan timer live, kecepatan saat ini, dan tombol Pause/Resume
- [ ] **Kalman Filter & GPS Noise Gate (`lib/core/location/kalman_filter.dart`)**
  - [ ] Accuracy gate: Mengabaikan titik dengan horizontal accuracy > 18 meter
  - [ ] Kalman Filter algorithm: Menghaluskan garis rute agar tidak bergerigi/zig-zag saat melintasi pepohonan atau gedung
- [ ] **Smart Auto-Pause Detector (`lib/core/location/auto_pause_detector.dart`)**
  - [ ] Deteksi otomatis saat kecepatan < 2 km/jam selama lebih dari 3 detik (misal: di lampu merah)
  - [ ] Menghentikan penghitungan `movingTime` dan otomatis melanjutkan saat kecepatan kembali naik
- [ ] **Broadcast Stream Telemetri Realtime**
  - [ ] Menghasilkan stream `LiveTelemetrySnapshot` setiap 1 detik untuk dikonsumsi HUD Ray dan Segments Rex

---

## 🚴 Fase 3: Multi-Sport & Gravel Vibration Analytics
Tujuan: Membaca sensor internal HP untuk membedakan jenis jalan secara otomatis dan menghitung statistik fisik sepeda/lari.

- [ ] **Accelerometer Surface Classifier (`lib/features/gravel_analytics/vibration_surface_classifier.dart`)**
  - [ ] Membaca stream sensor accelerometer HP pada frekuensi 50Hz
  - [ ] Algoritma ekstraksi amplitudo getaran:
    - *Aspal Mulus*: Getaran rendah & stabil
    - *Gravel Halus / Tanah Padat*: Getaran sedang berpola ritmis
    - *Gravel Kasar / Makadam*: Getaran acak beramplitudo tinggi
  - [ ] Menyematkan tag `SurfaceType` ke setiap `track_point`
- [ ] **Kalkulator Kemiringan Tanjakan (Climb Gradient) & GAP**
  - [ ] Menghitung persentase tanjakan: `(Elevasi Sekarang - Elevasi Lalu) / Jarak Tempuh * 100%`
  - [ ] Kategorisasi tanjakan: Flat (<3%), Cat 4 (3-5%), Cat 3 (5-8%), Cat 2 (8-11%), Cat 1 (11-15%), HC (>15%)
  - [ ] Grade Adjusted Pace (GAP) untuk pelari berdasarkan kurva fisiologis Minetti
- [ ] **Integrasi Sensor Tambahan (Internal & BLE)**
  - [ ] Barometer sensor: Menghitung ketinggian akurat dari perubahan tekanan atmosfer
  - [ ] Bluetooth Low Energy (BLE): Koneksi nirkabel peer-to-peer ke Heart Rate Strap & Cadence Sensor tanpa internet

---

## 📷 Fase 4: In-Ride Media, Audio Assistant & Backup 100% Lokal
Tujuan: Dokumentasi foto saat gowes, asisten suara, dan kedaulatan data penuh di tangan pengguna.

- [ ] **Geotagged Photo Camera Engine (`lib/features/recording/`)**
  - [ ] Membuka kamera HP secara cepat saat gowes/lari
  - [ ] Menyimpan foto ke galeri lokal HP dengan menyematkan metadata koordinat GPS, ketinggian, dan kilometer tempuh
  - [ ] Menyimpan path foto ke tabel `waypoint_photos`
- [ ] **Android Local TTS (Text-to-Speech) Audio Cues (`lib/services/audio_cues/`)**
  - [ ] Suara pemberitahuan otomatis setiap 1 kilometer (misal: *"Kilometer 15, waktu 38 menit, kecepatan rata-rata 24 km/jam"*)
  - [ ] Peringatan suara saat auto-pause aktif dan saat kembali bergerak
- [ ] **Universal GPS Exporter & Importer (`lib/services/export_import/`)**
  - [ ] Generator file `.gpx` standar dunia lengkap dengan elevasi dan waktu
  - [ ] Generator file `.fit` dan `.tcx`
  - [ ] Parser GPX untuk mengimpor rute lama dari Garmin/Strava ke dalam Stravo Pro
- [ ] **Mesin Backup 100% Lokal (Data Sovereignty) (`lib/core/backup/`)**
  - [ ] Ekspor seluruh isi database SQLite ke satu berkas backup `.json` atau `.zip` di memori HP pengguna
  - [ ] Fitur Restore: Mengimpor file backup dan memulihkan seluruh riwayat olahraga tanpa butuh server sama sekali
