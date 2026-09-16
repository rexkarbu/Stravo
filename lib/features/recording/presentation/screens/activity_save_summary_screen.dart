import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/gradient_button.dart';
import 'package:stravo/core/widgets/metric_stat_tile.dart';
import 'package:stravo/core/widgets/route_graphics.dart';
import 'package:stravo/core/widgets/stravo_card.dart';
import 'package:stravo/core/widgets/surface_type_badge.dart';

class ActivitySaveSummaryScreen extends StatefulWidget {
  final double distanceKm;
  final Duration duration;
  final int elevationGainMeters;
  final double avgSpeedKmh;
  final List<Offset> routePoints;
  final SurfaceType surfaceType;

  const ActivitySaveSummaryScreen({
    super.key,
    this.distanceKm = 36.4,
    this.duration = const Duration(hours: 1, minutes: 28, seconds: 45),
    this.elevationGainMeters = 540,
    this.avgSpeedKmh = 24.6,
    this.routePoints = const [
      Offset(15, 60),
      Offset(30, 35),
      Offset(55, 20),
      Offset(80, 45),
      Offset(85, 75),
      Offset(50, 80),
      Offset(15, 60),
    ],
    this.surfaceType = SurfaceType.fineGravel,
  });

  @override
  State<ActivitySaveSummaryScreen> createState() => _ActivitySaveSummaryScreenState();
}

class _ActivitySaveSummaryScreenState extends State<ActivitySaveSummaryScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  String _selectedGear = 'Canyon Grizl CF SL 8 (Gravel)';
  String _selectedVisibility = 'Semua Orang';

  final List<String> _gearOptions = const [
    'Canyon Grizl CF SL 8 (Gravel)',
    'Specialized Allez Sprint (Road)',
    'Trek Fuel EX (MTB)',
    'Hoka Speedgoat 5 (Trail Run)',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final hour = now.hour;
    String timeOfDay = 'Pagi';
    if (hour >= 11 && hour < 15) {
      timeOfDay = 'Siang';
    } else if (hour >= 15 && hour < 18) {
      timeOfDay = 'Sore';
    } else if (hour >= 18 || hour < 5) {
      timeOfDay = 'Malam';
    }

    _titleController = TextEditingController(text: 'Gravel $timeOfDay Santai');
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      appBar: AppBar(
        backgroundColor: StravoColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: StravoColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SIMPAN AKTIVITAS',
          style: StravoTypography.h3.copyWith(
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Buang',
              style: StravoTypography.caption.copyWith(
                color: StravoColors.neonPink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route Preview Card
              _buildRoutePreviewCard(),
              const SizedBox(height: 20),

              // Title input
              Text(
                'JUDUL AKTIVITAS',
                style: StravoTypography.metricLabel,
              ),
              const SizedBox(height: 8),
              _buildTextInput(
                controller: _titleController,
                hintText: 'Beri nama aktivitas Anda...',
                prefixIcon: Icons.edit_outlined,
              ),
              const SizedBox(height: 18),

              // Description input
              Text(
                'CATATAN / KONDISI TREK',
                style: StravoTypography.metricLabel,
              ),
              const SizedBox(height: 8),
              _buildTextInput(
                controller: _descController,
                hintText: 'Bagaimana rasanya rute hari ini? Cuaca, tekanan ban, dll...',
                maxLines: 3,
              ),
              const SizedBox(height: 18),

              // Gear Selection Dropdown
              Text(
                'PILIHAN SEPEDA / SEPATU',
                style: StravoTypography.metricLabel,
              ),
              const SizedBox(height: 8),
              _buildGearSelector(),
              const SizedBox(height: 18),

              // Privacy & Visibility
              Text(
                'VISIBILITAS AKTIVITAS',
                style: StravoTypography.metricLabel,
              ),
              const SizedBox(height: 8),
              _buildVisibilitySelector(),
              const SizedBox(height: 32),

              // Save Action Button
              StravoGradientButton(
                label: 'Simpan Aktivitas',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aktivitas "${_titleController.text}" berhasil disimpan!'),
                      backgroundColor: StravoColors.surfaceElevated,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutePreviewCard() {
    final hours = widget.duration.inHours;
    final minutes = widget.duration.inMinutes.remainder(60);
    final durationStr = hours > 0 ? '${hours}j ${minutes}m' : '${minutes}m';

    return StravoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mini Route Thumbnail
              Container(
                width: 110,
                height: 90,
                decoration: BoxDecoration(
                  color: StravoColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: StravoColors.glassBorder),
                ),
                padding: const EdgeInsets.all(6),
                child: MiniRouteThumbnail(
                  points: widget.routePoints,
                  strokeColor: StravoColors.orangePrimary,
                ),
              ),
              const SizedBox(width: 16),

              // Key Stats
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MetricStatTile(
                          label: 'JARAK',
                          value: widget.distanceKm.toStringAsFixed(1),
                          unit: 'KM',
                          valueColor: StravoColors.orangePrimary,
                        ),
                        MetricStatTile(
                          label: 'DURASI',
                          value: durationStr,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MetricStatTile(
                          label: 'ELEVASI',
                          value: '${widget.elevationGainMeters}',
                          unit: 'M',
                          valueColor: StravoColors.cyberGreen,
                        ),
                        MetricStatTile(
                          label: 'RATA-RATA',
                          value: widget.avgSpeedKmh.toStringAsFixed(1),
                          unit: 'KM/H',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurfaceTypeBadge(type: widget.surfaceType),
              Row(
                children: [
                  const Icon(Icons.offline_pin_outlined, size: 14, color: StravoColors.cyberGreen),
                  const SizedBox(width: 4),
                  Text(
                    'Tersimpan Offline (SQLite)',
                    style: StravoTypography.caption.copyWith(
                      color: StravoColors.cyberGreen,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: StravoColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StravoColors.glassBorder),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: StravoColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: StravoColors.textDisabled,
            fontSize: 14,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: StravoColors.textSecondary, size: 20)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGearSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: StravoColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StravoColors.glassBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGear,
          isExpanded: true,
          dropdownColor: StravoColors.surfaceElevated,
          icon: const Icon(Icons.keyboard_arrow_down, color: StravoColors.textSecondary),
          style: const TextStyle(
            color: StravoColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: _gearOptions.map((gear) {
            return DropdownMenuItem<String>(
              value: gear,
              child: Row(
                children: [
                  const Icon(Icons.pedal_bike, size: 18, color: StravoColors.orangePrimary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      gear,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedGear = val);
          },
        ),
      ),
    );
  }

  Widget _buildVisibilitySelector() {
    final visibilities = ['Semua Orang', 'Pengikut Saja', 'Hanya Saya'];

    return Row(
      children: visibilities.map((vis) {
        final isSelected = _selectedVisibility == vis;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () => setState(() => _selectedVisibility = vis),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? StravoColors.orangePrimary.withValues(alpha: 0.15)
                      : StravoColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? StravoColors.orangePrimary
                        : StravoColors.glassBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    vis,
                    style: TextStyle(
                      color: isSelected ? StravoColors.orangePrimary : StravoColors.textSecondary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
