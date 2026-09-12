import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/stravo_card.dart';
import 'package:stravo/core/widgets/gradient_button.dart';
import 'package:stravo/core/widgets/metric_stat_tile.dart';
import 'package:stravo/core/widgets/neon_speedometer_gauge.dart';
import 'package:stravo/core/widgets/surface_type_badge.dart';
import 'package:stravo/core/widgets/climb_gradient_indicator.dart';
import 'package:stravo/core/widgets/ghost_pacer_badge.dart';

class DesignSystemCatalogScreen extends StatelessWidget {
  const DesignSystemCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      appBar: AppBar(
        title: const Text('Design System Catalog', style: StravoTypography.h3),
        backgroundColor: StravoColors.backgroundSecondary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSectionTitle('Speedometer Gauge'),
          const Center(
            child: NeonSpeedometerGauge(
              currentSpeed: 32.4,
              maxSpeed: 60.0,
            ),
          ),
          const SizedBox(height: 32),

          _buildSectionTitle('Badges & Indicators'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              SurfaceTypeBadge(type: SurfaceType.smoothAsphalt),
              SurfaceTypeBadge(type: SurfaceType.fineGravel),
              SurfaceTypeBadge(type: SurfaceType.roughMacadam),
              SurfaceTypeBadge(type: SurfaceType.singletrack),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              ClimbGradientIndicator(gradientPercentage: 3.5),
              ClimbGradientIndicator(gradientPercentage: 6.2),
              ClimbGradientIndicator(gradientPercentage: 11.0),
              ClimbGradientIndicator(gradientPercentage: 15.4),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              GhostPacerBadge(timeDifferenceSeconds: 2.4),
              GhostPacerBadge(timeDifferenceSeconds: -1.8),
            ],
          ),
          const SizedBox(height: 32),

          _buildSectionTitle('Buttons'),
          StravoGradientButton(
            label: 'START ACTIVITY',
            icon: Icons.play_arrow,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          StravoGradientButton(
            label: 'DISABLED BUTTON',
            onPressed: null,
          ),
          const SizedBox(height: 12),
          StravoGradientButton(
            label: 'LOADING BUTTON',
            isLoading: true,
            onPressed: () {},
          ),
          const SizedBox(height: 32),

          _buildSectionTitle('Glassmorphism Cards & Metrics'),
          StravoCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                MetricStatTile(
                  label: 'Distance',
                  value: '24.8',
                  unit: 'km',
                ),
                MetricStatTile(
                  label: 'Time',
                  value: '01:02:18',
                ),
                MetricStatTile(
                  label: 'Elev',
                  value: '480',
                  unit: 'm',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          _buildSectionTitle('Color Palette'),
          _buildColorRow('Background', StravoColors.background),
          _buildColorRow('Surface', StravoColors.surface),
          _buildColorRow('Orange Primary', StravoColors.orangePrimary),
          _buildColorRow('Cyber Green', StravoColors.cyberGreen),
          _buildColorRow('Electric Cyan', StravoColors.electricCyan),
          _buildColorRow('Neon Yellow', StravoColors.neonYellow),
          _buildColorRow('Neon Pink', StravoColors.neonPink),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: StravoTypography.h2.copyWith(color: StravoColors.orangePrimary),
      ),
    );
  }

  Widget _buildColorRow(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
          ),
          const SizedBox(width: 16),
          Text(name, style: StravoTypography.bodyBold),
        ],
      ),
    );
  }
}
