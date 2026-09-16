import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/route_graphics.dart';

class Flyover3dPlayerScreen extends StatefulWidget {
  final String title;
  final List<Offset> routePoints;
  final List<double> elevationProfile;

  const Flyover3dPlayerScreen({
    super.key,
    this.title = 'Morning Pine Gravel Loop',
    this.routePoints = const [
      Offset(15, 60),
      Offset(30, 35),
      Offset(55, 20),
      Offset(80, 45),
      Offset(85, 75),
      Offset(50, 80),
      Offset(15, 60),
    ],
    this.elevationProfile = const [320, 360, 450, 580, 620, 540, 410, 320],
  });

  @override
  State<Flyover3dPlayerScreen> createState() => _Flyover3dPlayerScreenState();
}

class _Flyover3dPlayerScreenState extends State<Flyover3dPlayerScreen> {
  bool _isPlaying = true;
  double _progress = 0.35; // 0.0 to 1.0
  int _speedMultiplier = 2; // 1x, 2x, 4x, 8x
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _startPlayback();
  }

  void _startPlayback() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPlaying) {
        setState(() {
          _progress += (0.005 * _speedMultiplier);
          if (_progress > 1.0) {
            _progress = 0.0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _cycleSpeed() {
    setState(() {
      if (_speedMultiplier == 1) {
        _speedMultiplier = 2;
      } else if (_speedMultiplier == 2) {
        _speedMultiplier = 4;
      } else if (_speedMultiplier == 4) {
        _speedMultiplier = 8;
      } else {
        _speedMultiplier = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDistance = (widget.routePoints.length * 4.2 * _progress);
    final currentSpeed = 24.5 + (8.0 * (_progress % 0.3));
    final currentAlt = 320 + (300 * _progress);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 3D Wireframe / Terrain Viewport Simulation
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 1.2,
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF0A0C10),
                    Colors.black,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _TerrainGridPainter(progress: _progress),
              ),
            ),
          ),

          // Route Polyline Glowing in 3D Perspective
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
              child: MiniRouteThumbnail(
                points: widget.routePoints,
                strokeColor: StravoColors.orangePrimary,
                strokeWidth: 4.0,
              ),
            ),
          ),

          // Top Bar: Back, Title, Mode
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: StravoColors.surface.withValues(alpha: 0.7),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: StravoColors.surface.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: StravoColors.glassBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: StravoColors.cyberGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '3D FLYOVER REPLAY',
                            style: StravoTypography.caption.copyWith(
                              color: StravoColors.cyberGreen,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: StravoColors.surface.withValues(alpha: 0.7),
                      child: IconButton(
                        icon: const Icon(Icons.cameraswitch_outlined, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Telemetry HUD (Transparan Glass)
          Positioned(
            top: 90,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: StravoColors.surface.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: StravoColors.glassBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHudMetric('SPEED', '${currentSpeed.toStringAsFixed(1)} KM/H', StravoColors.textPrimary),
                  const SizedBox(height: 8),
                  _buildHudMetric('DIST', '${currentDistance.toStringAsFixed(1)} KM', StravoColors.orangePrimary),
                  const SizedBox(height: 8),
                  _buildHudMetric('ELEV', '${currentAlt.toInt()} M', StravoColors.cyberGreen),
                  const SizedBox(height: 8),
                  _buildHudMetric('GRADIENT', '+5.4% (Cat 3)', StravoColors.neonYellow),
                ],
              ),
            ),
          ),

          // Bottom Controls & Scrubber Slider
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Scrubber Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: StravoColors.orangePrimary,
                      inactiveTrackColor: StravoColors.surfaceElevated,
                      thumbColor: Colors.white,
                      overlayColor: StravoColors.orangePrimary.withValues(alpha: 0.2),
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    ),
                    child: Slider(
                      value: _progress.clamp(0.0, 1.0),
                      onChanged: (val) {
                        setState(() => _progress = val);
                      },
                    ),
                  ),

                  // Play/Pause & Speed Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Speed Multiplier Button
                      InkWell(
                        onTap: _cycleSpeed,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: StravoColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: StravoColors.glassBorder),
                          ),
                          child: Text(
                            '${_speedMultiplier}X',
                            style: const TextStyle(
                              color: StravoColors.orangePrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      // Center Play/Pause button
                      InkWell(
                        onTap: _togglePlay,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: StravoColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: StravoColors.orangePrimary.withValues(alpha: 0.4),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),

                      // Camera angle switch
                      IconButton(
                        icon: const Icon(Icons.fullscreen, color: Colors.white, size: 26),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHudMetric(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: StravoTypography.caption.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: StravoColors.textMuted,
          ),
        ),
        Text(
          value,
          style: StravoTypography.bodyBold.copyWith(
            fontSize: 12,
            color: color,
            fontFeatures: StravoTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TerrainGridPainter extends CustomPainter {
  final double progress;

  _TerrainGridPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1A00FF9D)
      ..strokeWidth = 1.0;

    const int cols = 12;
    final stepX = size.width / cols;

    for (int i = 0; i <= cols; i++) {
      final x = i * stepX;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    const int rows = 18;
    final stepY = size.height / rows;
    for (int j = 0; j <= rows; j++) {
      final y = j * stepY;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TerrainGridPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
