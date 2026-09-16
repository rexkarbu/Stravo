import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/features/map_3d/presentation/screens/offline_map_manager_screen.dart';

class ExploreMapScreen extends StatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  bool _isHeatmapEnabled = true;
  bool _is3dPerspective = true;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _nearbySegments = [
    {
      'title': 'Tanjakan Karetan HC',
      'distance': '2.4 KM',
      'gradient': '11.8%',
      'category': 'Cat 2',
      'pr': '8m 42s',
      'surface': 'Gravel',
    },
    {
      'title': 'Pine Forest Sprint',
      'distance': '1.2 KM',
      'gradient': '3.2%',
      'category': 'Cat 4',
      'pr': '2m 15s',
      'surface': 'Makadam',
    },
    {
      'title': 'Kopeng KOM Challenge',
      'distance': '5.8 KM',
      'gradient': '8.5%',
      'category': 'Cat 1',
      'pr': '22m 10s',
      'surface': 'Aspal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      body: Stack(
        children: [
          // 3D Map Viewport simulation
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0D1117),
              child: CustomPaint(
                painter: _ExploreMapPainter(
                  showHeatmap: _isHeatmapEnabled,
                  is3d: _is3dPerspective,
                ),
              ),
            ),
          ),

          // Floating Search Bar at Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 10),
                    _buildLayerFilterChips(),
                  ],
                ),
              ),
            ),
          ),

          // Right Floating Control Action Buttons
          Positioned(
            right: 16,
            bottom: 230,
            child: Column(
              children: [
                _buildMapActionButton(
                  icon: _is3dPerspective ? Icons.view_in_ar : Icons.layers,
                  tooltip: 'Toggle 3D View',
                  isActive: _is3dPerspective,
                  onTap: () {
                    setState(() => _is3dPerspective = !_is3dPerspective);
                  },
                ),
                const SizedBox(height: 12),
                _buildMapActionButton(
                  icon: Icons.whatshot,
                  tooltip: 'Personal Heatmap',
                  isActive: _isHeatmapEnabled,
                  activeColor: StravoColors.orangePrimary,
                  onTap: () {
                    setState(() => _isHeatmapEnabled = !_isHeatmapEnabled);
                  },
                ),
                const SizedBox(height: 12),
                _buildMapActionButton(
                  icon: Icons.download_for_offline_outlined,
                  tooltip: 'Paket Peta Offline',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OfflineMapManagerScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Nearby Segments Carousel Sheet
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SEGMEN TERDEKAT',
                        style: StravoTypography.caption.copyWith(
                          color: StravoColors.textSecondary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '3 Ditemukan',
                        style: StravoTypography.caption.copyWith(
                          color: StravoColors.cyberGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    final filtered = _nearbySegments.where((seg) {
                      if (_searchQuery.isEmpty) return true;
                      return (seg['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
                    }).toList();

                    return SizedBox(
                      height: 135,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final seg = filtered[index];
                          return _buildSegmentCard(seg);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: StravoColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StravoColors.glassBorder),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 14),
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Cari tanjakan, rute gravel, atau segmen...',
          hintStyle: const TextStyle(color: StravoColors.textDisabled, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: StravoColors.orangePrimary, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: StravoColors.textSecondary, size: 18),
            onPressed: () {},
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLayerFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Tanjakan (Climbs)', Icons.trending_up, true),
          const SizedBox(width: 8),
          _buildFilterChip('Rute Gravel', Icons.terrain, true),
          const SizedBox(width: 8),
          _buildFilterChip('Segmen PR Saya', Icons.star_outline, false),
          const SizedBox(width: 8),
          _buildFilterChip('Water Point', Icons.local_drink_outlined, false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? StravoColors.surfaceElevated.withValues(alpha: 0.95)
            : StravoColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? StravoColors.cyberGreen.withValues(alpha: 0.5) : StravoColors.glassBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: active ? StravoColors.cyberGreen : StravoColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : StravoColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isActive = false,
    Color activeColor = StravoColors.cyberGreen,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: StravoColors.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? activeColor : StravoColors.glassBorder,
              width: isActive ? 1.5 : 1.0,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                    ),
                  ]
                : const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
          ),
          child: Icon(
            icon,
            color: isActive ? activeColor : StravoColors.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentCard(Map<String, dynamic> seg) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: StravoColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StravoColors.glassBorder),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  seg['title'],
                  style: StravoTypography.bodyBold.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: StravoColors.orangePrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  seg['category'],
                  style: const TextStyle(
                    color: StravoColors.orangePrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSegStat(Icons.straighten, seg['distance']),
              const SizedBox(width: 12),
              _buildSegStat(Icons.trending_up, seg['gradient'], color: StravoColors.neonYellow),
              const SizedBox(width: 12),
              _buildSegStat(Icons.emoji_events_outlined, seg['pr'], color: StravoColors.cyberGreen),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Permukaan: ${seg['surface']}',
                style: StravoTypography.caption.copyWith(fontSize: 10),
              ),
              const Icon(Icons.arrow_forward, size: 14, color: StravoColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegStat(IconData icon, String val, {Color color = Colors.white}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          val,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ExploreMapPainter extends CustomPainter {
  final bool showHeatmap;
  final bool is3d;

  _ExploreMapPainter({required this.showHeatmap, required this.is3d});

  @override
  void paint(Canvas canvas, Size size) {
    // Topo contour lines simulation
    final topoPaint = Paint()
      ..color = const Color(0x18334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 6; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.45, size.height * 0.4),
        i * 60.0,
        topoPaint,
      );
    }

    // Heatmap paths
    if (showHeatmap) {
      final heatmapGlow = Paint()
        ..color = StravoColors.orangePrimary.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round;

      final heatmapCore = Paint()
        ..color = StravoColors.neonYellow.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(size.width * 0.1, size.height * 0.7)
        ..cubicTo(size.width * 0.3, size.height * 0.5, size.width * 0.4, size.height * 0.3, size.width * 0.8, size.height * 0.45)
        ..lineTo(size.width * 0.9, size.height * 0.2);

      canvas.drawPath(path, heatmapGlow);
      canvas.drawPath(path, heatmapCore);
    }

    // Segments markers
    final pinPaint = Paint()..color = StravoColors.cyberGreen;
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.35), 6, pinPaint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.35), 2.5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant _ExploreMapPainter oldDelegate) =>
      oldDelegate.showHeatmap != showHeatmap || oldDelegate.is3d != is3d;
}
