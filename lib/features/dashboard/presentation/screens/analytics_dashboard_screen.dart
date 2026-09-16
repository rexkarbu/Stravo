import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/metric_stat_tile.dart';
import 'package:stravo/core/widgets/stravo_card.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  String _timeRange = 'Bulan Ini';

  final List<Map<String, dynamic>> _weeklyVolumes = [
    {'week': 'M1', 'distance': 85.0, 'target': 100.0},
    {'week': 'M2', 'distance': 120.5, 'target': 100.0},
    {'week': 'M3', 'distance': 98.2, 'target': 100.0},
    {'week': 'M4', 'distance': 145.4, 'target': 100.0},
  ];

  final List<Map<String, dynamic>> _personalRecords = [
    {
      'title': '40 KM Time Trial',
      'sport': 'Gravel / Road',
      'value': '1j 08m 12s',
      'date': '12 Agt 2026',
      'icon': Icons.pedal_bike,
      'color': StravoColors.orangePrimary,
    },
    {
      'title': 'Tanjakan Terekstrem (HC)',
      'sport': 'Kopeng Attack',
      'value': '1,180 M Gain',
      'date': '02 Sep 2026',
      'icon': Icons.filter_hdr,
      'color': StravoColors.neonPink,
    },
    {
      'title': '10K Fastest Run',
      'sport': 'Road Run',
      'value': '44m 20s',
      'date': '24 Jul 2026',
      'icon': Icons.directions_run,
      'color': StravoColors.cyberGreen,
    },
    {
      'title': 'Kecepatan Puncak (Sprint)',
      'sport': 'Downhill Descent',
      'value': '64.5 KM/H',
      'date': '18 Agt 2026',
      'icon': Icons.bolt,
      'color': StravoColors.neonCyan,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildMonthlyVolumeCard()),
            SliverToBoxAdapter(child: _buildFitnessTrendGrid()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LEMARI PIALA REKOR PRIBADI (PR)',
                      style: StravoTypography.caption.copyWith(
                        color: StravoColors.textSecondary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Icon(Icons.emoji_events_outlined, color: StravoColors.neonYellow, size: 18),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPrTile(_personalRecords[index]),
                  childCount: _personalRecords.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PERFORMA ATLET',
                style: StravoTypography.caption.copyWith(
                  letterSpacing: 2.0,
                  color: StravoColors.orangePrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text('Analitik & Rekor', style: StravoTypography.h2),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: StravoColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: StravoColors.glassBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _timeRange,
                dropdownColor: StravoColors.surfaceElevated,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: StravoColors.textSecondary),
                items: ['Minggu Ini', 'Bulan Ini', 'Tahun 2026'].map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _timeRange = val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyVolumeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: StravoCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('VOLUME JARAK MINGGUAN', style: StravoTypography.metricLabel),
                Text('Total: 449.1 KM', style: StravoTypography.caption.copyWith(color: StravoColors.cyberGreen, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            // Custom Bar Chart for weekly volume
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _weeklyVolumes.map((item) {
                  final dist = item['distance'] as double;
                  final heightRatio = (dist / 160.0).clamp(0.1, 1.0);
                  final isCurrent = item['week'] == 'M4';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${dist.toInt()}k',
                        style: TextStyle(
                          color: isCurrent ? StravoColors.orangePrimary : StravoColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 32,
                        height: 80 * heightRatio,
                        decoration: BoxDecoration(
                          color: isCurrent ? StravoColors.orangePrimary : StravoColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrent ? StravoColors.orangePrimary : StravoColors.glassBorder,
                          ),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: StravoColors.orangePrimary.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['week'],
                        style: TextStyle(
                          color: isCurrent ? Colors.white : StravoColors.textMuted,
                          fontSize: 11,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFitnessTrendGrid() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: StravoCard(
              padding: EdgeInsets.all(16),
              child: MetricStatTile(
                label: 'TOTAL ELEVASI NAIK',
                value: '7,480',
                unit: 'M',
                valueColor: StravoColors.cyberGreen,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: StravoCard(
              padding: EdgeInsets.all(16),
              child: MetricStatTile(
                label: 'ESTIMASI VO2MAX',
                value: '54.2',
                unit: 'ML/KG',
                valueColor: StravoColors.neonCyan,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrTile(Map<String, dynamic> pr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: StravoColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StravoColors.glassBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (pr['color'] as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(pr['icon'] as IconData, color: pr['color'] as Color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pr['title'], style: StravoTypography.bodyBold.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text('${pr['sport']} • ${pr['date']}', style: StravoTypography.caption),
              ],
            ),
          ),
          Text(
            pr['value'],
            style: StravoTypography.bodyBold.copyWith(
              color: pr['color'] as Color,
              fontFeatures: StravoTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
