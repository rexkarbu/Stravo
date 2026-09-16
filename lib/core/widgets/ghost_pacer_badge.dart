import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';

class GhostPacerBadge extends StatelessWidget {
  final double timeDifferenceSeconds;

  const GhostPacerBadge({
    super.key,
    required this.timeDifferenceSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final isAhead = timeDifferenceSeconds >= 0;
    
    // Ahead is good (Green/Cyan), Behind is bad (Red/Pink)
    final badgeColor = isAhead ? StravoColors.cyberGreen : StravoColors.neonPink;
    
    final sign = isAhead ? '+' : '';
    final label = isAhead ? 'ahead' : 'behind';
    final formattedTime = '$sign${timeDifferenceSeconds.toStringAsFixed(1)}s $label';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAhead ? Icons.keyboard_double_arrow_up : Icons.keyboard_double_arrow_down,
            color: badgeColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            formattedTime,
            style: StravoTypography.bodyBold.copyWith(
              color: badgeColor,
              fontFeatures: StravoTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
