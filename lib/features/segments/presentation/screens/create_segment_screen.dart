import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/gradient_button.dart';
import 'package:stravo/core/widgets/metric_stat_tile.dart';
import 'package:stravo/core/widgets/route_graphics.dart';
import 'package:stravo/core/widgets/stravo_card.dart';

class CreateSegmentScreen extends StatefulWidget {
  final List<Offset> routePoints;

  const CreateSegmentScreen({
    super.key,
    this.routePoints = const [
      Offset(15, 60),
      Offset(30, 45),
      Offset(45, 30),
      Offset(60, 25),
      Offset(75, 40),
      Offset(85, 65),
      Offset(70, 80),
      Offset(40, 75),
    ],
  });

  @override
  State<CreateSegmentScreen> createState() => _CreateSegmentScreenState();
}

class _CreateSegmentScreenState extends State<CreateSegmentScreen> {
  late final TextEditingController _nameController;
  double _startTrim = 0.15; // 0.0 to 1.0
  double _endTrim = 0.75; // 0.0 to 1.0

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Tanjakan Bukit Kaliurang');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segmentDistance = (8.4 * (_endTrim - _startTrim)).clamp(0.2, 100.0);
    final segmentElevation = (380 * (_endTrim - _startTrim)).toInt();
    final gradient = ((segmentElevation / (segmentDistance * 1000)) * 100).clamp(1.0, 25.0);

    return Scaffold(
      backgroundColor: StravoColors.background,
      appBar: AppBar(
        backgroundColor: StravoColors.background,
        elevation: 0,
        title: Text(
          'BUAT SEGMEN BARU',
          style: StravoTypography.h3.copyWith(fontSize: 16, letterSpacing: 1.2),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Trimmer Area
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F141C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: StravoColors.glassBorder),
                ),
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    MiniRouteThumbnail(
                      points: widget.routePoints,
                      strokeColor: StravoColors.cyberGreen,
                      strokeWidth: 3.5,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: StravoColors.surface.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: StravoColors.glassBorder),
                        ),
                        child: Text(
                          'Geser slider di bawah untuk memotong rute',
                          style: StravoTypography.caption.copyWith(fontSize: 10, color: StravoColors.textSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Trimmer Range Slider
              Text('TITIK START & FINISH SEGMEN', style: StravoTypography.metricLabel),
              const SizedBox(height: 8),
              RangeSlider(
                values: RangeValues(_startTrim, _endTrim),
                activeColor: StravoColors.orangePrimary,
                inactiveColor: StravoColors.surfaceElevated,
                onChanged: (values) {
                  if (values.end - values.start >= 0.1) {
                    setState(() {
                      _startTrim = values.start;
                      _endTrim = values.end;
                    });
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start: ${(_startTrim * 100).toInt()}%', style: StravoTypography.caption),
                  Text('Finish: ${(_endTrim * 100).toInt()}%', style: StravoTypography.caption),
                ],
              ),
              const SizedBox(height: 20),

              // Segment Live Stats Card
              StravoCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MetricStatTile(
                      label: 'JARAK SEGMEN',
                      value: segmentDistance.toStringAsFixed(1),
                      unit: 'KM',
                      valueColor: StravoColors.orangePrimary,
                    ),
                    MetricStatTile(
                      label: 'ELEVASI',
                      value: '$segmentElevation',
                      unit: 'M',
                      valueColor: StravoColors.cyberGreen,
                    ),
                    MetricStatTile(
                      label: 'GRADIEN',
                      value: gradient.toStringAsFixed(1),
                      unit: '%',
                      valueColor: StravoColors.neonYellow,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Segment Name Input
              Text('NAMA SEGMEN', style: StravoTypography.metricLabel),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: StravoColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: StravoColors.glassBorder),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Tanjakan Sektor 5 Makadam',
                    hintStyle: TextStyle(color: StravoColors.textDisabled),
                    prefixIcon: Icon(Icons.flag_outlined, color: StravoColors.orangePrimary, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              StravoGradientButton(
                label: 'Simpan Segmen',
                icon: Icons.check,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Segmen "${_nameController.text}" berhasil dibuat!'),
                      backgroundColor: StravoColors.surfaceElevated,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
