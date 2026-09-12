# Stravo Pro — 100% Offline Outdoor Fitness & 3D GPS Tracker
### Aplikasi Pelacak Olahraga Standalone Tanpa Server (Zero-Server, On-Device Pure Computing)

Stravo Pro adalah aplikasi pelacak olahraga luar ruangan (Gravel Cycling, Road Cycling, Mountain Biking, Trail Run, dan Hiking) yang menghadirkan fitur-fitur premium setara **Strava Subscription** dan **Relive Pro** secara **100% GRATIS dan MANDIRI DI HP** tanpa ketergantungan server cloud.

---

## 👥 Tim Pengembang (3 Orang)

| Anggota Tim | Peran | Fokus Tanggung Jawab | Dokumen Tugas |
| :--- | :--- | :--- | :--- |
| **Rouf** | Fullstack Core & Sensor | GPS GNSS 1Hz, Kalman Filter, Auto-Pause, Accelerometer Gravel FFT, TTS Audio, Drift SQLite & Backup Lokal | [ROUF_TASKS.md](file:///d:/coding/flutter/stravo/docs/tasks/ROUF_TASKS.md) |
| **Rex** | Fullstack 3D & Media | MapLibre 3D Offline, Replay 3D Flyover Bézier, On-Device MP4 Video Maker, Live Segments & Heatmap | [REX_TASKS.md](file:///d:/coding/flutter/stravo/docs/tasks/REX_TASKS.md) |
| **Ray** | Lead UI/UX Designer | Design System (Colors, Typography), Reusable Widgets, 12 Layar, Animasi & Story Cards 9:16 | [RAY_TASKS.md](file:///d:/coding/flutter/stravo/docs/tasks/RAY_TASKS.md) |

> 🚀 **Panduan Kerja Serentak Tanpa Saling Menunggu:**  
> Seluruh anggota tim (termasuk Ray sang desainer) dapat bekerja bersama sejak hari pertama menggunakan pola *Mock-Driven Development*. Baca panduan lengkapnya di [INDEPENDENT_WORK_GUIDE.md](file:///d:/coding/flutter/stravo/docs/tasks/INDEPENDENT_WORK_GUIDE.md).

---

## 📚 Pusat Dokumentasi Proyek (`docs/`)

Seluruh cetak biru teknis dan panduan arsitektur tersimpan rapi di folder `docs/`:

1. [Pusat Navigasi Dokumentasi (`docs/README.md`)](file:///d:/coding/flutter/stravo/docs/README.md)
2. [Cetak Biru Tim 3 Orang & Panduan Visual (`docs/BLUEPRINT_TIM_3_DEVELOPER.md`)](file:///d:/coding/flutter/stravo/docs/BLUEPRINT_TIM_3_DEVELOPER.md)
3. [Master Skema Database Drift/SQLite & ERD (`docs/TEAM_CONTRACT_AND_DATABASE_SCHEMA.md`)](file:///d:/coding/flutter/stravo/docs/TEAM_CONTRACT_AND_DATABASE_SCHEMA.md)
4. [Product Requirements Document (PRD) (`docs/PRD_STRAVO_PRO_OFFLINE.md`)](file:///d:/coding/flutter/stravo/docs/PRD_STRAVO_PRO_OFFLINE.md)

---

## 🔒 Filosofi Kedaulatan Data (Data Sovereignty)
* **Rp 0 Biaya Selamanya**: Tidak ada tagihan Firebase, Supabase, Google Maps API, atau AWS.
* **100% Privat**: Seluruh koordinat GPS, foto, dan rute tersimpan di SQLite lokal di HP pengguna.
* **Backup & Restore Mandiri**: Pengguna dapat mencadangkan seluruh riwayat ke file JSON/ZIP lokal dan memindahkannya ke HP lain kapan saja.
