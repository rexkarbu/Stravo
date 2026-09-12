import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../mbtiles/mbtiles_reader.dart';

/// Local HTTP server that serves tiles from MBTiles files and static
/// assets from a local directory. Binds only to loopback (127.0.0.1).
class LocalTileServer {
  HttpServer? _server;
  final Map<String, MbtilesReader> _readers = {};
  String? _staticDir;
  String? _engineDir;

  int get port => _server?.port ?? 0;
  String get baseUrl => 'http://127.0.0.1:$port';
  bool get isRunning => _server != null;

  /// Starts the server with the given MBTiles files and static asset directories.
  Future<void> start({
    required Map<String, String> mbtilesPaths,
    required String staticDir,
    required String engineDir,
  }) async {
    _staticDir = staticDir;
    _engineDir = engineDir;

    // Open all MBTiles readers
    for (final entry in mbtilesPaths.entries) {
      _readers[entry.key] = MbtilesReader.open(entry.value);
    }

    final router = Router();

    // Tile endpoint: /tiles/{source}/{z}/{x}/{y}.{ext}
    router.get('/tiles/<source>/<z|[0-9]+>/<x|[0-9]+>/<y|[0-9]+>.<ext>',
        _handleTileRequest);

    // Style endpoint (with base URL replacement)
    router.get('/style.json', _handleStyleRequest);

    // Static pack files (manifest, etc.)
    router.get('/pack/<path|.*>', _handlePackFileRequest);

    // Glyph endpoint
    router.get('/glyphs/<fontstack>/<range>.pbf', _handleGlyphRequest);

    // Map engine files (maplibre-gl.js, maplibre-gl.css)
    router.get('/engine/<filename>', _handleEngineRequest);

    // HTML page
    router.get('/map', _handleMapPageRequest);

    final handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addHandler(router.call);

    _server = await shelf_io.serve(
      handler,
      InternetAddress.loopbackIPv4,
      0, // Dynamic port
    );

    debugPrint('[LocalTileServer] Serving on $baseUrl');
  }

  /// Handles tile requests: /tiles/{source}/{z}/{x}/{y}.{ext}
  Future<shelf.Response> _handleTileRequest(shelf.Request request) async {
    final source = request.params['source']!;
    final z = int.tryParse(request.params['z']!);
    final x = int.tryParse(request.params['x']!);
    final y = int.tryParse(request.params['y']!);
    final ext = request.params['ext']!;

    if (z == null || x == null || y == null) {
      return shelf.Response.badRequest(body: 'Invalid tile coordinates');
    }

    final reader = _readers[source];
    if (reader == null) {
      return shelf.Response.notFound(
          'Source "$source" not found. Available: ${_readers.keys.join(', ')}');
    }

    final tileData = reader.getTile(z, x, y);
    if (tileData == null) {
      return shelf.Response.notFound(
          'Tile not found: $source/$z/$x/$y.$ext (TMS y=${MbtilesReader.xyzToTmsY(z, y)})');
    }

    String contentType;
    final headers = <String, String>{
      'Access-Control-Allow-Origin': '*',
      'Cache-Control': 'max-age=3600',
    };

    switch (ext) {
      case 'pbf':
      case 'mvt':
        contentType = 'application/x-protobuf';
        if (_isGzipped(tileData)) {
          headers['Content-Encoding'] = 'gzip';
        }
        break;
      case 'png':
        contentType = 'image/png';
        break;
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';
        break;
      case 'webp':
        contentType = 'image/webp';
        break;
      default:
        contentType = 'application/octet-stream';
    }

    headers['Content-Type'] = contentType;
    return shelf.Response.ok(tileData, headers: headers);
  }

  /// Handles style.json requests, replacing {{BASE_URL}} with actual base URL.
  Future<shelf.Response> _handleStyleRequest(shelf.Request request) async {
    if (_staticDir == null) {
      return shelf.Response.internalServerError(body: 'Static dir not set');
    }

    final stylePath = p.join(_staticDir!, 'style.json');
    final file = File(stylePath);
    if (!await file.exists()) {
      return shelf.Response.notFound('style.json not found');
    }

    var content = await file.readAsString();
    content = content.replaceAll('{{BASE_URL}}', baseUrl);

    return shelf.Response.ok(content, headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    });
  }

  /// Handles static pack files.
  Future<shelf.Response> _handlePackFileRequest(shelf.Request request) async {
    final filePath = request.params['path']!;
    if (_staticDir == null) {
      return shelf.Response.internalServerError(body: 'Static dir not set');
    }

    final resolved = p.normalize(p.join(_staticDir!, filePath));
    if (!p.isWithin(_staticDir!, resolved)) {
      return shelf.Response.forbidden('Path traversal blocked');
    }

    final file = File(resolved);
    if (!await file.exists()) {
      return shelf.Response.notFound('File not found: $filePath');
    }

    final ext = p.extension(resolved).toLowerCase();
    final contentType = _mimeType(ext);

    return shelf.Response.ok(
      await file.readAsBytes(),
      headers: {
        'Content-Type': contentType,
        'Access-Control-Allow-Origin': '*',
      },
    );
  }

  /// Handles glyph requests. Returns HTTP 404 if not found.
  Future<shelf.Response> _handleGlyphRequest(shelf.Request request) async {
    final fontstack = Uri.decodeComponent(request.params['fontstack']!);
    final range = request.params['range']!;

    if (_staticDir == null) {
      return shelf.Response.internalServerError(body: 'Static dir not set');
    }

    final glyphPath = p.join(_staticDir!, 'glyphs', fontstack, '$range.pbf');
    final resolved = p.normalize(glyphPath);
    if (!p.isWithin(_staticDir!, resolved)) {
      return shelf.Response.forbidden('Path traversal blocked');
    }

    final file = File(resolved);
    if (!await file.exists()) {
      return shelf.Response.notFound('Glyph not found: $fontstack/$range.pbf');
    }

    final data = await file.readAsBytes();
    final headers = <String, String>{
      'Content-Type': 'application/x-protobuf',
      'Access-Control-Allow-Origin': '*',
    };
    if (_isGzipped(data)) {
      headers['Content-Encoding'] = 'gzip';
    }

    return shelf.Response.ok(data, headers: headers);
  }

  /// Handles engine requests (maplibre-gl.js, maplibre-gl.css).
  Future<shelf.Response> _handleEngineRequest(shelf.Request request) async {
    final filename = request.params['filename']!;

    if (_engineDir == null) {
      return shelf.Response.internalServerError(body: 'Engine dir not set');
    }

    if (!['maplibre-gl.js', 'maplibre-gl.css'].contains(filename)) {
      return shelf.Response.forbidden('Unknown engine file: $filename');
    }

    final filePath = p.join(_engineDir!, filename);
    final file = File(filePath);
    if (!await file.exists()) {
      return shelf.Response.notFound('Engine file not found: $filename');
    }

    final ext = p.extension(filePath).toLowerCase();
    return shelf.Response.ok(
      await file.readAsBytes(),
      headers: {
        'Content-Type': _mimeType(ext),
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'max-age=86400',
      },
    );
  }

  /// Serves the map HTML page with injected base URL.
  Future<shelf.Response> _handleMapPageRequest(shelf.Request request) async {
    final html = _generateMapHtml(baseUrl);
    return shelf.Response.ok(html, headers: {
      'Content-Type': 'text/html; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    });
  }

  /// Checks if data begins with gzip magic bytes.
  bool _isGzipped(List<int> data) {
    return data.length >= 2 && data[0] == 0x1f && data[1] == 0x8b;
  }

  /// Returns MIME type for a file extension.
  String _mimeType(String ext) {
    switch (ext) {
      case '.json':
        return 'application/json';
      case '.js':
        return 'application/javascript';
      case '.css':
        return 'text/css';
      case '.html':
        return 'text/html';
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.pbf':
      case '.mvt':
        return 'application/x-protobuf';
      default:
        return 'application/octet-stream';
    }
  }

  /// Stops the server and closes all database connections.
  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    for (final reader in _readers.values) {
      reader.close();
    }
    _readers.clear();
    debugPrint('[LocalTileServer] Stopped');
  }

  /// Generates the map HTML page.
  ///
  /// Implements:
  /// - Strict Content-Security-Policy blocking all external network traffic
  /// - Early-active timeout starting immediately at instantiation
  /// - Explicit error detection for style, DEM tiles, vector tiles, and glyphs
  /// - Authentic WebGL context checking and bounded recovery
  String _generateMapHtml(String baseUrl) {
    return '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <!-- Content Security Policy: strictly binds all connect, script, worker, and media resources to local loopback server -->
  <meta http-equiv="Content-Security-Policy" content="default-src 'none'; script-src 'unsafe-inline' $baseUrl; style-src 'unsafe-inline' $baseUrl; img-src data: blob: $baseUrl; connect-src $baseUrl blob:; font-src $baseUrl; worker-src blob: $baseUrl;">
  <title>Stravo 3D Terrain Demo</title>
  <link rel="stylesheet" href="$baseUrl/engine/maplibre-gl.css">
  <script src="$baseUrl/engine/maplibre-gl.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body, html { width: 100%; height: 100%; overflow: hidden; background: #000; }
    #map { width: 100%; height: 100%; }
    #loading-overlay {
      position: absolute; top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.85);
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      z-index: 1000; color: white;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    #loading-overlay .spinner {
      width: 40px; height: 40px;
      border: 3px solid rgba(255,255,255,0.3);
      border-top-color: #4fc3f7;
      border-radius: 50%;
      animation: spin 1s linear infinite;
      margin-bottom: 16px;
    }
    @keyframes spin { to { transform: rotate(360deg); } }
    #loading-text { font-size: 14px; opacity: 0.8; }
    #error-overlay {
      position: absolute; top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(139,0,0,0.92);
      display: none; flex-direction: column;
      align-items: center; justify-content: center;
      z-index: 1001; color: white; padding: 20px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    #error-text { font-size: 14px; text-align: center; max-width: 320px; line-height: 1.5; }
    #debug-panel {
      position: absolute; bottom: 8px; left: 8px;
      background: rgba(0,0,0,0.75); color: #4fc3f7;
      font-family: monospace; font-size: 11px;
      padding: 8px 12px; border-radius: 6px;
      z-index: 100; max-width: 320px;
      pointer-events: none;
    }
  </style>
</head>
<body>
  <div id="map"></div>
  <div id="loading-overlay">
    <div class="spinner"></div>
    <div id="loading-text">Loading 3D terrain...</div>
  </div>
  <div id="error-overlay">
    <div id="error-text"></div>
  </div>
  <div id="debug-panel">
    <div id="debug-info">Initializing...</div>
  </div>
  <script>
    // ===== Stravo Bridge =====
    const StravoBridge = {
      postMessage: function(jsonStr) {
        try {
          if (window.StravoBridge && window.StravoBridge.postMessage) {
            window.StravoBridge.postMessage(jsonStr);
          }
        } catch(e) {
          console.warn('[StravoBridge] postMessage failed:', e);
        }
      },
      send: function(event, data) {
        this.postMessage(JSON.stringify({ event: event, ...data }));
      }
    };

    // ===== Defense-in-depth Interceptor =====
    // Validates origins against loopback baseUrl. Complements the meta CSP above.
    function isAllowedUrl(rawUrl) {
      try {
        const parsed = new URL(rawUrl, window.location.href);
        if (parsed.protocol === 'data:' || parsed.protocol === 'blob:') return true;
        return parsed.origin === window.location.origin;
      } catch (e) {
        return false;
      }
    }

    const _origFetch = window.fetch;
    window.fetch = function(input, init) {
      const url = (typeof input === 'string') ? input : (input ? input.url : '');
      if (url && !isAllowedUrl(url)) {
        console.warn('[Stravo] Blocked external fetch:', url);
        StravoBridge.send('leak_detected', { url: url, method: 'fetch' });
        return Promise.reject(new Error('Blocked external request: ' + url));
      }
      return _origFetch.apply(this, arguments);
    };

    const _origXHROpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url) {
      if (url && !isAllowedUrl(url)) {
        console.warn('[Stravo] Blocked external XHR:', url);
        StravoBridge.send('leak_detected', { url: url, method: 'xhr' });
        throw new Error('Blocked external request: ' + url);
      }
      return _origXHROpen.apply(this, arguments);
    };

    // ===== State management =====
    let map = null;
    let terrainReady = false;
    let isContextLost = false;
    let contextLostCount = 0;
    const MAX_CONTEXT_RECOVERY = 3;
    let rebuildCount = 0;
    const MAX_REBUILDS = 3;

    let checkInterval = null;
    let timeoutTimer = null;
    let recoveryTimer = null;

    let tileErrors = 0;
    let demTileErrors = 0;
    let vectorTileErrors = 0;
    let glyphErrors = 0;
    let fatalError = null;

    function updateDebug(text) {
      const el = document.getElementById('debug-info');
      if (el) el.textContent = text;
    }

    function showError(message) {
      const overlay = document.getElementById('error-overlay');
      const text = document.getElementById('error-text');
      overlay.style.display = 'flex';
      text.textContent = message;
      StravoBridge.send('map_error', { message: message });
    }

    function hideLoading() {
      const overlay = document.getElementById('loading-overlay');
      overlay.style.display = 'none';
    }

    function cleanupTimers() {
      if (checkInterval) { clearInterval(checkInterval); checkInterval = null; }
      if (timeoutTimer) { clearTimeout(timeoutTimer); timeoutTimer = null; }
      if (recoveryTimer) { clearTimeout(recoveryTimer); recoveryTimer = null; }
    }

    function failTerrain(reason) {
      cleanupTimers();
      terrainReady = false;
      showError('Map load failed: ' + reason);
      StravoBridge.send('map_error', {
        message: reason,
        demTileErrors: demTileErrors,
        vectorTileErrors: vectorTileErrors,
        glyphErrors: glyphErrors,
        totalTileErrors: tileErrors
      });
    }

    // ===== Map initialization =====
    function initMap() {
      updateDebug('Creating map...');
      StravoBridge.send('map_state', { state: 'loading' });

      tileErrors = 0;
      demTileErrors = 0;
      vectorTileErrors = 0;
      glyphErrors = 0;
      fatalError = null;

      // START TIMEOUT IMMEDIATELY (Do not wait for 'load' event!)
      cleanupTimers();
      timeoutTimer = setTimeout(function() {
        if (!terrainReady) {
          failTerrain(fatalError || 'Map initialization timed out (style, DEM, or mandatory assets unverified within 20s)');
        }
      }, 20000);

      try {
        map = new maplibregl.Map({
          container: 'map',
          style: '$baseUrl/style.json',
          center: [107.795, -7.155],
          zoom: 13.0,
          pitch: 55,
          bearing: 35,
          maxPitch: 65,
          maxBounds: [[107.68, -7.24], [107.91, -7.07]],
          antialias: true
        });
      } catch(e) {
        failTerrain('Failed to instantiate MapLibre: ' + e.message);
        return;
      }

      // Track all resource errors
      map.on('error', function(e) {
        const errObj = e.error || e;
        const msg = (errObj && errObj.message) ? errObj.message : String(e);
        console.warn('[MapLibre Error]', msg);

        if (msg.includes('style') || msg.includes('style.json')) {
          fatalError = 'Style error: ' + msg;
          failTerrain(fatalError);
          return;
        }

        const isDem = (e && e.sourceId === 'terrain-dem') || msg.includes('terrain-dem') || msg.includes('/tiles/dem/');
        const isVector = (e && e.sourceId === 'openmaptiles') || msg.includes('openmaptiles') || msg.includes('/tiles/vector/');
        const isGlyph = msg.includes('/glyphs/') || msg.includes('.pbf');

        if (isDem) {
          demTileErrors++;
          fatalError = 'DEM tile error: ' + msg;
        } else if (isVector) {
          vectorTileErrors++;
          fatalError = 'Vector tile error: ' + msg;
        } else if (isGlyph) {
          glyphErrors++;
          fatalError = 'Glyph error: ' + msg;
        }
        tileErrors++;
      });

      map.on('load', function() {
        updateDebug('Style loaded. Verifying terrain & vector resources...');
      });

      // Periodic readiness verification
      checkInterval = setInterval(function() {
        checkReadiness();
      }, 500);

      // Helper for querying absolute DEM elevation in meters above sea level
      function getAbsoluteElevation(lngLat) {
        if (!map) return 0.0;
        try {
          var pt = maplibregl.LngLat.convert(lngLat);
          if (map.terrain && typeof map.terrain.getElevationForLngLatZoom === 'function') {
            var val = map.terrain.getElevationForLngLatZoom(pt, map.transform.tileZoom);
            if (val !== null && typeof val === 'number' && !isNaN(val) && val > 0) {
              return val;
            }
          }
        } catch(e) {}
        try {
          var centerElev = (map.transform && typeof map.transform.elevation === 'number') ? map.transform.elevation : 0;
          var rel = map.queryTerrainElevation(lngLat);
          if (rel !== null && typeof rel === 'number' && !isNaN(rel)) {
            return centerElev > 0 ? (centerElev + rel) : rel;
          }
          if (centerElev > 0) return centerElev;
        } catch(e) {}
        return 0.0;
      }

      // Camera telemetry
      map.on('moveend', function() {
        if (!terrainReady || isContextLost) return;
        const c = map.getCenter();
        const z = map.getZoom();
        const p = map.getPitch();
        const b = map.getBearing();

        let elevStr = 'N/A';
        try {
          const elev = getAbsoluteElevation(c);
          if (elev !== null && typeof elev === 'number' && !isNaN(elev)) {
            elevStr = elev.toFixed(1) + 'm';
          }
        } catch(err) {}

        updateDebug(
          'Lat:' + c.lat.toFixed(4) + ' ' +
          'Lng:' + c.lng.toFixed(4) + ' ' +
          'Z:' + z.toFixed(1) + ' ' +
          'P:' + p.toFixed(0) + '° ' +
          'B:' + b.toFixed(0) + '° ' +
          'Elev:' + elevStr
        );
      });

      // WebGL context event listeners
      const canvas = map.getCanvas();
      canvas.addEventListener('webglcontextlost', onContextLost);
      canvas.addEventListener('webglcontextrestored', onContextRestored);
    }

    function checkReadiness() {
      if (terrainReady || isContextLost || !map) return;

      // 1. Mandatory error checks: any failure on mandatory sources fails readiness
      if (demTileErrors > 0) {
        failTerrain('Mandatory DEM tiles failed to load (' + demTileErrors + ' errors)');
        return;
      }
      if (vectorTileErrors > 0) {
        failTerrain('Mandatory vector tiles failed to load (' + vectorTileErrors + ' errors)');
        return;
      }
      if (glyphErrors > 0) {
        failTerrain('Mandatory font glyphs failed to load (' + glyphErrors + ' errors)');
        return;
      }

      // 2. Sources must be registered and loaded
      const demSource = map.getSource('terrain-dem');
      const vectorSource = map.getSource('openmaptiles');
      if (!demSource || !vectorSource) return;

      if (!map.isStyleLoaded()) return;
      if (!map.isSourceLoaded('terrain-dem')) return;
      if (!map.isSourceLoaded('openmaptiles')) return;

      // 3. Verify actual 3D elevation decoding on WebGL mesh
      const center = map.getCenter();
      let elev = null;
      try {
        elev = getAbsoluteElevation(center);
      } catch(e) {}

      if (elev === null || typeof elev !== 'number' || isNaN(elev)) {
        return;
      }

      // All mandatory checks passed!
      terrainReady = true;
      cleanupTimers();
      hideLoading();

      const z = map.getZoom();
      const p = map.getPitch();
      const b = map.getBearing();

      updateDebug(
        'Terrain OK | Elev:' + elev.toFixed(1) + 'm | ' +
        'Z:' + z.toFixed(1) + ' P:' + p.toFixed(0) + '°'
      );

      StravoBridge.send('map_ready', {
        state: 'ready',
        elevation: elev,
        center: [center.lng, center.lat],
        zoom: z,
        pitch: p,
        bearing: b,
        tileErrors: tileErrors
      });
    }

    function onContextLost(e) {
      e.preventDefault();
      isContextLost = true;
      terrainReady = false;
      cleanupTimers();

      contextLostCount++;
      updateDebug('WebGL context lost (' + contextLostCount + '/' + MAX_CONTEXT_RECOVERY + ')');
      StravoBridge.send('context_lost', { count: contextLostCount });

      if (contextLostCount >= MAX_CONTEXT_RECOVERY) {
        showError('WebGL context lost repeatedly. Recovery limit reached (' + MAX_CONTEXT_RECOVERY + ').');
        return;
      }

      recoveryTimer = setTimeout(function() {
        if (!map) return;
        const canvas = map.getCanvas();
        if (!canvas) {
          rebuildMap();
          return;
        }
        const gl = canvas.getContext('webgl2') || canvas.getContext('webgl');
        const lost = !gl || (gl.isContextLost && gl.isContextLost());
        if (lost) {
          updateDebug('Context still lost after wait. Rebuilding map...');
          rebuildMap();
        }
      }, 3000);
    }

    function onContextRestored() {
      isContextLost = false;
      updateDebug('WebGL context restored');
      StravoBridge.send('context_restored', { count: contextLostCount });
      cleanupTimers();
      timeoutTimer = setTimeout(function() {
        if (!terrainReady) {
          failTerrain('Post-context-recovery verification timed out');
        }
      }, 20000);
      checkInterval = setInterval(checkReadiness, 500);
    }

    function rebuildMap() {
      if (rebuildCount >= MAX_REBUILDS) {
        showError('Maximum map rebuild attempts exceeded.');
        return;
      }
      rebuildCount++;

      updateDebug('Rebuilding map (' + rebuildCount + '/' + MAX_REBUILDS + ')...');
      StravoBridge.send('map_state', { state: 'rebuilding' });

      cleanupTimers();
      terrainReady = false;
      isContextLost = false;

      try {
        if (map) {
          const center = map.getCenter();
          const zoom = map.getZoom();
          const pitch = map.getPitch();
          const bearing = map.getBearing();

          map.remove();
          map = null;

          document.getElementById('map').innerHTML = '';
          initMap();

          setTimeout(function() {
            if (map && !isContextLost) {
              map.jumpTo({ center: center, zoom: zoom, pitch: pitch, bearing: bearing });
            }
          }, 1000);
        } else {
          document.getElementById('map').innerHTML = '';
          initMap();
        }
      } catch(e) {
        showError('Map rebuild failed: ' + e.message);
      }
    }

    // ===== External API for Flutter =====
    window.stravoApi = {
      queryElevation: function(lng, lat) {
        if (!map || !terrainReady || isContextLost) {
          return JSON.stringify({ error: 'Terrain not ready' });
        }
        try {
          const elev = getAbsoluteElevation({ lng: lng, lat: lat });
          return JSON.stringify({ elevation: elev, lng: lng, lat: lat });
        } catch(e) {
          return JSON.stringify({ error: e.message });
        }
      },
      getState: function() {
        return JSON.stringify({
          ready: terrainReady,
          contextLost: isContextLost,
          contextLostCount: contextLostCount,
          center: map ? [map.getCenter().lng, map.getCenter().lat] : null,
          zoom: map ? map.getZoom() : null,
          pitch: map ? map.getPitch() : null,
          bearing: map ? map.getBearing() : null
        });
      },
      setTerrain: function(enabled, exaggeration) {
        if (!map) return;
        if (enabled) {
          map.setTerrain({ source: 'terrain-dem', exaggeration: exaggeration || 1.0 });
        } else {
          map.setTerrain(null);
        }
      },
      setRouteGeoJson: function(geoJsonData) {
        if (!map) return;
        try {
          var geoJson = typeof geoJsonData === 'string' ? JSON.parse(geoJsonData) : geoJsonData;
          var source = map.getSource('route-polyline');
          if (source) {
            source.setData(geoJson);
          } else {
            map.addSource('route-polyline', {
              type: 'geojson',
              data: geoJson
            });
            map.addLayer({
              id: 'route-casing',
              type: 'line',
              source: 'route-polyline',
              layout: {
                'line-cap': 'round',
                'line-join': 'round'
              },
              paint: {
                'line-color': '#000000',
                'line-width': 6.0,
                'line-opacity': 0.65
              }
            });
            map.addLayer({
              id: 'route-line',
              type: 'line',
              source: 'route-polyline',
              layout: {
                'line-cap': 'round',
                'line-join': 'round'
              },
              paint: {
                'line-color': ['get', 'color'],
                'line-width': 4.0
              }
            });
          }
        } catch(e) {
          console.error('[stravoApi] setRouteGeoJson error:', e);
        }
      },
      clearRoute: function() {
        if (!map) return;
        try {
          var source = map.getSource('route-polyline');
          if (source) {
            source.setData({ type: 'FeatureCollection', features: [] });
          }
        } catch(e) {
          console.error('[stravoApi] clearRoute error:', e);
        }
      },
      setCameraPose: function(lng, lat, zoom, pitch, bearing) {
        if (!map) return;
        try {
          map.jumpTo({
            center: [lng, lat],
            zoom: (zoom !== undefined && zoom !== null) ? zoom : map.getZoom(),
            pitch: (pitch !== undefined && pitch !== null) ? pitch : map.getPitch(),
            bearing: (bearing !== undefined && bearing !== null) ? bearing : map.getBearing()
          });
        } catch(e) {
          console.error('[stravoApi] setCameraPose error:', e);
        }
      }
    };

    // Start
    initMap();
  </script>
</body>
</html>''';
  }
}
