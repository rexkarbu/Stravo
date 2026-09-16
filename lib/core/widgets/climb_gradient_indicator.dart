import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';

class ClimbGradientIndicator extends StatelessWidget {
  final double gradientPercentage;

  const ClimbGradientIndicator({
    super.key,
    required this.gradientPercentage,
  });

  @override
  Widget build(BuildContext context) {
    Color indicatorColor;
    String category;

    if (gradientPercentage < 4.0) {
      indicatorColor = StravoColors.cyberGreen;
      category = 'Cat 4';
    } else if (gradientPercentage <= 8.0) {
      indicatorColor = StravoColors.neonYellow;
      category = 'Cat 3';
    } else if (gradientPercentage <= 13.0) {
      indicatorColor = StravoColors.orangePrimary;
      category = 'Cat 2';
    } else {
      indicatorColor = StravoColors.neonPink;
      category = 'HC';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: indicatorColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: indicatorColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up,
            color: indicatorColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${gradientPercentage.toStringAsFixed(1)}% ($category)',
            style: StravoTypography.bodyBold.copyWith(
              color: indicatorColor,
              fontFeatures: StravoTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
