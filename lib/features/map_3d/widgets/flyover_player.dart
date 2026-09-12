import 'package:flutter/material.dart';
import '../../../../app/theme/stravo_colors.dart';
import '../controllers/camera_3d_controller.dart';

/// Interactive 3D cinematic flyover replay player and floating telemetry HUD.
///
/// Features:
/// - Floating transparent HUD displaying real-time speed, elevation, gradient, and distance.
/// - Scrubber slider (0.0 to 1.0) with bidirectional seeking.
/// - Play/pause toggle with smooth 60 FPS animation loop.
/// - Speed chips: 1x, 2x, 4x, 8x playback rate.
/// - Synchronized callback [onCameraUpdate] triggering camera movements on every frame.
class FlyoverPlayer extends StatefulWidget {
  /// The 3D camera controller generating smooth Catmull-Rom route positions.
  final Camera3DController controller;

  /// Invoked on every animation frame or scrubber drag with the new camera state.
  final ValueChanged<Camera3DState>? onCameraUpdate;

  /// Base duration for 1x playback speed.
  final Duration baseDuration;

  /// Whether playback starts automatically on widget initialization.
  final bool autoPlay;

  const FlyoverPlayer({
    super.key,
    required this.controller,
    this.onCameraUpdate,
    this.baseDuration = const Duration(seconds: 40),
    this.autoPlay = false,
  });

  @override
  State<FlyoverPlayer> createState() => FlyoverPlayerState();
}

class FlyoverPlayerState extends State<FlyoverPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Camera3DState _currentState;
  double _speedMultiplier = 1.0;

  Camera3DState get currentState => _currentState;
  bool get isPlaying => _animController.isAnimating;
  double get speedMultiplier => _speedMultiplier;

  @override
  void initState() {
    super.initState();
    _currentState = widget.controller.getStateAtProgress(0.0);

    _animController = AnimationController(
      vsync: this,
      duration: widget.baseDuration,
    )..addListener(_handleTick)
     ..addStatusListener(_handleStatus);

    if (widget.autoPlay) {
      _animController.forward();
    }
  }

  void _handleTick() {
    final progress = _animController.value;
    final state = widget.controller.getStateAtProgress(progress);
    setState(() => _currentState = state);
    widget.onCameraUpdate?.call(state);
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animController.forward(from: 0.0);
    }
  }

  /// Toggles between play and pause.
  void togglePlayPause() {
    setState(() {
      if (_animController.isAnimating) {
        _animController.stop();
      } else {
        if (_animController.isCompleted || _animController.value >= 1.0) {
          _animController.forward(from: 0.0);
        } else {
          _animController.forward();
        }
      }
    });
  }

  /// Seeks to a specific progress position [0.0, 1.0].
  void seek(double progress) {
    final clamped = progress.clamp(0.0, 1.0);
    _animController.value = clamped;
  }

  /// Sets the playback speed multiplier (1.0, 2.0, 4.0, 8.0).
  void setSpeed(double multiplier) {
    if (multiplier <= 0) return;
    setState(() {
      _speedMultiplier = multiplier;
      final currentVal = _animController.value;
      final newDurationMs = (widget.baseDuration.inMilliseconds / multiplier).round();
      _animController.duration = Duration(milliseconds: mathMax(100, newDurationMs));
      if (_animController.isAnimating) {
        _animController.forward(from: currentVal);
      }
    });
  }

  int mathMax(int a, int b) => a > b ? a : b;

  @override
  void didUpdateWidget(FlyoverPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _currentState = widget.controller.getStateAtProgress(_animController.value);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top HUD Overlay
        _buildTelemetryHud(),
        // Bottom Interactive Control Bar
        _buildControlBar(),
      ],
    );
  }

  Widget _buildTelemetryHud() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 56, left: 16, right: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xCC0A0C10), // OLED glass dark
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 1.0),
            boxShadow: const [
              BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHudItem(
                label: 'SPEED',
                value: '${_currentState.speedKmH.toStringAsFixed(1)} km/h',
                valueKey: 'hud_speed_text',
                accentColor: StravoColors.cyberGreen,
                icon: Icons.speed,
              ),
              _buildDivider(),
              _buildHudItem(
                label: 'ELEVATION',
                value: '${_currentState.elevation.toStringAsFixed(0)} m',
                valueKey: 'hud_elevation_text',
                accentColor: StravoColors.electricCyan,
                icon: Icons.terrain,
              ),
              _buildDivider(),
              _buildHudItem(
                label: 'GRADIENT',
                value: '${_currentState.gradientPercent >= 0 ? '+' : ''}${_currentState.gradientPercent.toStringAsFixed(1)}%',
                valueKey: 'hud_gradient_text',
                accentColor: StravoColors.neonYellow,
                icon: Icons.trending_up,
              ),
              _buildDivider(),
              _buildHudItem(
                label: 'DISTANCE',
                value: '${(_currentState.distanceMeters / 1000.0).toStringAsFixed(2)} km',
                valueKey: 'hud_distance_text',
                accentColor: StravoColors.orangePrimary,
                icon: Icons.straighten,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHudItem({
    required String label,
    required String value,
    required String valueKey,
    required Color accentColor,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white54),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          key: Key(valueKey),
          style: TextStyle(
            color: accentColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white12,
    );
  }

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xE60A0C10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 1.0),
          boxShadow: const [
            BoxShadow(color: Colors.black87, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scrubber Slider
            Row(
              children: [
                IconButton(
                  key: const Key('flyover_play_pause_button'),
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: StravoColors.cyberGreen,
                    size: 32,
                  ),
                  onPressed: togglePlayPause,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: StravoColors.orangePrimary,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      trackHeight: 3.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider(
                      key: const Key('flyover_slider'),
                      value: _animController.value.clamp(0.0, 1.0),
                      onChanged: (val) {
                        seek(val);
                      },
                    ),
                  ),
                ),
                Text(
                  '${(_animController.value * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Speed Multiplier Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1.0, 2.0, 4.0, 8.0].map((mult) {
                final isSelected = _speedMultiplier == mult;
                final label = '${mult.toInt()}x';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    key: Key('speed_$label'),
                    onTap: () => setSpeed(mult),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? StravoColors.orangePrimary : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.white70 : Colors.transparent,
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
