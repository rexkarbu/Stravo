# Product Requirements Document

## Fitness Activity Tracking App — MVP v0.1

**Platform:** Android
**Framework:** Flutter
**Status:** Planning
**Product type:** GPS fitness/activity tracker
**Target awal:** Solo developer / MVP validation

---

# 1. Product Vision

Membangun aplikasi Android yang memungkinkan pengguna merekam aktivitas olahraga outdoor seperti:

- Running
- Walking
- Cycling
- Hiking

Aplikasi merekam perjalanan menggunakan GPS secara real-time dan menampilkan informasi penting seperti:

- rute,
- jarak,
- durasi,
- pace atau speed,
- serta ringkasan aktivitas setelah selesai.

Prioritas produk bukan membuat pengganti Strava secara penuh.

Prioritas MVP adalah memastikan bahwa:

> Pengguna dapat menekan Start, berolahraga, mematikan layar atau meminimalkan aplikasi, kemudian kembali dan mendapatkan rekaman aktivitas yang utuh dan cukup akurat.

Jika kemampuan tersebut belum dapat diandalkan, fitur lain dianggap sekunder.

---

# 2. Problem Statement

Banyak aplikasi fitness menyediakan terlalu banyak fitur sebelum fungsi dasar tracking menjadi fokus utama.

Produk ini ingin menyediakan pengalaman tracking yang:

1. sederhana,
2. dapat dipercaya,
3. tetap bekerja ketika layar mati,
4. tidak kehilangan aktivitas ketika koneksi internet terputus,
5. memberikan ringkasan aktivitas yang mudah dipahami.

---

# 3. Target User

## Primary User

Pengguna Android yang melakukan aktivitas outdoor seperti:

- lari,
- jalan kaki,
- bersepeda,
- hiking,

dan ingin menyimpan riwayat aktivitas menggunakan GPS.

## Secondary User

Pengguna yang ingin melihat perkembangan olahraga mingguan atau bulanan tanpa membutuhkan ekosistem sosial yang kompleks.

---

# 4. Product Goals

MVP dianggap berhasil apabila pengguna dapat:

1. membuat akun,
2. memulai aktivitas,
3. merekam perjalanan menggunakan GPS,
4. pause dan resume,
5. menjalankan recording ketika aplikasi diminimalkan atau layar mati,
6. menyelesaikan aktivitas,
7. melihat summary,
8. menyimpan aktivitas,
9. membuka kembali aktivitas tersebut,
10. melihat statistik dasar mingguan dan bulanan.

---

# 5. Non-Goals MVP

Fitur berikut secara eksplisit bukan bagian MVP:

- social feed,
- follow/unfollow,
- kudos,
- comments,
- public leaderboard,
- segments,
- challenges,
- clubs,
- messaging,
- wearable integration,
- heart-rate monitor integration,
- power meter,
- training plans,
- AI coaching,
- route recommendation,
- live location sharing,
- advanced fitness analytics.

Fitur tersebut tidak boleh dimasukkan hanya karena implementasinya terlihat mudah.

---

# 6. Core Product Principles

## 6.1 Tracking reliability > jumlah fitur

Aktivitas yang hilang atau memiliki jarak sangat salah merupakan kegagalan produk yang lebih serius daripada tidak adanya fitur sosial.

## 6.2 Local-first recording

Data aktivitas harus terlebih dahulu disimpan secara lokal.

Koneksi backend tidak boleh menjadi dependency untuk proses tracking.

## 6.3 Explicit recording lifecycle

Tracking memiliki lifecycle yang jelas:

`idle → preparing → recording → paused → recording → finishing → saved`

Tidak boleh ada beberapa session recording aktif secara bersamaan.

## 6.4 User-controlled tracking

GPS recording hanya berjalan sebagai hasil tindakan eksplisit pengguna.

Tidak ada passive location tracking pada MVP.

---

# 7. MVP Feature Requirements

## 7.1 Authentication

### User Stories

**AUTH-01**

Sebagai pengguna baru, saya ingin membuat akun menggunakan email agar aktivitas saya dapat dikaitkan dengan akun pribadi.

**AUTH-02**

Sebagai pengguna, saya ingin login kembali menggunakan akun yang telah dibuat.

**AUTH-03**

Sebagai pengguna, saya ingin login menggunakan Google agar onboarding lebih cepat.

### Functional Requirements

Aplikasi menyediakan:

- register email/password,
- login email/password,
- Google Sign-In,
- logout,
- session persistence.

### Definition of Done

Authentication dianggap selesai jika:

- pengguna dapat register,
- pengguna dapat login,
- pengguna dapat logout,
- session tetap tersedia setelah aplikasi dibuka kembali,
- kegagalan autentikasi menampilkan error yang dapat dimengerti,
- user tidak dapat melihat data aktivitas milik akun lain.

---

# 8. Activity Type Selection

Sebelum aktivitas dimulai, user memilih jenis olahraga.

MVP mendukung:

- Running
- Walking
- Cycling
- Hiking

Setiap activity memiliki field:

- activity type,
- start time,
- end time,
- elapsed duration,
- moving duration,
- distance,
- route points,
- average pace/speed,
- elevation data jika tersedia,
- title,
- description,
- privacy.

Jenis aktivitas tidak boleh berubah setelah recording dimulai pada MVP.

---

# 9. Pre-Recording Screen

Sebelum tombol Start aktif, aplikasi melakukan readiness check.

Aplikasi memeriksa:

- location service aktif,
- permission tersedia,
- tidak ada activity lain yang sedang berjalan,
- tracking engine siap.

UI menampilkan:

- activity type,
- status GPS,
- tombol Start.

Jika lokasi tidak tersedia, Start tidak boleh diam-diam menjalankan session kosong.

---

# 10. Activity Recording

Ini adalah fitur paling penting dalam keseluruhan MVP.

## User Story

Sebagai pengguna, saya ingin merekam olahraga menggunakan GPS sehingga saya dapat mengetahui rute, jarak, durasi, dan pace aktivitas saya.

## Recording Screen

Saat recording aktif, tampilkan minimal:

- map,
- current route,
- duration,
- distance,
- current pace/speed,
- average pace/speed,
- Pause,
- Stop.

UI lain dianggap sekunder.

---

# 11. Tracking States

## Idle

Tidak ada aktivitas aktif.

## Recording

GPS points diterima dan aktivitas sedang dihitung.

## Paused

Timer aktivitas aktif dihentikan.

GPS point baru tidak ditambahkan ke distance selama pause.

## Resumed

Recording melanjutkan session yang sama.

Tidak membuat activity baru.

## Finishing

Tracking service dihentikan dan session sedang difinalisasi.

## Saved

Data aktivitas telah disimpan ke local database.

---

# 12. Background Tracking

Ketika recording sedang berjalan:

- user boleh meminimalkan aplikasi,
- user boleh berpindah aplikasi,
- layar boleh mati,
- tracking harus tetap berlangsung.

Foreground service Android harus memiliki persistent notification selama activity berlangsung.

Notification minimal menunjukkan:

- aktivitas sedang direkam,
- elapsed time atau status tracking.

Notification tidak boleh hilang selama tracking aktif.

---

# 13. Location Point Model

Setiap GPS point minimal menyimpan:

- latitude,
- longitude,
- timestamp,
- horizontal accuracy,
- altitude jika tersedia,
- speed jika tersedia.

Opsional kemudian:

- bearing,
- raw provider information.

Data mentah sebaiknya dipertahankan agar algoritma perhitungan dapat diperbaiki kemudian tanpa kehilangan source data.

---

# 14. GPS Quality Filtering

Aplikasi tidak boleh menghitung semua GPS point secara mentah.

Tracking engine harus mampu menolak point yang jelas tidak masuk akal.

Pertimbangkan:

- reported accuracy,
- duplicate point,
- timestamp invalid,
- teleport/jump,
- unrealistic speed,
- point ketika session paused.

Threshold tidak boleh tersebar sebagai magic number di UI.

Semua aturan filtering ditempatkan dalam tracking/domain layer sehingga dapat diuji dan diubah.

---

# 15. Distance Calculation

Distance dihitung dari accepted GPS points secara berurutan.

Sistem harus membedakan:

- raw GPS distance,
- accepted/calculated distance.

Distance tidak boleh bertambah ketika activity berada dalam status paused.

---

# 16. Duration

Minimal terdapat dua konsep waktu:

### Elapsed Time

Waktu dari Start sampai Stop.

### Moving / Active Time

Waktu recording tanpa periode pause manual.

UI MVP boleh memprioritaskan active duration, tetapi model data harus membedakan keduanya.

---

# 17. Pace dan Speed

Untuk:

### Running / Walking / Hiking

Metric utama:

`pace = time / distance`

ditampilkan sebagai misalnya:

`5:42 /km`

### Cycling

Metric utama:

`speed = distance / time`

misalnya:

`24.3 km/h`

Average metric dihitung berdasarkan aktivitas yang telah diterima tracking engine.

Current pace tidak boleh dihitung hanya dari satu GPS point karena terlalu noisy.

Gunakan moving window/smoothing pada implementasi tracking.

---

# 18. Elevation

Elevation dianggap **best-effort metric** untuk MVP.

GPS altitude dapat disimpan jika tersedia.

Namun kegagalan atau ketidakakuratan altitude tidak boleh membuat recording gagal.

Elevation gain dapat ditampilkan setelah kualitas algoritmanya telah tervalidasi.

Jika kualitas elevation belum cukup baik, tampilkan tanpa elevation daripada memberikan angka palsu.

---

# 19. Stop Activity

Stop harus berbeda dengan Pause.

Untuk mencegah accidental stop, aplikasi meminta konfirmasi.

Contoh:

`Finish this activity?`

Jika user memilih cancel:

tracking berlanjut.

Jika confirm:

tracking service dihentikan dan aplikasi menuju Activity Summary.

---

# 20. Activity Summary

Setelah activity selesai, tampilkan:

- route map,
- activity type,
- distance,
- active duration,
- average pace/speed,
- start/end time,
- elevation jika valid.

User dapat menambahkan:

- title,
- description.

Photo dan privacy boleh tetap terdapat dalam data model, tetapi photo upload tidak menjadi blocker untuk MVP awal.

Primary action:

`Save Activity`

---

# 21. Local Storage

Activity harus tersimpan di perangkat sebelum sinkronisasi backend dianggap berhasil.

Minimum entities:

## Activity

- id
- userId
- activityType
- title
- description
- startedAt
- endedAt
- elapsedDuration
- movingDuration
- distance
- averageSpeed
- averagePace
- elevationGain
- privacy
- syncStatus
- createdAt
- updatedAt

## TrackPoint

- id
- activityId
- latitude
- longitude
- altitude
- accuracy
- speed
- recordedAt
- accepted

---

# 22. Crash Recovery

Ini merupakan requirement MVP, bukan fitur tambahan.

Jika aplikasi atau proses Flutter mati ketika aktivitas berlangsung, aplikasi harus berusaha memulihkan session terakhir.

Setidaknya session state dan accepted track points disimpan secara incremental.

Ketika aplikasi dibuka kembali:

jika ditemukan unfinished activity, user diberi pilihan yang sesuai berdasarkan keadaan tracking service/session.

Activity tidak boleh hanya berada di RAM.

---

# 23. Backend Synchronization

Sinkronisasi backend diperlakukan sebagai proses terpisah dari recording.

Sync status:

- LOCAL_ONLY
- PENDING
- SYNCING
- SYNCED
- FAILED

Jika internet terputus:

activity tetap tersimpan.

Ketika koneksi tersedia:

activity dapat dicoba disinkronkan kembali.

Recording tidak boleh gagal karena Firebase/remote backend tidak tersedia.

---

# 24. Activity History

User dapat membuka daftar activity yang sudah tersimpan.

Setiap list item minimal menampilkan:

- type,
- date,
- distance,
- duration,
- pace/speed.

Urutan default:

terbaru → terlama.

---

# 25. Activity Detail

Detail activity menampilkan:

- route map,
- activity type,
- date/time,
- distance,
- duration,
- average pace/speed,
- elevation jika tersedia.

User dapat:

- edit title,
- edit description,
- menghapus activity.

Untuk MVP, route map dan statistik jauh lebih penting daripada chart kompleks.

---

# 26. Delete Activity

Deletion harus menggunakan confirmation dialog.

Activity yang telah dihapus:

- hilang dari history,
- tidak dihitung dalam dashboard,
- mengikuti deletion/sync strategy terhadap remote backend.

---

# 27. Dashboard

Dashboard MVP hanya berfungsi sebagai progress summary.

Filter:

- This Week
- This Month

Metric:

- total distance,
- total active time,
- number of activities.

Opsional setelah stabil:

- comparison dengan periode sebelumnya.

Dashboard tidak memerlukan recommendation engine atau AI.

---

# 28. Profile

Profile minimal berisi:

- display name,
- profile photo opsional,
- preferred unit,
- total distance,
- total activities,
- total activity time.

Unit awal:

- metric / km.

Imperial dapat ditambahkan setelah core MVP stabil jika ingin mengurangi scope awal.

---

# 29. Offline Behaviour

User harus tetap dapat:

- memulai activity,
- merekam GPS,
- pause,
- resume,
- stop,
- menyimpan activity,
- melihat history lokal,

tanpa koneksi internet.

Fitur yang membutuhkan backend boleh menunjukkan status pending/offline.

---

# 30. Permission UX

Aplikasi tidak meminta semua permission langsung ketika pertama dibuka.

Permission diminta ketika relevan terhadap tindakan user.

Contoh:

User memilih Start Activity.

Aplikasi menjelaskan bahwa lokasi digunakan untuk merekam rute, distance, dan pace.

Setelah itu baru permission Android ditampilkan.

Jika permission ditolak:

- jangan crash,
- jelaskan konsekuensinya,
- berikan cara retry.

---

# 31. Error States

MVP harus menangani minimal:

- GPS disabled,
- location permission denied,
- location permission permanently denied,
- GPS signal poor,
- no internet,
- sync failure,
- foreground tracking failure,
- database write failure,
- activity already active,
- application reopened during active session,
- malformed GPS point.

Error tidak boleh sekadar dicetak ke console.

User-facing failure harus memiliki recovery path bila memungkinkan.

---

# 32. Data Privacy

Lokasi merupakan data sensitif.

MVP harus mengikuti prinsip:

- hanya merekam saat user secara eksplisit memulai activity,
- tracking berhenti saat activity selesai,
- tidak melakukan passive tracking,
- tidak menggunakan location untuk iklan,
- tidak membagikan route secara publik secara default.

Default privacy yang disarankan:

`Private`

sampai fitur sosial benar-benar tersedia.

---

# 33. Analytics & Logging

Development logging perlu mencatat event penting seperti:

- tracking_started,
- tracking_paused,
- tracking_resumed,
- tracking_stopped,
- location_point_received,
- location_point_rejected,
- activity_saved,
- sync_started,
- sync_failed,
- sync_completed.

Jangan memasukkan latitude/longitude mentah ke external telemetry tanpa kebutuhan dan kebijakan privasi yang jelas.

---

# 34. MVP Acceptance Criteria

MVP hanya dianggap selesai jika semua kondisi berikut terpenuhi.

### Recording

- Activity dapat dimulai.
- GPS route muncul.
- Distance bertambah secara masuk akal.
- Timer berjalan.
- Pause bekerja.
- Resume bekerja.
- Stop bekerja.

### Background

- Tracking tetap berjalan ketika app diminimalkan.
- Tracking tetap berjalan ketika layar mati.
- Persistent foreground notification tampil.
- Kembali ke aplikasi tidak membuat session baru.

### Reliability

- Recording tidak hanya tersimpan di memory.
- Activity dapat dipulihkan setelah application restart sesuai kondisi yang didukung.
- Tidak ada double-running session.
- GPS point buruk tidak langsung merusak total distance.

### Storage

- Activity tersimpan secara lokal.
- Activity muncul kembali setelah aplikasi direstart.
- History dapat dibuka offline.

### Sync

- Kegagalan internet tidak menghilangkan activity.
- Failed sync dapat dicoba ulang.
- Sync tidak membuat duplicate activity.

### History

- Activity list tersedia.
- Activity detail dapat dibuka.
- Route tersimpan dapat ditampilkan kembali.
- Activity dapat diedit dan dihapus.

### Dashboard

- Statistik mingguan dapat dihitung dari aktivitas.
- Statistik bulanan dapat dihitung dari aktivitas.

---

# 35. MVP Success Metrics

Untuk development/beta awal:

### Tracking completion rate

Persentase activity yang berhasil dari Start sampai Save.

Target:

`>95%`

### Crash-free recording

Tidak ada crash selama sesi tracking normal.

### Distance reliability

Hasil distance berada dalam range yang masuk akal dibanding reference tracker/test route.

### Background survival

Tracking tetap berjalan dalam tes layar mati dan app background.

### Data-loss rate

Target:

`0 activity hilang setelah user menekan Stop/Save`.

---

# 36. Recommended Technical Architecture

Struktur modular:

```text
lib/
├── app/
├── core/
│   ├── error/
│   ├── location/
│   ├── permissions/
│   └── utils/
│
├── features/
│   ├── auth/
│   ├── recording/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── activity_history/
│   ├── dashboard/
│   └── profile/
│
├── services/
│   ├── tracking/
│   ├── background/
│   └── sync/
│
└── main.dart
```

Tracking logic tidak boleh diletakkan langsung di widget Flutter.

UI hanya berinteraksi dengan tracking controller/domain abstraction.

---

# 37. Recommended Development Order

## Phase 0 — Tracking Technical Spike

Belum membuat aplikasi lengkap.

Buktikan terlebih dahulu:

- GPS stream,
- foreground service,
- layar mati,
- background,
- pause/resume,
- route point persistence.

**Exit condition:** 30–60 menit tracking nyata tidak kehilangan session.

---

## Phase 1 — Tracking Domain

Implement:

- tracking state machine,
- location model,
- distance calculation,
- GPS filtering,
- timer logic,
- pause/resume,
- persistence.

Semua logic yang dapat diuji harus memiliki unit tests.

---

## Phase 2 — Recording UI

Implement:

- activity selector,
- readiness screen,
- recording screen,
- live map,
- statistics,
- Stop flow.

---

## Phase 3 — Local Activity Management

Implement:

- local database,
- save activity,
- history,
- detail,
- edit,
- delete,
- crash/session recovery.

---

## Phase 4 — Authentication

Implement:

- Firebase Auth,
- email,
- Google Sign-In,
- account mapping.

Auth sengaja tidak menjadi pekerjaan pertama karena auth bukan risiko teknis utama produk.

---

## Phase 5 — Cloud Sync

Implement:

- Firebase storage model,
- sync queue,
- retry,
- duplicate protection,
- offline handling.

---

## Phase 6 — Dashboard

Implement:

- weekly aggregation,
- monthly aggregation,
- profile totals.

---

## Phase 7 — Hardening

Test:

- Android versions,
- several phone vendors,
- background,
- screen off,
- poor GPS,
- loss of network,
- process restart,
- low battery,
- long activity.

Setelah Phase 7 stabil, MVP dapat dianggap release candidate.

---

# 38. Post-MVP

Urutan ekspansi yang disarankan:

### V1.1

- charts,
- personal records,
- richer activity statistics,
- photos,
- better elevation processing.

### V1.2

- public profile,
- follow,
- activity feed.

### V1.3

- kudos,
- comments,
- notification system.

### V1.4+

- challenges,
- segments,
- leaderboards.

Segments sengaja ditempatkan jauh setelah MVP karena memerlukan sistem geospatial matching dan anti-cheat yang jauh lebih kompleks dibanding sekadar menampilkan route.

---

# 39. MVP Product Definition

MVP bukan:

> aplikasi sosial olahraga sederhana seperti Strava.

MVP adalah:

> GPS workout recorder yang dapat dipercaya di Android, tetap merekam ketika layar mati, menyimpan aktivitas secara local-first, dan memberikan history serta progress dasar.

Semua keputusan scope harus diuji terhadap definisi tersebut.
