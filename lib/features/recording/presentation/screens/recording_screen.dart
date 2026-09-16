import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/neon_speedometer_gauge.dart';
import 'package:stravo/features/recording/presentation/screens/activity_save_summary_screen.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool _isPaused = false;

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _finishRide() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ActivitySaveSummaryScreen(),
      ),
    );
  }

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
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: StravoColors.textSecondary, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 10),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _isPaused ? StravoColors.neonYellow : StravoColors.cyberGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _isPaused ? StravoColors.neonYellow : StravoColors.cyberGreen,
                      blurRadius: 8,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isPaused ? 'TERJEDA' : 'GPS LOCKED',
                style: StravoTypography.caption.copyWith(
                  color: _isPaused ? StravoColors.neonYellow : StravoColors.cyberGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
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
            StravoColors.background.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: _isPaused ? _buildPausedControls() : _buildActiveControls(),
    );
  }

  Widget _buildActiveControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPillButton(
          label: 'LAP',
          color: StravoColors.surfaceElevated,
          textColor: Colors.white,
          icon: Icons.flag,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lap dicatat!'), duration: Duration(seconds: 1)),
            );
          },
        ),
        _buildPillButton(
          label: 'PAUSE RIDE',
          color: StravoColors.neonPink,
          textColor: Colors.black,
          icon: Icons.pause,
          isPrimary: true,
          onTap: _togglePause,
        ),
        _buildPillButton(
          label: 'KAMERA',
          color: StravoColors.surfaceElevated,
          textColor: Colors.white,
          icon: Icons.camera_alt_outlined,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Geotag Photo Captured!'), duration: Duration(seconds: 1)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPausedControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPillButton(
          label: 'RESUME',
          color: StravoColors.cyberGreen,
          textColor: Colors.black,
          icon: Icons.play_arrow,
          isPrimary: true,
          onTap: _togglePause,
        ),
        _buildPillButton(
          label: 'FINISH & SIMPAN',
          color: StravoColors.orangePrimary,
          textColor: Colors.white,
          icon: Icons.stop,
          isPrimary: true,
          onTap: _finishRide,
        ),
      ],
    );
  }

  Widget _buildPillButton({
    required String label,
    required Color color,
    required Color textColor,
    IconData? icon,
    bool isPrimary = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isPrimary ? 28 : 20,
          vertical: isPrimary ? 16 : 14,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 18,
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
