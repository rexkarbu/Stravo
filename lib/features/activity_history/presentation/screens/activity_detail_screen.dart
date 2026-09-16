import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/gradient_button.dart';
import 'package:stravo/core/widgets/metric_stat_tile.dart';
import 'package:stravo/core/widgets/route_graphics.dart';
import 'package:stravo/core/widgets/stravo_card.dart';
import 'package:stravo/core/widgets/surface_type_badge.dart';
import 'package:stravo/features/activity_history/domain/models/activity_item_model.dart';
import 'package:stravo/features/map_3d/presentation/screens/flyover_player_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  final ActivityItemModel activity;

  const ActivityDetailScreen({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 20),
                  _buildPrimaryMetricsCard(),
                  const SizedBox(height: 20),
                  _buildSurfaceCompositionCard(),
                  const SizedBox(height: 20),
                  _buildElevationProfileSection(),
                  const SizedBox(height: 20),
                  if (activity.photos.isNotEmpty) ...[
                    _buildWaypointGallery(),
                    const SizedBox(height: 20),
                  ],
                  _buildSocialExportButtons(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      backgroundColor: StravoColors.background,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: StravoColors.surface.withValues(alpha: 0.8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: StravoColors.surface.withValues(alpha: 0.8),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 18),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Map / Route Visualizer Canvas
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF0A0C10),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: MiniRouteThumbnail(
                points: activity.routePoints,
                strokeColor: StravoColors.orangePrimary,
                strokeWidth: 3.5,
              ),
            ),

            // Top gradient overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      StravoColors.background.withValues(alpha: 0.95),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Floating Flyover 3D Button
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Flyover3dPlayerScreen(
                        title: activity.title,
                        routePoints: activity.routePoints,
                        elevationProfile: activity.elevationProfile,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: StravoColors.surfaceElevated.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: StravoColors.cyberGreen.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: StravoColors.cyberGreen.withValues(alpha: 0.15),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded,
                          color: StravoColors.cyberGreen, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'PUTAR 3D FLYOVER REPLAY',
                        style: StravoTypography.buttonText.copyWith(
                          fontSize: 13,
                          color: StravoColors.cyberGreen,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SurfaceTypeBadge(type: activity.primarySurface),
            Text(
              activity.formattedDate,
              style: StravoTypography.caption,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          activity.title,
          style: StravoTypography.h1.copyWith(fontSize: 26),
        ),
      ],
    );
  }

  Widget _buildPrimaryMetricsCard() {
    return StravoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MetricStatTile(
                label: 'JARAK TOTAL',
                value: activity.distanceKm.toStringAsFixed(1),
                unit: 'KM',
                valueColor: StravoColors.orangePrimary,
              ),
              MetricStatTile(
                label: 'WAKTU TEMPUH',
                value: activity.formattedDuration,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Divider(color: StravoColors.divider, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MetricStatTile(
                label: 'ELEVASI NAIK',
                value: '${activity.elevationGainMeters}',
                unit: 'M',
                valueColor: StravoColors.cyberGreen,
              ),
              MetricStatTile(
                label: 'KECEPATAN PUNCAK',
                value: activity.maxSpeedKmh.toStringAsFixed(1),
                unit: 'KM/H',
                valueColor: StravoColors.neonCyan,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSurfaceCompositionCard() {
    final gravelPercent = (activity.gravelRatio * 100).toInt();
    final pavedPercent = 100 - gravelPercent;

    return StravoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KOMPOSISI PERMUKAAN',
                style: StravoTypography.metricLabel,
              ),
              Text(
                '$gravelPercent% Gravel / $pavedPercent% Aspal',
                style: StravoTypography.caption.copyWith(
                  color: StravoColors.cyberGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Split Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: gravelPercent,
                    child: Container(color: StravoColors.cyberGreen),
                  ),
                  Expanded(
                    flex: pavedPercent,
                    child: Container(color: StravoColors.neonCyan),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSurfaceLegendItem(
                color: StravoColors.cyberGreen,
                label: 'Gravel & Makadam',
                pct: '$gravelPercent%',
              ),
              const SizedBox(width: 20),
              _buildSurfaceLegendItem(
                color: StravoColors.neonCyan,
                label: 'Aspal Mulus',
                pct: '$pavedPercent%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSurfaceLegendItem({
    required Color color,
    required String label,
    required String pct,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($pct)',
          style: StravoTypography.caption.copyWith(color: StravoColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildElevationProfileSection() {
    return StravoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROFIL ELEVASI RUTE',
                style: StravoTypography.metricLabel,
              ),
              Row(
                children: [
                  const Icon(Icons.arrow_upward, size: 14, color: StravoColors.cyberGreen),
                  Text(
                    '+${activity.elevationGainMeters}m',
                    style: StravoTypography.caption.copyWith(
                      color: StravoColors.cyberGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevationProfileChart(
            elevations: activity.elevationProfile,
            height: 130,
            primaryColor: StravoColors.orangePrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildWaypointGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FOTO WAYPOINT GEOTAG',
          style: StravoTypography.metricLabel,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: activity.photos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: StravoColors.surfaceElevated,
                  border: Border.all(color: StravoColors.glassBorder),
                  image: DecorationImage(
                    image: NetworkImage(activity.photos[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialExportButtons(BuildContext context) {
    return Column(
      children: [
        StravoGradientButton(
          label: 'Buat Video Rekap (MP4)',
          icon: Icons.movie_filter_outlined,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Membuka Footage Generator Sheet...'),
                backgroundColor: StravoColors.surfaceElevated,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.camera_alt_outlined, color: StravoColors.neonCyan),
            label: Text(
              'Share Instagram Story',
              style: StravoTypography.buttonText.copyWith(
                color: StravoColors.neonCyan,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: StravoColors.neonCyan, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menyiapkan Story Card 9:16...'),
                  backgroundColor: StravoColors.surfaceElevated,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
