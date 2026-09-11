# Rencana Proyek: Stravo Pro (100% Offline GPS & Outdoor Fitness)

> **PENTING: DOKUMEN MASTER TELAH DIPERBARUI KE ARSITEKTUR 100% OFFLINE / ZERO-SERVER**  
> 1. **Spesifikasi Produk & PRD Lengkap**: Lihat [prompt plan.md](file:///d:/coding/flutter/stravo/prompt%20plan.md)
> 2. **Master Kontrak Tim & Skema Database (Drift/SQLite)**: Lihat [TEAM_CONTRACT_AND_DATABASE_SCHEMA.md](file:///d:/coding/flutter/stravo/TEAM_CONTRACT_AND_DATABASE_SCHEMA.md)
>
> Dokumen di bawah ini merupakan arsip konsep awal sebelum migrasi ke sistem standalone on-device murni.

## 1. Ringkasan Konsep

Aplikasi pelacak aktivitas olahraga (lari, sepeda, jalan kaki, dll) yang meniru fitur inti Strava: rekam aktivitas pakai GPS secara real-time, simpan riwayat, tampilkan statistik, dan (opsional di fase lanjutan) fitur sosial seperti feed, kudos, dan leaderboard segment.

## 2. Fitur Utama (dipecah per modul)

### A. Auth & Profil

- Daftar/login (email + Google Sign-In)
- Profil: foto, nama, unit satuan (km/mil), total statistik (total jarak, total aktivitas, total waktu)
- Riwayat aktivitas per user (list, bisa difilter per jenis olahraga)

### B. Activity Recording (fitur inti — paling krusial)

- Pilih jenis aktivitas (lari, sepeda, jalan kaki, hiking, dll)
- Tombol Start/Pause/Resume/Stop
- Saat merekam:
  - Peta live menampilkan rute yang sedang terbentuk (garis mengikuti posisi GPS)
  - Statistik live: jarak, waktu berjalan, pace/kecepatan saat ini & rata-rata, elevasi (jika tersedia)
  - Tetap merekam walau layar mati / app di-minimize (background tracking)
- Setelah stop: preview ringkasan (rute di peta, jarak total, durasi, pace rata-rata, elevation gain)
- Simpan aktivitas dengan judul, deskripsi opsional, foto opsional, privasi (publik/privat)

### C. Riwayat & Detail Aktivitas

- Halaman detail per aktivitas: peta rute penuh, grafik pace/elevasi, statistik lengkap
- Bisa edit judul/deskripsi/privasi setelah disimpan, atau hapus aktivitas

### D. Statistik & Progress

- Dashboard mingguan/bulanan (total jarak, total waktu, jumlah aktivitas)
- Personal record (jarak terjauh, pace tercepat, dst) per jenis olahraga

### E. Fitur Sosial (fase lanjutan, bukan MVP)

- Feed aktivitas dari user yang di-follow
- Kudos (like) & komentar di aktivitas orang lain
- Follow/unfollow user lain
- Segment & leaderboard (kompetisi waktu tercepat di rute tertentu — ini fitur paling kompleks di Strava, butuh geospatial matching)
- Challenge/goal bulanan

## 3. User Flow (MVP)

1. User buka app → login/daftar
2. Pilih jenis aktivitas → tekan Start
3. App minta izin lokasi (termasuk izin lokasi background)
4. Rekam aktivitas: peta & statistik update real-time, user bisa pause/resume
5. Tekan Stop → preview ringkasan aktivitas
6. Isi judul (opsional deskripsi/foto) → Save
7. Aktivitas tersimpan, muncul di riwayat & dashboard statistik

## 4. Rekomendasi Arsitektur Teknis

| Komponen                               | Rekomendasi                                                                                                 | Alasan                                                                                                                                                                                                           |
| :------------------------------------- | :---------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Framework**                          | Flutter (sesuai permintaan), target Android dulu                                                            | Cross-platform, tapi fokus Android sesuai rencana kamu                                                                                                                                                           |
| **State Management**                   | Riverpod atau Bloc                                                                                          | Cocok untuk aplikasi dengan banyak state real-time (tracking, timer, lokasi)                                                                                                                                     |
| **Lokasi/GPS**                         | Package `geolocator` + foreground service (`flutter_foreground_task` atau `flutter_background_geolocation`) | Android mewajibkan foreground service dengan notifikasi persisten agar GPS tetap jalan saat app di-background/layar mati                                                                                         |
| **Peta**                               | `google_maps_flutter`                                                                                       | Paling matang di Flutter untuk Android, tampilan mirip Strava, butuh Google Maps API key + billing aktif                                                                                                         |
| **Database Lokal (offline recording)** | `sqflite` atau `drift`/`Hive`                                                                               | Aktivitas harus tetap kerekam meski tidak ada koneksi internet, baru sync ke server saat online                                                                                                                  |
| **Backend**                            | Firebase (Auth + Firestore/Realtime DB + Storage + Cloud Functions) _atau_ Supabase (Postgres-based)        | Firebase paling cepat diintegrasikan dengan Flutter untuk solo developer; Supabase alternatif open-source kalau mau kontrol database lebih besar (berguna nanti untuk fitur segment yang butuh query geospasial) |
| **Notifikasi**                         | Firebase Cloud Messaging                                                                                    | Untuk notifikasi kudos/komentar di fase sosial                                                                                                                                                                   |

## 5. Hal Krusial yang Wajib Diperhatikan (Bagian Tersulit)

GPS background tracking adalah bagian paling rawan gagal di aplikasi seperti ini, khususnya di Android:

- **Izin lokasi background**: Android 10+ mewajibkan permintaan izin "Allow all the time" terpisah dari izin lokasi biasa — harus ada UX yang menjelaskan ke user kenapa izin ini dibutuhkan
- **Foreground service wajib**: tanpa foreground service + notifikasi persisten, Android akan mematikan proses GPS saat app di-background
- **Battery optimization**: banyak HP Android (terutama Xiaomi/Samsung) punya battery saver agresif yang bisa membunuh background service — perlu panduan ke user untuk whitelist app
- **Noise filtering GPS**: sinyal GPS suka "lompat-lompat" terutama di area gedung tinggi/hutan; perlu filter akurasi (misal abaikan titik dengan akurasi > 20m) supaya rute yang tergambar tidak zig-zag aneh
- **Google Maps API key & billing**: perlu setup Google Cloud Console, aktifkan billing (ada tier gratis, tapi tetap perlu kartu kredit terdaftar)

## 6. Pembagian MVP vs Fitur Lanjutan

**MVP (fokus dulu ke sini):**

- Auth sederhana (email/Google)
- Recording aktivitas dengan GPS live + peta + statistik dasar (jarak, waktu, pace)
- Background tracking yang stabil (foreground service)
- Simpan & lihat riwayat aktivitas + detail per aktivitas
- Dashboard statistik dasar (total mingguan/bulanan)

**Fase Lanjutan (setelah MVP stabil):**

- Fitur sosial: feed, follow, kudos, komentar
- Segment & leaderboard (kompleks, butuh backend geospasial)
- Challenge/goal
- Multi-sport metrics lebih detail (power cycling, swim pace, dll)
- Sinkronisasi dengan wearable (opsional, jauh ke depan)

---

## 7. Prompt Siap Pakai — untuk ChatGPT (refine ide, nama, spesifikasi produk)

```
Aku sedang merancang aplikasi fitness tracking untuk Android, mirip Strava, dibangun dengan Flutter.

Fitur inti yang kupikirkan:
1. Auth & profil user (email/Google login), dengan statistik total (jarak, waktu, jumlah aktivitas)
2. Activity Recording: user pilih jenis olahraga (lari/sepeda/jalan/hiking), tekan Start, GPS merekam rute secara real-time di peta, menampilkan statistik live (jarak, waktu, pace, elevasi), bisa pause/resume/stop, tetap merekam walau app di-background/layar mati
3. Setelah selesai: preview ringkasan aktivitas (peta rute, jarak, durasi, pace rata-rata), lalu disimpan dengan judul/deskripsi/foto opsional
4. Riwayat aktivitas per user + halaman detail per aktivitas (peta, grafik pace/elevasi)
5. Dashboard statistik mingguan/bulanan
6. (Fase lanjutan, bukan MVP) Fitur sosial: feed aktivitas dari user yang di-follow, kudos, komentar, segment & leaderboard kompetisi waktu tercepat di rute tertentu

Untuk MVP aku ingin fokus dulu ke poin 1-5, fitur sosial menyusul belakangan.

Tolong bantu aku:
1. Susun ini jadi Product Requirements Document (PRD) lebih detail: user story per fitur, dan kriteria "selesai" untuk MVP.
2. Brainstorm nama aplikasi yang catchy dan relevan dengan tema fitness/lari/sepeda.
3. Kritisi rencana ini — fitur apa yang mungkin kurang jelas, terlalu ambisius untuk MVP solo developer, atau ada gap yang belum kepikiran (terutama soal GPS background tracking di Android)?
```

## 8. Prompt Siap Pakai — untuk Antigravity (technical build)

```
Aku ingin membangun aplikasi Flutter untuk Android, fitness tracking mirip Strava. Fokus MVP dulu, dengan fitur berikut:

1. Auth: login/daftar dengan email & Google Sign-In (pakai Firebase Auth)
2. Activity Recording (fitur inti):
   - User pilih jenis aktivitas (lari/sepeda/jalan/hiking)
   - Start/Pause/Resume/Stop
   - Selama merekam: peta live menampilkan rute yang sedang terbentuk dari data GPS, statistik live (jarak, waktu, pace saat ini & rata-rata, elevasi)
   - HARUS tetap merekam GPS walau app di-background atau layar mati (pakai foreground service, karena ini wajib di Android untuk background location)
   - Filter noise GPS: abaikan titik dengan akurasi rendah (misal >20m) supaya rute tidak zig-zag
3. Setelah Stop: tampilkan preview ringkasan (peta rute penuh, jarak, durasi, pace rata-rata, elevation gain), lalu user isi judul/deskripsi/foto opsional dan simpan
4. Riwayat aktivitas: list semua aktivitas user + halaman detail per aktivitas (peta rute, grafik pace/elevasi, statistik lengkap), bisa edit/hapus
5. Dashboard statistik: total jarak/waktu/jumlah aktivitas mingguan & bulanan
6. Data harus tetap tersimpan lokal dulu (offline-first) baru sync ke backend saat online, supaya aktivitas tidak hilang kalau sinyal hilang saat olahraga

Stack yang ingin dipakai:
- Flutter + Riverpod (state management)
- google_maps_flutter untuk peta
- geolocator untuk GPS + package foreground service (flutter_foreground_task) untuk background tracking
- sqflite/drift untuk penyimpanan lokal sebelum sync
- Firebase (Auth, Firestore, Storage) sebagai backend

Tolong bantu aku:
1. Rekomendasikan struktur project Flutter yang modular (pemisahan antara core GPS/tracking engine, UI screens, dan data layer/repository).
2. Scaffold dulu bagian Activity Recording (termasuk background location service), karena ini bagian paling krusial dan paling berisiko gagal — sebelum lanjut ke UI riwayat dan dashboard.
3. Jelaskan setup izin lokasi Android (foreground service + background location permission) yang diperlukan di AndroidManifest.xml dan cara meminta izin secara bertahap ke user (best practice, bukan langsung minta "Allow all the time" di awal).
```
