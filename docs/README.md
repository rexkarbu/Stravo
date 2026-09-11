# Stravo Pro — Pusat Dokumentasi Proyek & Navigasi Tim
### Dokumentasi Resmi Stravo Pro (100% Standalone On-Device & Zero-Server)

Selamat datang di pusat dokumentasi resmi **Stravo Pro**. Folder `docs/` ini adalah sumber kebenaran tunggal (*Single Source of Truth*) untuk seluruh arsitektur sistem, desain antarmuka, skema database, dan pembagian tugas tim 3 orang (**Rouf**, **Rex**, dan **Ray**).

---

## 📂 Struktur Direktori Dokumentasi

```text
docs/
├── README.md                              <-- (Anda sedang di sini) Indeks Navigasi
├── BLUEPRINT_TIM_3_DEVELOPER.md           <-- Cetak Biru Lengkap Tim 3 Orang & Navigasi
├── TEAM_CONTRACT_AND_DATABASE_SCHEMA.md   <-- Master Skema Database SQLite (Drift) & ERD
├── PRD_STRAVO_PRO_OFFLINE.md              <-- Spesifikasi Produk Lengkap (PRD)
└── tasks/                                 <-- Pembagian Tugas Per Orang (Checklist Fase & Task)
    ├── INDEPENDENT_WORK_GUIDE.md          <-- Panduan Kerja Serentak 100% Tanpa Saling Tunggu
    ├── RAY_TASKS.md                       <-- Checklist Tugas Ray (Lead UI/UX Designer)
    ├── ROUF_TASKS.md                      <-- Checklist Tugas Rouf (Fullstack Core & Data)
    └── REX_TASKS.md                       <-- Checklist Tugas Rex (Fullstack 3D Maps & Media)
```

---

## 🎯 Panduan Cepat Sesuai Peran

### 1. Saya Ray (Lead UI/UX Designer)
* **Mulai dari mana?** Buka [RAY_TASKS.md](file:///d:/coding/flutter/stravo/docs/tasks/RAY_TASKS.md) dan baca [INDEPENDENT_WORK_GUIDE.md](file:///d:/coding/flutter/stravo/docs/tasks/INDEPENDENT_WORK_GUIDE.md).
* **Fokus Anda**: Anda **TIDAK PERLU MENUNGGU** Rouf atau Rex! Anda bisa langsung merancang seluruh 12 layar dan komponen UI dengan data tiruan (*mock data*) yang sudah disediakan.
* **Taman Bermain Anda**: `lib/app/theme/`, `lib/core/widgets/`, dan `lib/features/debug/design_system_catalog_screen.dart`.

### 2. Saya Rouf (Fullstack Core, Sensor & Offline Data)
* **Mulai dari mana?** Buka [ROUF_TASKS.md](file:///d:/coding/flutter/stravo/docs/tasks/ROUF_TASKS.md) dan [TEAM_CONTRACT_AND_DATABASE_SCHEMA.md](file:///d:/coding/flutter/stravo/docs/TEAM_CONTRACT_AND_DATABASE_SCHEMA.md).
* **Fokus Anda**: Perekaman GNSS satelit 1Hz murni, filter Kalman, Android Foreground Service, sensor getaran jalan (Gravel vs Aspal), audio TTS splits, serta mesin backup/restore database 100% lokal ke HP.

### 3. Saya Rex (Fullstack 3D Maps, Media & Gamifikasi)
* **Mulai dari mana?** Buka [REX_TASKS.md](file:///d:/coding/flutter/stravo/docs/tasks/REX_TASKS.md) dan [TEAM_CONTRACT_AND_DATABASE_SCHEMA.md](file:///d:/coding/flutter/stravo/docs/TEAM_CONTRACT_AND_DATABASE_SCHEMA.md).
* **Fokus Anda**: Peta 3D MapLibre offline + DEM tiles, pemutar 3D Flyover sinematik dengan kurva Bézier, on-device MP4 video footage maker, pelacak Live Segments (Ghost Pacer), dan Personal Heatmap 2D/3D.

---

## 🔒 Filosofi Kedaulatan Data Penuh (Data Sovereignty)
Aplikasi ini **100% Standalone On-Device**:
- Tidak ada akun online, tidak ada Firebase/Supabase, tidak ada biaya server selamanya (Rp 0).
- Seluruh data olahraga, koordinat GPS, foto, dan segmen tersimpan di SQLite lokal di HP pengguna.
- Fitur Backup & Restore lokal memungkinkan pengguna memindahkan data ke HP baru atau menyimpannya dalam bentuk arsip file kapan saja.
