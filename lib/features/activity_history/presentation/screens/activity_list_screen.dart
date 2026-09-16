import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/metric_stat_tile.dart';
import 'package:stravo/core/widgets/route_graphics.dart';
import 'package:stravo/core/widgets/stravo_card.dart';
import 'package:stravo/core/widgets/surface_type_badge.dart';
import 'package:stravo/features/activity_history/domain/models/activity_item_model.dart';
import 'package:stravo/features/activity_history/presentation/screens/activity_detail_screen.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  String _selectedFilter = 'Semua';
  late final List<ActivityItemModel> _allActivities;

  final List<String> _filters = const [
    'Semua',
    'Gravel',
    'Road',
    'MTB',
    'Run',
    'Hike',
  ];

  @override
  void initState() {
    super.initState();
    _allActivities = ActivityItemModel.getMockActivities();
  }

  List<ActivityItemModel> get _filteredActivities {
    if (_selectedFilter == 'Semua') {
      return _allActivities;
    }
    return _allActivities
        .where((act) => act.activityType.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildWeeklySummaryCard()),
            SliverToBoxAdapter(child: _buildFilterPills()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            _buildActivityList(),
            const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AKTIVITAS SAYA',
                style: StravoTypography.caption.copyWith(
                  letterSpacing: 2.0,
                  color: StravoColors.orangePrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Riwayat Sesi',
                style: StravoTypography.h2,
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: StravoColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: StravoColors.glassBorder),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: StravoColors.textSecondary),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1B2232),
              Color(0xFF10141D),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: StravoColors.orangePrimary.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: StravoColors.orangePrimary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: StravoColors.orangePrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: StravoColors.orangePrimary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MINGGU INI',
                      style: StravoTypography.caption.copyWith(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                        color: StravoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: StravoColors.cyberGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: StravoColors.cyberGreen.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_upward, size: 12, color: StravoColors.cyberGreen),
                      const SizedBox(width: 4),
                      Text(
                        '+18% vs lalu',
                        style: StravoTypography.caption.copyWith(
                          color: StravoColors.cyberGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '145.4',
                  style: StravoTypography.h1.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    fontFeatures: StravoTypography.tabularFigures,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'KM',
                  style: StravoTypography.h3.copyWith(
                    color: StravoColors.orangePrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: StravoColors.divider, height: 1),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MetricStatTile(
                  label: 'TOTAL WAKTU',
                  value: '6j 14m',
                ),
                MetricStatTile(
                  label: 'ELEVASI NAIK',
                  value: '2,250',
                  unit: 'M',
                  valueColor: StravoColors.cyberGreen,
                ),
                MetricStatTile(
                  label: 'SESI',
                  value: '4',
                  unit: 'RIDE',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            showCheckmark: false,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : StravoColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
            backgroundColor: StravoColors.surface,
            selectedColor: StravoColors.orangePrimary,
            side: BorderSide(
              color: isSelected
                  ? StravoColors.orangePrimary
                  : StravoColors.glassBorder,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedFilter = filter);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = _filteredActivities;

    if (activities.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const Icon(Icons.directions_bike_outlined,
                  size: 48, color: StravoColors.textDisabled),
              const SizedBox(height: 12),
              Text(
                'Tidak ada aktivitas untuk kategori $_selectedFilter',
                style: StravoTypography.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final activity = activities[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _ActivityCard(
              activity: activity,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityDetailScreen(activity: activity),
                  ),
                );
              },
            ),
          );
        },
        childCount: activities.length,
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivityItemModel activity;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StravoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title & Surface Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: StravoTypography.h3.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.formattedDate,
                      style: StravoTypography.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SurfaceTypeBadge(type: activity.primarySurface),
            ],
          ),
          const SizedBox(height: 14),

          // Center: Mini Map & Key Metrics
          Row(
            children: [
              // Mini Route Thumbnail
              Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: StravoColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: StravoColors.glassBorder),
                ),
                padding: const EdgeInsets.all(6),
                child: MiniRouteThumbnail(
                  points: activity.routePoints,
                  strokeColor: activity.activityType == 'Gravel'
                      ? StravoColors.cyberGreen
                      : StravoColors.orangePrimary,
                ),
              ),
              const SizedBox(width: 16),

              // Metrics 2x2
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MetricStatTile(
                          label: 'JARAK',
                          value: activity.distanceKm.toStringAsFixed(1),
                          unit: 'KM',
                          valueColor: StravoColors.textPrimary,
                        ),
                        MetricStatTile(
                          label: 'WAKTU',
                          value: activity.formattedDuration,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MetricStatTile(
                          label: 'ELEVASI',
                          value: '${activity.elevationGainMeters}',
                          unit: 'M',
                          valueColor: StravoColors.cyberGreen,
                        ),
                        MetricStatTile(
                          label: 'RATA-RATA',
                          value: activity.avgSpeedKmh.toStringAsFixed(1),
                          unit: 'KM/H',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (activity.photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.photo_camera_outlined,
                    size: 14, color: StravoColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  '${activity.photos.length} foto momen tersimpan',
                  style: StravoTypography.caption.copyWith(
                    color: StravoColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
