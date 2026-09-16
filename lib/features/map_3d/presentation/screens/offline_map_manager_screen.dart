import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/stravo_card.dart';

class OfflineMapManagerScreen extends StatefulWidget {
  const OfflineMapManagerScreen({super.key});

  @override
  State<OfflineMapManagerScreen> createState() => _OfflineMapManagerScreenState();
}

class _OfflineMapManagerScreenState extends State<OfflineMapManagerScreen> {
  final List<Map<String, dynamic>> _installedPacks = [
    {
      'title': 'Jawa Tengah & Yogyakarta Topo',
      'region': 'Indonesia Central',
      'size': '412 MB',
      'version': 'v2026.08',
      'isDownloaded': true,
      'isDefault': true,
    },
    {
      'title': 'Gunung Merapi & Merbabu 3D Terrain',
      'region': 'High Resolution DEM',
      'size': '185 MB',
      'version': 'v2026.09',
      'isDownloaded': true,
      'isDefault': false,
    },
  ];

  final List<Map<String, dynamic>> _availablePacks = [
    {
      'title': 'Jawa Timur & Bromo Tengger',
      'region': 'East Java Topo + 3D',
      'size': '520 MB',
      'version': 'v2026.07',
      'isDownloaded': false,
    },
    {
      'title': 'Jawa Barat & Bandung Trail',
      'region': 'West Java Topo',
      'size': '480 MB',
      'version': 'v2026.08',
      'isDownloaded': false,
    },
    {
      'title': 'Bali Gravel & Coastline',
      'region': 'Bali Island 3D DEM',
      'size': '290 MB',
      'version': 'v2026.09',
      'isDownloaded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      appBar: AppBar(
        backgroundColor: StravoColors.background,
        elevation: 0,
        title: Text(
          'PETA OFFLINE (MBTILES)',
          style: StravoTypography.h3.copyWith(
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Storage Usage Overview
            _buildStorageOverviewCard(),
            const SizedBox(height: 24),

            // Downloaded Packs
            Text(
              'PAKET TERPASANG DI HP (OFFLINE READY)',
              style: StravoTypography.metricLabel,
            ),
            const SizedBox(height: 12),
            ..._installedPacks.map((pack) => _buildPackTile(pack, isInstalled: true)),
            const SizedBox(height: 24),

            // Available for download
            Text(
              'WILAYAH LAINNYA UNTUK DIUNDUH',
              style: StravoTypography.metricLabel,
            ),
            const SizedBox(height: 12),
            ..._availablePacks.map((pack) => _buildPackTile(pack, isInstalled: false)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageOverviewCard() {
    return StravoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sd_storage_outlined, color: StravoColors.cyberGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Penyimpanan Peta Offline',
                    style: StravoTypography.bodyBold,
                  ),
                ],
              ),
              Text(
                '597 MB Terpakai',
                style: StravoTypography.caption.copyWith(
                  color: StravoColors.cyberGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.28,
              backgroundColor: StravoColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(StravoColors.cyberGreen),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Semua rute, elevasi, dan peta 3D berfungsi 100% tanpa sinyal internet atau roaming.',
            style: StravoTypography.caption.copyWith(color: StravoColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPackTile(Map<String, dynamic> pack, {required bool isInstalled}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: StravoColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StravoColors.glassBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isInstalled
                  ? StravoColors.cyberGreen.withValues(alpha: 0.15)
                  : StravoColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.map_outlined,
              color: isInstalled ? StravoColors.cyberGreen : StravoColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pack['title'],
                  style: StravoTypography.bodyBold.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pack['region']} • ${pack['size']} • ${pack['version']}',
                  style: StravoTypography.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isInstalled)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: StravoColors.textDisabled, size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Menghapus paket ${pack['title']}')),
                );
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.download_outlined, color: StravoColors.orangePrimary, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mengunduh paket ${pack['title']}...')),
                );
              },
            ),
        ],
      ),
    );
  }
}
