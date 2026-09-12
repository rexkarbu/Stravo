import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';

/// Reusable Telemetry Metric Stat Tile
/// Komponen UI murni oleh Ray (Lead UI/UX)
class MetricStatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color? valueColor;
  final CrossAxisAlignment crossAxisAlignment;

  const MetricStatTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.valueColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: StravoTypography.metricLabel,
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: StravoTypography.metricValue.copyWith(
                color: valueColor ?? StravoColors.textPrimary,
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!,
                style: StravoTypography.metricUnit,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
