import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/climb_gradient_indicator.dart';
import 'package:stravo/core/widgets/metric_stat_tile.dart';
import 'package:stravo/core/widgets/route_graphics.dart';
import 'package:stravo/core/widgets/stravo_card.dart';

class SegmentDetailScreen extends StatelessWidget {
  final String title;
  final double distanceKm;
  final double gradientPct;
  final int elevationGainMeters;
  final List<double> elevationProfile;

  const SegmentDetailScreen({
    super.key,
    this.title = 'Tanjakan Karetan HC',
    this.distanceKm = 2.4,
    this.gradientPct = 11.8,
    this.elevationGainMeters = 284,
    this.elevationProfile = const [120, 160, 220, 290, 350, 404],
  });

  final List<Map<String, dynamic>> _personalRecords = const [
    {'rank': 'PR 1', 'time': '8m 42s', 'date': '04 Sep 2026', 'avgSpeed': '16.5 KM/H', 'power': '310W'},
    {'rank': 'PR 2', 'time': '9m 10s', 'date': '18 Agt 2026', 'avgSpeed': '15.7 KM/H', 'power': '295W'},
    {'rank': 'PR 3', 'time': '9m 45s', 'date': '02 Jul 2026', 'avgSpeed': '14.8 KM/H', 'power': '278W'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      appBar: AppBar(
        backgroundColor: StravoColors.background,
        elevation: 0,
        title: Text(
          'DETAIL SEGMEN',
          style: StravoTypography.h3.copyWith(fontSize: 16, letterSpacing: 1.2),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline, color: StravoColors.neonYellow),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Climb Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: StravoTypography.h2,
                  ),
                ),
                ClimbGradientIndicator(gradientPercentage: gradientPct),
              ],
            ),
            const SizedBox(height: 16),

            // Segment Stats Card
            StravoCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MetricStatTile(
                    label: 'JARAK',
                    value: distanceKm.toStringAsFixed(1),
                    unit: 'KM',
                    valueColor: StravoColors.orangePrimary,
                  ),
                  MetricStatTile(
                    label: 'ELEVASI NAIK',
                    value: '$elevationGainMeters',
                    unit: 'M',
                    valueColor: StravoColors.cyberGreen,
                  ),
                  MetricStatTile(
                    label: 'RATA-RATA TANJAKAN',
                    value: gradientPct.toStringAsFixed(1),
                    unit: '%',
                    valueColor: StravoColors.neonYellow,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Elevation Profile Chart Card
            StravoCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PROFIL TANJAKAN', style: StravoTypography.metricLabel),
                      Text('Cat 2 Climb', style: StravoTypography.caption.copyWith(color: StravoColors.orangePrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevationProfileChart(
                    elevations: elevationProfile,
                    height: 120,
                    primaryColor: StravoColors.neonPink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal Records Leaderboard
            Text(
              'PAPAN REKOR PRIBADI SAYA (OFFLINE PR)',
              style: StravoTypography.metricLabel,
            ),
            const SizedBox(height: 12),
            ..._personalRecords.map((rec) => _buildPrRow(rec)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPrRow(Map<String, dynamic> rec) {
    final isFirst = rec['rank'] == 'PR 1';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StravoColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFirst ? StravoColors.orangePrimary.withValues(alpha: 0.5) : StravoColors.glassBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isFirst
                  ? StravoColors.orangePrimary.withValues(alpha: 0.2)
                  : StravoColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              rec['rank'],
              style: TextStyle(
                color: isFirst ? StravoColors.orangePrimary : StravoColors.textSecondary,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec['time'],
                  style: StravoTypography.h3.copyWith(
                    fontFeatures: StravoTypography.tabularFigures,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rec['date']} • ${rec['avgSpeed']} • ${rec['power']}',
                  style: StravoTypography.caption,
                ),
              ],
            ),
          ),
          if (isFirst)
            const Icon(Icons.emoji_events, color: StravoColors.neonYellow, size: 22)
          else
            const Icon(Icons.chevron_right, color: StravoColors.textDisabled, size: 20),
        ],
      ),
    );
  }
}
