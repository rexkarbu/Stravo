import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/camera_3d_controller.dart';
import '../domain/models/colored_route_segment.dart';

/// States for the terrain map.
enum TerrainMapState { loading, ready, error, rebuilding }

/// WebView widget that displays a MapLibre GL JS 3D terrain map.
///
/// Communicates with the JavaScript map via a JSON bridge channel
/// called 'StravoBridge'.
class TerrainMapWebView extends StatefulWidget {
  /// The local server base URL (e.g., http://127.0.0.1:12345).
  final String baseUrl;

  /// Called when the map state changes.
  final ValueChanged<TerrainMapState>? onStateChanged;

  /// Called when the map reports an error.
  final ValueChanged<String>? onError;

  /// Called when a network leak is detected.
  final ValueChanged<String>? onLeakDetected;

  /// Called when map_ready fires with diagnostic data.
  final ValueChanged<Map<String, dynamic>>? onMapReady;

  const TerrainMapWebView({
    super.key,
    required this.baseUrl,
    this.onStateChanged,
    this.onError,
    this.onLeakDetected,
    this.onMapReady,
  });

  @override
  State<TerrainMapWebView> createState() => TerrainMapWebViewState();
}

class TerrainMapWebViewState extends State<TerrainMapWebView>
    with WidgetsBindingObserver {
  late WebViewController _controller;
  TerrainMapState _state = TerrainMapState.loading;
  int _reloadCount = 0;
  static const int _maxReloads = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'StravoBridge',
        onMessageReceived: _handleBridgeMessage,
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          debugPrint('[TerrainMapWebView] Page started: $url');
        },
        onPageFinished: (url) {
          debugPrint('[TerrainMapWebView] Page finished: $url');
        },
        onWebResourceError: (error) {
          debugPrint(
              '[TerrainMapWebView] Resource error: ${error.description} (${error.errorCode})');
        },
      ));

    if (kDebugMode) {
      final platform = _controller.platform;
      if (platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
      }
    }

    _controller.loadRequest(Uri.parse('${widget.baseUrl}/map'));
  }

  void _handleBridgeMessage(JavaScriptMessage message) {
    if (!mounted) return;

    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      final event = data['event'] as String?;

      debugPrint('[TerrainMapWebView] Bridge event: $event');

      switch (event) {
        case 'map_state':
          final state = data['state'] as String?;
          if (state == 'loading') {
            _updateState(TerrainMapState.loading);
          } else if (state == 'rebuilding') {
            _updateState(TerrainMapState.rebuilding);
          }
          break;

        case 'map_ready':
          final state = data['state'] as String?;
          if (state == 'ready') {
            _updateState(TerrainMapState.ready);
            widget.onMapReady?.call(data);
          } else {
            _updateState(TerrainMapState.error);
            widget.onError?.call('Map ready reported invalid state: $state');
          }
          break;

        case 'map_error':
          _updateState(TerrainMapState.error);
          widget.onError?.call(data['message'] as String? ?? 'Unknown error');
          break;

        case 'leak_detected':
          final url = data['url'] as String? ?? 'Unknown';
          debugPrint('[TerrainMapWebView] LEAK DETECTED: $url');
          widget.onLeakDetected?.call(url);
          break;

        case 'context_lost':
          debugPrint(
              '[TerrainMapWebView] WebGL context lost (${data['count']})');
          break;

        case 'context_restored':
          debugPrint('[TerrainMapWebView] WebGL context restored');
          break;
      }
    } catch (e) {
      debugPrint('[TerrainMapWebView] Bridge parse error: $e');
    }
  }

  void _updateState(TerrainMapState newState) {
    if (!mounted) return;
    if (_state != newState) {
      setState(() => _state = newState);
      widget.onStateChanged?.call(newState);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.resumed && _state == TerrainMapState.ready) {
      // Check if WebGL context is still valid after resume
      _controller.runJavaScript('''
        if (window.stravoApi) {
          try {
            var s = JSON.parse(window.stravoApi.getState());
            if (!s.ready || s.contextLost) {
              window.rebuildMap && window.rebuildMap();
            }
          } catch(e) {}
        }
      ''');
    }
  }

  /// Attempts to reload the WebView if the map is in error state.
  void tryReload() {
    if (!mounted || _reloadCount >= _maxReloads) {
      debugPrint('[TerrainMapWebView] Max reloads reached');
      return;
    }
    _reloadCount++;
    _updateState(TerrainMapState.loading);
    _controller.reload();
  }

  /// Queries terrain elevation at given coordinates via JS bridge.
  Future<double?> queryElevation(double lng, double lat) async {
    try {
      final result = await _controller.runJavaScriptReturningResult(
        'window.stravoApi.queryElevation($lng, $lat)',
      );
      final data = jsonDecode(result.toString()) as Map<String, dynamic>;
      return (data['elevation'] as num?)?.toDouble();
    } catch (e) {
      debugPrint('[TerrainMapWebView] queryElevation error: $e');
      return null;
    }
  }

  /// Sets terrain enabled/disabled with optional exaggeration.
  Future<void> setTerrain(bool enabled, {double exaggeration = 1.0}) async {
    await _controller.runJavaScript(
      'window.stravoApi.setTerrain($enabled, $exaggeration)',
    );
  }

  /// Converts a list of [ColoredRouteSegment]s into a GeoJSON FeatureCollection string.
  static String segmentsToGeoJson(List<ColoredRouteSegment> segments) {
    final features = segments.map((seg) => {
      'type': 'Feature',
      'geometry': {
        'type': 'LineString',
        'coordinates': seg.toCoordinatesList(),
      },
      'properties': {
        'color': seg.hexColor,
        if (seg.metricValue != null) 'metric': seg.metricValue,
        if (seg.surfaceType != null) 'surface': seg.surfaceType!.name,
      },
    }).toList();

    return jsonEncode({
      'type': 'FeatureCollection',
      'features': features,
    });
  }

  /// Sends route polyline segments to MapLibre to be rendered in 3D terrain.
  Future<void> setRouteSegments(List<ColoredRouteSegment> segments) async {
    final geoJson = segmentsToGeoJson(segments);
    final jsArg = jsonEncode(geoJson);
    await _controller.runJavaScript('window.stravoApi && window.stravoApi.setRouteGeoJson($jsArg)');
  }

  /// Clears any currently displayed route polyline from the map.
  Future<void> clearRoute() async {
    await _controller.runJavaScript('window.stravoApi && window.stravoApi.clearRoute()');
  }

  /// Updates the 3D camera pose instantaneously (jumpTo) for 60 FPS flyover replay.
  Future<void> setCameraPose(Camera3DState state) async {
    await _controller.runJavaScript(
      'window.stravoApi && window.stravoApi.setCameraPose(${state.longitude}, ${state.latitude}, ${state.zoom}, ${state.pitch}, ${state.bearing})',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_state == TerrainMapState.error)
          Positioned.fill(
            child: Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Terrain verification failed',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    if (_reloadCount < _maxReloads)
                      ElevatedButton.icon(
                        onPressed: tryReload,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
