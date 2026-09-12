# Lembar Kerja & Checklist Tugas: Ray (Lead UI/UX Designer & Styler)
### Tanggung Jawab: Master Design System, Reusable Component Library, Screen Layouts, Animations & Visual Polish

> **PENTING UNTUK RAY:**  
> Anda bisa langsung mulai mengerjakan seluruh tugas di bawah ini **SEJAK HARI PERTAMA** menggunakan **Mock Data (data tiruan)** tanpa perlu menunggu database dari Rouf atau peta dari Rex selesai. Baca panduannya di [INDEPENDENT_WORK_GUIDE.md](file:///d:/coding/flutter/stravo/docs/tasks/INDEPENDENT_WORK_GUIDE.md).

---

## 🎨 Fase 1: Design System Tokens & Atomic Widgets (Fondasi Visual)
Tujuan: Menyediakan blok-blok komponen grafis berkualitas tinggi yang akan dipakai di seluruh aplikasi.

- [x] **Setup Palet Warna (`lib/app/theme/stravo_colors.dart`)**
  - [x] Background OLED Stealth Dark (`#0A0C10`, `#12161F`)
  - [x] Aksen Utama Stravo Orange (`#FF5500`) & Orange Glow
  - [x] Aksen Cyber Gravel Green (`#00FF9D`), Cyan (`#00E5FF`), Neon Yellow, Crimson Pink
  - [x] Warna Glassmorphism Surface & 1px border tipis
- [x] **Setup Athletic Typography (`lib/app/theme/stravo_typography.dart`)**
  - [x] Tabular monospaced figures untuk angka speedometer agar angka tidak goyang
  - [x] Heading tebal sporty (H1, H2, H3) & label metrik
- [x] **Setup Master ThemeData (`lib/app/theme/app_theme.dart`)**
  - [x] Dark theme scaffold, card theme, divider theme, and app bar
- [x] **Komponen Kartu Glassmorphism (`lib/core/widgets/stravo_card.dart`)**
  - [x] Efek latar belakang gelap dengan border tipis dan bayangan lembut
- [x] **Komponen Tombol Gradien Neon (`lib/core/widgets/gradient_button.dart`)**
  - [x] Tombol aksi oranye neon dengan efek glowing dan animasi tekan
- [x] **Komponen Metrik Telemetri (`lib/core/widgets/metric_stat_tile.dart`)**
  - [x] Format label kecil di atas dan angka tebal di bawah + unit satuan
- [ ] **Komponen Speedometer Besar Neon (`lib/core/widgets/neon_speedometer_gauge.dart`)**
  - [ ] Busur speedometer melingkar dengan indikator jarum / progress glow
  - [ ] Angka kecepatan ukuran ekstra besar (64px) di tengah
- [ ] **Badge Indikator Permukaan Jalan (`lib/core/widgets/surface_type_badge.dart`)**
  - [ ] Tag kecil penanda: *Aspal Mulus*, *Gravel Halus*, *Makadam Kasar*, *Singletrack*
- [ ] **Indikator Kategori Tanjakan (`lib/core/widgets/climb_gradient_indicator.dart`)**
  - [ ] Tag persen kecuraman dengan warna dinamis: Hijau (<4%), Kuning (5-8%), Merah (>13%)
- [ ] **Badge Selisih Waktu Ghost Pacer (`lib/core/widgets/ghost_pacer_badge.dart`)**
  - [ ] Hijau jika unggul (`+2.4s ahead`), Merah jika tertinggal (`-1.8s behind`)
- [ ] **Layar Galeri Komponen (`lib/features/debug/design_system_catalog_screen.dart`)**
  - [ ] Satu layar tempat Ray bisa melihat semua tombol, kartu, dan indikator yang telah dibuat

---

## 📱 Fase 2: Perakitan Seluruh 12 Halaman (Dengan Mock Data)
Tujuan: Membuat antarmuka lengkap untuk ke-12 layar aplikasi sehingga semua orang bisa melihat wujud akhir aplikasi.

- [ ] **Layar 1: `MainNavigationShell` (`lib/app/presentation/main_navigation_shell.dart`)**
  - [ ] Bottom Navigation Bar gelap dengan 4 tab: Activities, Explore, Analytics, Profile
  - [ ] Tombol tengah melayang (Center Floating Action Button) berwarna oranye neon untuk mulai rekam
- [ ] **Layar 2: `ActivityHistoryScreen` (`lib/features/activity_history/presentation/screens/activity_list_screen.dart`)**
  - [ ] Header ringkasan jarak minggu ini (misal: "84.5 KM MINGGU INI")
  - [ ] Filter pill jenis olahraga: Semua, Gravel, Road, MTB, Run, Hike
  - [ ] List kartu aktivitas dengan thumbnail rute mini, jarak, waktu, dan elevasi
- [ ] **Layar 3: `RecordingScreen` Fullscreen (`lib/features/recording/presentation/screens/recording_screen.dart`)**
  - [ ] Bar atas: status GPS lock, baterai HP, indikator offline
  - [ ] Area tengah: Speedometer besar neon + tag jenis permukaan jalan (Gravel/Aspal)
  - [ ] Grid 2x3 statistik: Jarak, Waktu, Elevasi, Avg Speed, Pace, VAM
  - [ ] Area bawah: Mini peta live rute + 3 tombol aksi (Kamera Geotag, Pause/Resume, Stop)
- [ ] **Layar 4: `ActivitySaveSummaryScreen` (`lib/features/recording/presentation/screens/activity_save_summary_screen.dart`)**
  - [ ] Input judul aktivitas (otomatis terisi misal: "Gravel Sore Santai")
  - [ ] Input deskripsi catatan
  - [ ] Pilihan sepeda/sepatu yang dipakai dari garasi
  - [ ] Preview thumbnail rute & tombol "Simpan Aktivitas"
- [ ] **Layar 5: `ActivityDetailScreen` (`lib/features/activity_history/presentation/screens/activity_detail_screen.dart`)**
  - [ ] Header peta 3D dengan tombol melayang: "▶ Putar 3D Flyover Replay"
  - [ ] Kartu ringkasan 4 angka utama: Jarak, Durasi, Elevasi Naik, Kecepatan Puncak
  - [ ] Progress bar komposisi jalan: % Gravel vs % Aspal
  - [ ] Grafik profil elevasi tanjakan (scrolling interaktif)
  - [ ] Galeri foto-foto waypoint yang diambil di sepanjang rute
  - [ ] Tombol aksi bawah: "🎬 Buat Video Rekap (MP4)" & "📱 Instagram Story"
- [ ] **Layar 6: `Flyover3dPlayerScreen` Fullscreen (`lib/features/map_3d/presentation/screens/flyover_player_screen.dart`)**
  - [ ] Viewport 3D fullscreen (bisa portrait atau landscape)
  - [ ] Floating Telemetry HUD transparan (kecepatan, ketinggian, jarak yang bergerak)
  - [ ] Kontrol scrubber slider di bawah, tombol Play/Pause, dan pengubah kecepatan (1x, 2x, 4x, 8x)
- [ ] **Layar 7: `ExploreMapScreen` (`lib/features/map_3d/presentation/screens/explore_map_screen.dart`)**
  - [ ] Peta offline 3D bebas geser/rotasi
  - [ ] Tombol toggle layer "Personal Heatmap"
  - [ ] Floating search bar untuk mencari segmen rute terdekat
  - [ ] Tombol buka pengelola paket peta offline (MBTiles)
- [ ] **Layar 8: `AnalyticsDashboardScreen` (`lib/features/dashboard/presentation/screens/analytics_dashboard_screen.dart`)**
  - [ ] Grafik batang volume jarak mingguan dan bulanan
  - [ ] Lemari piala Personal Records (PR): 5K tercepat, 10K, 40K sepeda, Tanjakan terekstrem
- [ ] **Layar 9: `ProfileAndGearScreen` (`lib/features/profile/presentation/screens/profile_screen.dart`)**
  - [ ] Profil atlet offline (nama, foto lokal, berat badan, Max HR)
  - [ ] Garasi Sepeda: List sepeda dengan odometer jarak tempuh dan progress bar rantai
  - [ ] Tombol Kedaulatan Data: "Backup Database ke HP" & "Restore Data"
- [ ] **Layar 10: `CreateSegmentScreen` (`lib/features/segments/presentation/screens/create_segment_screen.dart`)**
  - [ ] Peta dengan alat geser pin Start dan pin Finish untuk memotong rute
  - [ ] Form input nama segmen (misal: "Tanjakan Bukit X")
- [ ] **Layar 11: `SegmentDetailScreen` (`lib/features/segments/presentation/screens/segment_detail_screen.dart`)**
  - [ ] Profil elevasi tanjakan segmen + kategori tanjakan (Cat 3 / Cat 2 / HC)
  - [ ] Leaderboard rekor pribadi (PR 1, PR 2, PR 3)
- [ ] **Layar 12: `OfflineMapManagerScreen` (`lib/features/map_3d/presentation/screens/offline_map_manager_screen.dart`)**
  - [ ] List file peta offline MBTiles yang tersimpan di storage internal HP

---

## 🎬 Fase 3: Lembar Aksi (Bottom Sheets) & Desain Kartu Sosial
Tujuan: Merancang popup dan template kartu media sosial estetik (fitur mirip Relive & Strava Subscription).

- [ ] **Lembar Aksi: `FootageGeneratorSheet` (`lib/features/footage_generator/presentation/sheets/footage_generator_sheet.dart`)**
  - [ ] Pilihan rasio video: 9:16 (Stories/Reels) atau 1:1 (Feed)
  - [ ] Pilihan durasi: 15 detik, 30 detik, 45 detik
  - [ ] Progress bar saat merender video di HP
- [ ] **Template Kartu Cerita Instagram 9:16 (`lib/features/footage_generator/presentation/cards/story_card_theme.dart`)**
  - [ ] **Tema 1: Dark Neon Cyber** (Rute menyala neon dengan latar belakang hitam pekat)
  - [ ] **Tema 2: Gravel Topography** (Garis kontur topografi gunung dengan statistik gravel)
  - [ ] **Tema 3: Clean Athletic Minimalist** (Tipografi putih bersih kontras tinggi ala majalah olahraga)
- [ ] **Lembar Aksi: `QuickPhotoCaptureSheet` (`lib/features/recording/presentation/sheets/quick_photo_sheet.dart`)**
  - [ ] Pop-up jepret foto cepat di atas setang sepeda dengan indikator geotag koordinat
- [ ] **Lembar Aksi: `ExportBackupSheet` (`lib/features/activity_history/presentation/sheets/export_sheet.dart`)**
  - [ ] Pilihan format ekspor: GPX, FIT, TCX, atau file Backup JSON

---

## ✨ Fase 4: Micro-Animations & Final Polish
Tujuan: Memberikan sensasi sentuhan mewah (*premium feel*) di setiap interaksi.

- [ ] Efek animasi denyut (*pulsing*) pada status GPS Locked hijau
- [ ] Animasi transisi halus saat menekan tombol Start $\rightarrow$ Pause $\rightarrow$ Resume
- [ ] Efek Haptic Feedback (getaran HP halus) saat tombol di layar ditekan saat berkendara
- [ ] Uji keterbacaan kontras di bawah terik sinar matahari langsung
