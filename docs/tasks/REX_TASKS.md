# Lembar Kerja & Checklist Tugas: Rex (Fullstack 3D Maps, Media & Gamifikasi)
### Tanggung Jawab: Peta 3D Offline MapLibre + DEM Tiles, 3D Route Flyover Sinematik, On-Device MP4 Video Generator, Live Segments & Ghost Competitor, Personal Heatmap 2D/3D

> **PENTING UNTUK REX:**  
> Anda bertanggung jawab atas fitur-fitur visual paling memukau (*the WOW factor*) di Stravo Pro. Seluruh rendering 3D dan video diproses langsung oleh GPU smartphone tanpa server cloud. Anda dapat menguji seluruh fitur menggunakan file rute GPX sampel tanpa harus menunggu GPS Rouf.

---

## 🗺️ Fase 1: Peta 3D Topografi Offline (MapLibre + DEM MBTiles)
Tujuan: Menghadirkan peta vektor 3D dengan kontur gunung nyata yang dapat dibuka di tengah hutan belantara tanpa sinyal seluler.

- [ ] **Setup Dependensi MapLibre GL Native di `pubspec.yaml`**
  - [ ] Pasang `maplibre_gl` (atau flutter maplibre fork)
  - [ ] Konfigurasi permission storage Android untuk membaca berkas peta lokal
- [ ] **Offline Map Pack Storage Manager (`lib/core/offline_maps/`)**
  - [ ] Scan folder internal `/storage/.../Stravo/maps/` untuk mendeteksi file `.mbtiles` atau `.pmtiles`
  - [ ] Tabel database `offline_map_packs`: Menyimpan daftar area peta yang tersedia (misal: "Jawa Barat 3D", "Bali Topo")
- [x] **Offline 3D Terrain & Hillshading Rendering (`lib/features/map_3d/`)**
  - [x] Memuat raster Digital Elevation Model (DEM) dari file lokal HP
  - [x] Mengaktifkan efek kemiringan 3D (*pitch 45°-60°*) dan rotasi 360° (*bearing*)
  - [x] Efek bayangan kontur gunung (*hillshading*) untuk memperlihatkan lembah dan punggungan bukit
- [x] **Color-Coded Dynamic Polylines**
  - [x] Garis lintasan di peta diberi warna gradien berdasarkan:
    - *Speed Heat*: Biru (santai) $\rightarrow$ Hijau $\rightarrow$ Kuning $\rightarrow$ Merah (sprint)
    - *Elevation Gradient*: Warna elevasi dari titik terendah ke tertinggi
    - *Surface Type*: Hijau (Aspal), Oranye (Gravel), Cokelat (Makadam/Tanah)

---

## ✈️ Fase 2: Cinematic 3D Route Flyover (Replay Animasi Rute)
Tujuan: Menghadirkan fitur peninjauan rute sinematik pasca-olahraga ala Relive / Strava 3D Flyover langsung di HP.

- [x] **Interpolasi Kurva Bézier Kamera 3D (`lib/features/map_3d/controllers/camera_3d_controller.dart`)**
  - [x] Mengambil daftar titik koordinat dari `track_points` aktivitas
  - [x] Menginterpolasikan pergerakan kamera agar meluncur mulus di sepanjang rute GPS tanpa patah-patah
- [x] **Koreografi Kamera Sinematik Dinamis**
  - [x] Kamera otomatis mendekat (*zoom in*) dan memiring (*tilt down*) saat mendaki tanjakan curam
  - [x] Kamera otomatis menjauh (*zoom out*) di puncak ketinggian untuk memperlihatkan panorama luas
  - [x] Kamera memutar halus mengikuti arah tikungan jalan (*bearing rotation*)
- [x] **Floating Telemetry HUD Sinkron**
  - [x] Kotak overlay HUD transparan yang menampilkan kecepatan, elevasi, tanjakan %, dan jarak tempuh yang nilainya berubah sinkron dengan pergerakan kamera 3D
- [x] **Kontrol Interaktif Pemutar Flyover (`lib/features/map_3d/widgets/flyover_player.dart`)**
  - [x] Tombol Play, Pause, Scrubber Slider untuk memajukan/memundurkan posisi kamera
  - [x] Pengatur kecepatan pemutaran: 1x, 2x, 4x, 8x

---

## 🎬 Fase 3: On-Device Video Footage Generator & Story Cards (100% di HP)
Tujuan: Menghasilkan video rekap MP4 siap share ke Instagram Stories dan WhatsApp Status dalam waktu < 45 detik tanpa server.

- [ ] **Integrasi On-Device Video Renderer (`lib/features/footage_generator/services/on_device_video_renderer.dart`)**
  - [ ] Memanfaatkan hardware video encoder ponsel Android (`ffmpeg_kit_flutter` atau Skia Native Canvas frame grabber)
- [ ] **Komposisi Video Animasi 30 Detik (9:16 & 1:1)**:
  - [ ] *Detik 0 - 3*: Intro sinematik (Judul rute, tanggal, jenis olahraga, jarak total)
  - [ ] *Detik 3 - 24*: Kamera 3D menelusuri rute dengan garis bercahaya neon (*tracer*)
  - [ ] *Saat melewati KM waypoint*: Pop-up foto waypoint muncul secara elegan di samping rute
  - [ ] *Bagian bawah layar*: Grafik profil elevasi berjalan mengikuti titik rute
  - [ ] *Detik 25 - 30*: Layar ringkasan akhir (Total Jarak, Total Waktu, Elevation Gain, Max Speed)
- [ ] **Ekspor Otomatis ke Galeri Ponsel**
  - [ ] Menyimpan berkas MP4 beresolusi Full HD (1080x1920) langsung ke folder DCIM/Stravo di HP
- [ ] **Generator Dynamic Social Story Cards (PNG Resolusi Tinggi)**
  - [ ] Merender widget visual menjadi gambar PNG kristal jernih untuk Instagram Stories & WhatsApp Status

---

## 🏆 Fase 4: Live Segments, Ghost Competitor & Personal Heatmap
Tujuan: Gamifikasi olahraga offline — bertanding melawan rekor sendiri di jalan dan visualisasi jalur bersepeda seumur hidup.

- [ ] **Tabel Database & CRUD Segmen (`lib/core/database/tables/segments.dart`)**
  - [ ] Tabel `segments`: ID, nama, titik start (lat/lng), titik finish, jarak, elevasi, bounding box spasial
  - [ ] Tabel `segment_efforts`: Riwayat waktu setiap kali pengguna melintasi segmen tersebut
- [ ] **Spatial Bounding Box Matcher (`lib/features/segments/segment_matcher.dart`)**
  - [ ] Deteksi otomatis saat koordinat GPS pengguna memasuki radius titik awal segmen secara offline
  - [ ] Algoritma ringan yang tidak membebani baterai HP saat tracking
- [ ] **Ghost Competitor Engine (`lib/features/segments/ghost_pacer_engine.dart`)**
  - [ ] Mengambil data rekor waktu terbaik (PR) pengguna di segmen tersebut
  - [ ] Menghitung selisih detik secara real-time saat pengguna melintasi segmen
  - [ ] Memunculkan HUD: *"Kamu 3 detik di depan Ghost Pacer!"*
  - [ ] Integrasi audio TTS suara: *"Mulai segmen Tanjakan Bukit! Rekor terbaikmu 4 menit 20 detik!"*
- [ ] **Personal Heatmap 2D & 3D Offline (`lib/features/heatmap/`)**
  - [ ] Mengambil seluruh koordinat aktivitas masa lalu dari database SQLite lokal
  - [ ] Merender garis-garis rute menjadi layer heatmap berpendar neon di atas peta offline
  - [ ] Filter kategori: Heatmap Gravel, Heatmap Lari, atau Semua
- [ ] **Training Volume & PR Analytics Dashboard (`lib/features/dashboard/`)**
  - [ ] Kalkulasi akumulasi kilometer mingguan dan bulanan
  - [ ] Evaluasi otomatis Personal Records (Jarak terjauh, Kecepatan tertinggi, Elevasi terbesar)
