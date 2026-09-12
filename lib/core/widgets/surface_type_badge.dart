import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';

enum SurfaceType {
  smoothAsphalt,
  fineGravel,
  roughMacadam,
  singletrack
}

class SurfaceTypeBadge extends StatelessWidget {
  final SurfaceType type;

  const SurfaceTypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String label;

    switch (type) {
      case SurfaceType.smoothAsphalt:
        badgeColor = StravoColors.textSecondary; // Greyish
        label = 'Aspal Mulus';
        break;
      case SurfaceType.fineGravel:
        badgeColor = StravoColors.cyberGreen; // Gravel signature color
        label = 'Gravel Halus';
        break;
      case SurfaceType.roughMacadam:
        badgeColor = StravoColors.orangePrimary; // Warning/rough
        label = 'Makadam Kasar';
        break;
      case SurfaceType.singletrack:
        badgeColor = StravoColors.neonPink; // Extreme
        label = 'Singletrack';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: StravoTypography.caption.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
