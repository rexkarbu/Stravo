import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/neon_speedometer_gauge.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _HeroTelemetry(),
                    SizedBox(height: 24),
                    _BentoGridMetrics(),
                  ],
                ),
              ),
            ),
            _buildBottomControls(),
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
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: StravoColors.cyberGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: StravoColors.cyberGreen,
                      blurRadius: 8,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVE GPS',
                style: StravoTypography.metricLabel,
              ),
            ],
          ),
          Text(
            'STAGE 04: ALPINE CRIT',
            style: StravoTypography.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Row(
            children: [
              Icon(Icons.favorite, size: 16, color: StravoColors.neonPink),
              SizedBox(width: 8),
              Icon(Icons.speed, size: 16, color: StravoColors.neonYellow),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            StravoColors.background,
            StravoColors.background.withOpacity(0.0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPillButton(
            label: 'LAP',
            color: StravoColors.surfaceElevated,
            textColor: Colors.white,
            icon: Icons.flag,
          ),
          _buildPillButton(
            label: 'PAUSE RIDE',
            color: StravoColors.neonPink,
            textColor: Colors.black,
            icon: Icons.pause,
            isPrimary: true,
          ),
          _buildPillButton(
            label: 'MAP',
            color: StravoColors.surfaceElevated,
            textColor: Colors.white,
            icon: Icons.map,
          ),
        ],
      ),
    );
  }

  Widget _buildPillButton({
    required String label,
    required Color color,
    required Color textColor,
    IconData? icon,
    bool isPrimary = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isPrimary ? 32 : 24,
        vertical: isPrimary ? 18 : 16,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: StravoTypography.bodyBold.copyWith(
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroTelemetry extends StatelessWidget {
  const _HeroTelemetry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: NeonSpeedometerGauge(
        currentSpeed: 38.4,
        maxSpeed: 60.0,
      ),
    );
  }
}

class _BentoGridMetrics extends StatelessWidget {
  const _BentoGridMetrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricPillCard(
                color: StravoColors.cyberGreen,
                textColor: Colors.black,
                value: '164',
                unit: 'BPM',
                label: 'ZONE 4 // THRESHOLD',
                icon: Icons.favorite,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricPillCard(
                color: StravoColors.neonYellow,
                textColor: Colors.black,
                value: '96',
                unit: 'RPM',
                label: 'OPTIMAL CADENCE',
                icon: Icons.rotate_right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricPillCard(
                color: StravoColors.neonPink,
                textColor: Colors.black,
                value: '342',
                unit: 'W',
                label: '4.8 W/KG',
                icon: Icons.flash_on,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricPillCard(
                color: StravoColors.surfaceElevated,
                textColor: Colors.white,
                value: '+840',
                unit: 'M',
                label: '+12% GRADE',
                icon: Icons.terrain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _MetricPillCard(
          color: StravoColors.surface,
          textColor: Colors.white,
          value: '46.8',
          unit: 'KM',
          label: 'DISTANCE',
          isWide: true,
          icon: Icons.route,
          borderColor: StravoColors.glassBorder,
        ),
      ],
    );
  }
}

class _MetricPillCard extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String value;
  final String unit;
  final String label;
  final IconData icon;
  final bool isWide;
  final Color? borderColor;

  const _MetricPillCard({
    Key? key,
    required this.color,
    required this.textColor,
    required this.value,
    required this.unit,
    required this.label,
    required this.icon,
    this.isWide = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWide ? 24.0 : 20.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40), // Extreme pill-shaped radius
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: textColor, size: 24),
              Text(
                label,
                style: StravoTypography.caption.copyWith(
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
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
                value,
                style: StravoTypography.metricValue.copyWith(
                  color: textColor,
                  fontSize: isWide ? 42 : 36,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: StravoTypography.metricUnit.copyWith(
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
