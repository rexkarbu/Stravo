import 'package:flutter/material.dart';

import 'server/demo_pack_manager.dart';
import 'server/local_tile_server.dart';
import '../../core/constants/enums.dart';
import 'domain/calculators/polyline_color_calculator.dart';
import 'domain/models/colored_route_segment.dart';
import 'domain/models/route_coordinate.dart';
import 'widgets/terrain_map_webview.dart';

/// Demo Spike entry point for 3D Terrain Proof-of-Concept.
///
/// Proves MapLibre GL JS 4.7.1 in Android WebView can render real
/// geometric terrain and hillshading from local MBTiles offline.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DemoSpikeApp());
}

class DemoSpikeApp extends StatelessWidget {
  const DemoSpikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stravo 3D Terrain Spike',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFC5200), // Strava orange
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const DemoMainPage(),
    );
  }
}

class DemoMainPage extends StatefulWidget {
  const DemoMainPage({super.key});

  @override
  State<DemoMainPage> createState() => _DemoMainPageState();
}

class _DemoMainPageState extends State<DemoMainPage> {
  final DemoPackManager _packManager = DemoPackManager();
  final LocalTileServer _server = LocalTileServer();

  String _status = 'Initializing...';
  String? _serverUrl;
  String? _errorMessage;
  TerrainMapState _mapState = TerrainMapState.loading;
  Map<String, bool>? _assetStatus;
  Map<String, dynamic>? _readyData;
  final GlobalKey<TerrainMapWebViewState> _webKey = GlobalKey<TerrainMapWebViewState>();
  String _activePolylineMode = 'Off';

  // Realistic sample route around Kamojang Crater (20 GPS trackpoints)
  static final List<RouteCoordinate> _kamojangRoute = [
    RouteCoordinate(latitude: -7.1550, longitude: 107.7800, elevation: 1420.0, speed: 6.0, surfaceType: SurfaceType.asphalt),
    RouteCoordinate(latitude: -7.1545, longitude: 107.7820, elevation: 1435.0, speed: 6.5, surfaceType: SurfaceType.asphalt),
    RouteCoordinate(latitude: -7.1538, longitude: 107.7845, elevation: 1450.0, speed: 5.5, surfaceType: SurfaceType.asphalt),
    RouteCoordinate(latitude: -7.1530, longitude: 107.7870, elevation: 1475.0, speed: 4.8, surfaceType: SurfaceType.smoothGravel),
    RouteCoordinate(latitude: -7.1520, longitude: 107.7895, elevation: 1510.0, speed: 4.0, surfaceType: SurfaceType.smoothGravel),
    RouteCoordinate(latitude: -7.1510, longitude: 107.7920, elevation: 1545.0, speed: 3.5, surfaceType: SurfaceType.smoothGravel),
    RouteCoordinate(latitude: -7.1505, longitude: 107.7945, elevation: 1580.0, speed: 3.2, surfaceType: SurfaceType.roughGravel),
    RouteCoordinate(latitude: -7.1500, longitude: 107.7970, elevation: 1615.0, speed: 3.0, surfaceType: SurfaceType.roughGravel),
    RouteCoordinate(latitude: -7.1502, longitude: 107.7995, elevation: 1640.0, speed: 3.4, surfaceType: SurfaceType.roughGravel),
    RouteCoordinate(latitude: -7.1510, longitude: 107.8015, elevation: 1675.0, speed: 3.8, surfaceType: SurfaceType.dirt), // Summit
    RouteCoordinate(latitude: -7.1525, longitude: 107.8030, elevation: 1660.0, speed: 6.5, surfaceType: SurfaceType.dirt),
    RouteCoordinate(latitude: -7.1540, longitude: 107.8040, elevation: 1630.0, speed: 9.0, surfaceType: SurfaceType.dirt),
    RouteCoordinate(latitude: -7.1560, longitude: 107.8035, elevation: 1590.0, speed: 11.0, surfaceType: SurfaceType.roughGravel),
    RouteCoordinate(latitude: -7.1580, longitude: 107.8015, elevation: 1550.0, speed: 12.5, surfaceType: SurfaceType.roughGravel),
    RouteCoordinate(latitude: -7.1595, longitude: 107.7985, elevation: 1515.0, speed: 13.5, surfaceType: SurfaceType.smoothGravel),
    RouteCoordinate(latitude: -7.1605, longitude: 107.7950, elevation: 1485.0, speed: 12.0, surfaceType: SurfaceType.smoothGravel),
    RouteCoordinate(latitude: -7.1600, longitude: 107.7910, elevation: 1460.0, speed: 10.0, surfaceType: SurfaceType.cobblestone),
    RouteCoordinate(latitude: -7.1585, longitude: 107.7870, elevation: 1445.0, speed: 8.5, surfaceType: SurfaceType.cobblestone),
    RouteCoordinate(latitude: -7.1570, longitude: 107.7835, elevation: 1430.0, speed: 7.5, surfaceType: SurfaceType.asphalt),
    RouteCoordinate(latitude: -7.1550, longitude: 107.7800, elevation: 1420.0, speed: 6.0, surfaceType: SurfaceType.asphalt),
  ];

  void _applyPolylineMode(String mode) {
    if (!mounted) return;
    setState(() => _activePolylineMode = mode);

    if (mode == 'Off') {
      _webKey.currentState?.clearRoute();
      return;
    }

    PolylineColorMode colorMode;
    switch (mode) {
      case 'Speed Heat':
        colorMode = PolylineColorMode.speedHeat;
        break;
      case 'Elevation':
        colorMode = PolylineColorMode.elevationGradient;
        break;
      case 'Surface':
        colorMode = PolylineColorMode.surfaceType;
        break;
      default:
        return;
    }

    final segments = PolylineColorCalculator.calculate(
      route: _kamojangRoute,
      mode: colorMode,
    );
    _webKey.currentState?.setRouteSegments(segments);
  }

  int _initGeneration = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final generation = ++_initGeneration;
    bool isStale() => !mounted || generation != _initGeneration;

    try {
      if (mounted) {
        setState(() {
          _status = 'Extracting and verifying demo assets...';
          _errorMessage = null;
        });
      }

      // Step 1: Extract and verify assets with SHA-256 validation
      await _packManager.initialize();
      if (isStale()) {
        await _server.stop();
        return;
      }

      // Step 2: Check asset availability
      _assetStatus = await _packManager.checkAssets();
      if (isStale()) {
        await _server.stop();
        return;
      }

      if (mounted) {
        setState(() {
          _status = 'Assets verified. Starting tile server...';
        });
      }

      final mbtilesPaths = _packManager.getMbtilesPaths();
      if (!mbtilesPaths.containsKey('dem')) {
        throw DemoPackException(
          'Required dem.mbtiles not found or failed validation in ${_packManager.packDir}',
        );
      }

      // Step 3: Start tile server
      await _server.start(
        mbtilesPaths: mbtilesPaths,
        staticDir: _packManager.packDir,
        engineDir: _packManager.engineDir,
      );
      if (isStale()) {
        await _server.stop();
        return;
      }

      if (mounted) {
        setState(() {
          _serverUrl = _server.baseUrl;
          _status = 'Server running on ${_server.baseUrl}';
        });
      }
    } catch (e, stack) {
      debugPrint('[DemoMainPage] Init error: $e\n$stack');
      await _server.stop();
      if (isStale()) return;

      if (mounted) {
        setState(() {
          _status = 'Error';
          _errorMessage = '$e';
        });
      }
    }
  }

  @override
  void dispose() {
    _initGeneration++; // Invalidate pending init runs
    _server.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Stravo 3D Terrain Demo'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(
              _mapState == TerrainMapState.ready
                  ? Icons.check_circle
                  : _mapState == TerrainMapState.error
                      ? Icons.error
                      : Icons.hourglass_top,
              color: _mapState == TerrainMapState.ready
                  ? Colors.greenAccent
                  : _mapState == TerrainMapState.error
                      ? Colors.redAccent
                      : Colors.amber,
            ),
            onPressed: _showDiagnostics,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null && _serverUrl == null) {
      return _buildErrorView();
    }

    if (_serverUrl == null) {
      return _buildLoadingView();
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              TerrainMapWebView(
                key: _webKey,
                baseUrl: _serverUrl!,
                onStateChanged: (state) {
                  if (mounted) setState(() => _mapState = state);
                },
                onError: (msg) {
                  if (mounted) setState(() => _errorMessage = msg);
                },
                onLeakDetected: (url) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('External request blocked: $url'),
                        backgroundColor: Colors.red.shade800,
                      ),
                    );
                  }
                },
                onMapReady: (data) {
                  if (mounted) {
                    setState(() => _readyData = data);
                    if (_activePolylineMode != 'Off') {
                      _applyPolylineMode(_activePolylineMode);
                    }
                  }
                },
              ),
              // Floating Polyline Mode Selector
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                      boxShadow: const [
                        BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ['Off', 'Speed Heat', 'Elevation', 'Surface'].map((mode) {
                        final isSelected = _activePolylineMode == mode;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: InkWell(
                            onTap: () => _applyPolylineMode(mode),
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.greenAccent.shade700 : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                mode,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Status bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.black87,
          child: Row(
            children: [
              Icon(
                _mapState == TerrainMapState.ready
                    ? Icons.terrain
                    : _mapState == TerrainMapState.error
                        ? Icons.error_outline
                        : Icons.pending,
                color: _mapState == TerrainMapState.ready
                    ? Colors.greenAccent
                    : _mapState == TerrainMapState.error
                        ? Colors.redAccent
                        : Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _status,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_errorMessage != null && _serverUrl != null)
                const Icon(Icons.warning_amber, color: Colors.amber, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.greenAccent),
          const SizedBox(height: 24),
          Text(
            _status,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Unknown error',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _errorMessage = null;
                    _status = 'Retrying...';
                  });
                }
                _initialize();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDiagnostics() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Diagnostics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            _diagRow('Server', _server.isRunning ? _server.baseUrl : 'Stopped'),
            _diagRow('Map State', _mapState.name),
            _diagRow('MapLibre', 'GL JS 4.7.1'),
            if (_assetStatus != null) ...[
              const SizedBox(height: 8),
              const Text('Assets:',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              ..._assetStatus!.entries.map((e) => _diagRow(
                    '  ${e.key}',
                    e.value ? 'Present' : 'Missing',
                  )),
            ],
            if (_readyData != null) ...[
              const SizedBox(height: 8),
              if (_readyData!['elevation'] != null)
                _diagRow('Terrain Elev', '${_readyData!['elevation']} m'),
              _diagRow('Tile Errors', '${_readyData!['tileErrors'] ?? 0}'),
              if (_readyData!['center'] != null)
                _diagRow('Center', '${_readyData!['center']}'),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _diagRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
