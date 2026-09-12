#!/usr/bin/env python3
"""
Stravo Pro - Mount Kamojang 3D Offline Demo Pack Generator & Verifier
======================================================================
CLI tool to generate, verify, and document the offline 3D terrain pack.

Data Sources & Licensure:
1. Terrain DEM Tiles:
   - Source: AWS Open Data Registry - Terrain Tiles (Mapzen / Nextzen)
   - URL: https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png
   - Format: Terrarium PNG (256x256)
   - Elevation Formula: h = (R * 256 + G + B / 256) - 32768
   - Precision: 1/256 m (~0.00390625 m)
   - Elevation Data Sources: Copernicus DEM GLO-30 (European Space Agency / Airbus / DLR)
     and SRTM 30m (NASA/JPL-Caltech).
   - Licensure: AWS Registry of Open Data terms; Copernicus DEM © DLR e.V. 2010-2014
     and © Airbus Defence and Space GmbH 2014-2018; SRTM NASA.

2. Vector Tiles:
   - Source: OpenStreetMap Vector Tiles (Shortbread schema v1)
   - URL: https://vector.openstreetmap.org/shortbread_v1/{z}/{x}/{y}.mvt
   - Format: Mapbox Vector Tile (MVT / Protobuf), gzip-compressed
   - Attribution: © OpenStreetMap contributors
   - Licensure: Open Database License (ODbL) 1.0

3. Font Glyphs:
   - Source: MapLibre Demotiles / Open Sans font (Steve Matteson)
   - URL: https://raw.githubusercontent.com/maplibre/demotiles/gh-pages/font/Noto%20Sans%20Regular/0-255.pbf
   - Format: Signed Distance Field font glyphs (PBF)
   - Licensure: SIL Open Font License (OFL) 1.1

4. Engine:
   - MapLibre GL JS 4.7.1
   - Licensure: BSD-3-Clause
"""

import argparse
import hashlib
import io
import json
import math
import os
import shutil
import sqlite3
import sys
import time

try:
    import requests
    from PIL import Image
    HAS_DEPS = True
except ImportError:
    HAS_DEPS = False

# Geographic Bounding Box for Mount Kamojang, West Java, Indonesia
# (min_lon, min_lat, max_lon, max_lat)
BOUNDS = (107.70, -7.22, 107.89, -7.09)
ZOOM_RANGE = range(11, 14)  # z11, z12, z13 (37 tiles total)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_PACK_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, '..', 'assets', 'demo_pack', 'kamojang'))
DEFAULT_ENGINE_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, '..', 'assets', 'map_engine'))

DATA_SOURCES = {
    "terrain_dem": {
        "name": "Nextzen / Mapzen Open Elevation Tiles",
        "url_template": "https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png",
        "format": "Terrarium PNG (256x256)",
        "elevation_formula": "h = (R * 256 + G + B / 256) - 32768",
        "precision_meters": 1.0 / 256.0,
        "attribution": "Copernicus DEM GLO-30 (ESA / Airbus / DLR) & SRTM 30m (NASA/JPL). Tiled by Mapzen/Nextzen.",
        "licensure": "AWS Registry of Open Data terms; Copernicus DEM © DLR/Airbus; SRTM NASA; data provided by Nextzen.",
    },
    "vector_tiles": {
        "name": "OpenStreetMap Shortbread Vector Tiles (v1)",
        "url_template": "https://vector.openstreetmap.org/shortbread_v1/{z}/{x}/{y}.mvt",
        "format": "Mapbox Vector Tile (MVT / Protobuf)",
        "compression": "gzip",
        "attribution": "© OpenStreetMap contributors",
        "licensure": "Open Database License (ODbL) 1.0",
    },
    "glyphs": {
        "name": "Open Sans Regular (0-255)",
        "url_template": "https://raw.githubusercontent.com/maplibre/demotiles/gh-pages/font/Noto%20Sans%20Regular/0-255.pbf",
        "format": "Signed Distance Field font glyphs (PBF)",
        "attribution": "Steve Matteson / MapLibre contributors",
        "licensure": "SIL Open Font License (OFL) 1.1",
    },
}


def deg2num(lat_deg, lon_deg, zoom):
    """Converts geographic coordinates to Slippy map tile numbers."""
    lat_rad = math.radians(lat_deg)
    n = 2.0 ** zoom
    xtile = int((lon_deg + 180.0) / 360.0 * n)
    ytile = int((1.0 - math.asinh(math.tan(lat_rad)) / math.pi) / 2.0 * n)
    return (xtile, ytile)


def get_tile_coordinates(zoom_range=ZOOM_RANGE, bounds=BOUNDS):
    """Yields (z, x, y) for all tiles within the geographic bounding box."""
    for z in zoom_range:
        min_x, max_y = deg2num(bounds[1], bounds[0], z)
        max_x, min_y = deg2num(bounds[3], bounds[2], z)
        for x in range(min_x, max_x + 1):
            for y in range(min_y, max_y + 1):
                yield (z, x, y)


def compute_sha256(file_path):
    """Computes the SHA-256 hash of a file."""
    if not os.path.exists(file_path):
        return ""
    h = hashlib.sha256()
    with open(file_path, "rb") as f:
        while chunk := f.read(65536):
            h.update(chunk)
    return h.hexdigest()


def safe_atomic_replace(temp_path, target_path):
    """Atomically replaces target_path with temp_path without deleting target_path beforehand.
    
    If replacement fails, the existing target_path is preserved intact and temp_path is cleaned up.
    Uses backup copy rollback safeguard.
    """
    if not os.path.exists(temp_path):
        raise FileNotFoundError(f"Source temporary file not found: {temp_path}")

    bak_path = target_path + '.bak'
    has_target = os.path.exists(target_path)

    # 1. Create backup of existing target if present
    if has_target:
        if os.path.exists(bak_path):
            try:
                os.remove(bak_path)
            except Exception:
                pass
        try:
            os.link(target_path, bak_path)
        except (AttributeError, OSError):
            shutil.copy2(target_path, bak_path)

    try:
        # 2. os.replace atomically overwrites target_path without prior removal
        os.replace(temp_path, target_path)

        # 3. Clean up backup on success
        if os.path.exists(bak_path):
            try:
                os.remove(bak_path)
            except Exception:
                pass

    except Exception as e:
        # 4. Rollback: restore target from backup if target is missing
        if not os.path.exists(target_path) and os.path.exists(bak_path):
            try:
                os.replace(bak_path, target_path)
            except Exception:
                pass
        # Clean up backup file if still present
        if os.path.exists(bak_path):
            try:
                os.remove(bak_path)
            except Exception:
                pass
        # Clean up temp file on failure
        if os.path.exists(temp_path):
            try:
                os.remove(temp_path)
            except Exception:
                pass
        raise RuntimeError(f"Atomic replacement failed for {target_path}. Target preserved. Cause: {e}") from e


def build_dem_mbtiles(output_dir):
    """Downloads authentic Terrarium DEM tiles and packages into SQLite MBTiles.
    
    Safe atomic operation:
    Writes to dem.mbtiles.tmp first. If ANY tile fails to download, cleans up .tmp
    and aborts without touching the existing dem.mbtiles.
    """
    if not HAS_DEPS:
        raise RuntimeError("Missing required Python packages 'requests' or 'pillow'. Run: pip install requests pillow")

    target_path = os.path.join(output_dir, 'dem.mbtiles')
    temp_path = target_path + '.tmp'
    if os.path.exists(temp_path):
        os.remove(temp_path)

    tiles_to_fetch = list(get_tile_coordinates())
    expected_count = len(tiles_to_fetch)
    print(f"[DEM] Preparing to build dem.mbtiles ({expected_count} tiles, z11-z13)...")

    db = sqlite3.connect(temp_path)
    cur = db.cursor()
    cur.execute('CREATE TABLE metadata (name text, value text);')
    cur.execute('CREATE TABLE tiles (zoom_level integer, tile_column integer, tile_row integer, tile_data blob);')
    cur.execute('CREATE UNIQUE INDEX tile_index ON tiles (zoom_level, tile_column, tile_row);')

    metadata = [
        ('name', 'Kamojang Terrain DEM'),
        ('type', 'baselayer'),
        ('version', '1.0.0'),
        ('description', 'Authentic Terrarium DEM elevation tiles for Mount Kamojang from Mapzen/Nextzen AWS Open Dataset'),
        ('format', 'png'),
        ('bounds', '107.70,-7.22,107.89,-7.09'),
        ('center', '107.795,-7.155,13'),
        ('minzoom', '11'),
        ('maxzoom', '13'),
        ('attribution', DATA_SOURCES['terrain_dem']['attribution']),
    ]
    cur.executemany('INSERT INTO metadata VALUES (?, ?)', metadata)

    sess = requests.Session()
    count = 0
    min_elev, max_elev = 99999.0, -99999.0

    try:
        for z, x, y in tiles_to_fetch:
            url = f'https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png'
            success = False
            last_err = None

            for attempt in range(3):
                try:
                    r = sess.get(url, timeout=12)
                    if r.status_code == 200 and len(r.content) > 0:
                        data = r.content
                        img = Image.open(io.BytesIO(data))
                        rgb = img.getpixel((128, 128))
                        elev = (rgb[0] * 256.0 + rgb[1] + rgb[2] / 256.0) - 32768.0
                        if elev < min_elev:
                            min_elev = elev
                        if elev > max_elev:
                            max_elev = elev
                        tms_y = (1 << z) - 1 - y
                        cur.execute('INSERT INTO tiles VALUES (?, ?, ?, ?)', (z, x, tms_y, data))
                        count += 1
                        success = True
                        break
                    else:
                        last_err = f"HTTP {r.status_code}"
                except Exception as e:
                    last_err = str(e)
                    time.sleep(0.5)

            if not success:
                raise RuntimeError(f"Failed to download tile z={z}, x={x}, y={y} from {url} after 3 attempts: {last_err}")

            time.sleep(0.05)

        if count != expected_count:
            raise RuntimeError(f"Tile count mismatch: expected {expected_count}, got {count}")

        db.commit()
        db.close()

        # Safe atomic replacement preserving existing file on failure
        safe_atomic_replace(temp_path, target_path)

        hash_val = compute_sha256(target_path)
        size = os.path.getsize(target_path)
        print(f"[DEM] SUCCESS: {count} tiles saved to {target_path}")
        print(f"      Elev range: {min_elev:.1f}m - {max_elev:.1f}m | Size: {size} B | SHA-256: {hash_val}")
        return {"count": count, "min_elev": min_elev, "max_elev": max_elev, "sha256": hash_val, "size": size}

    except Exception as e:
        db.close()
        if os.path.exists(temp_path):
            try:
                os.remove(temp_path)
            except Exception:
                pass
        print(f"[DEM] ERROR: Build aborted without modifying target file. Cause: {e}", file=sys.stderr)
        raise


def build_vector_mbtiles(output_dir):
    """Downloads OpenStreetMap Shortbread vector tiles and packages into SQLite MBTiles.
    
    Safe atomic operation:
    Writes to vector.mbtiles.tmp first. If ANY tile fails, cleans up .tmp and aborts.
    """
    if not HAS_DEPS:
        raise RuntimeError("Missing required Python packages 'requests'. Run: pip install requests")

    target_path = os.path.join(output_dir, 'vector.mbtiles')
    temp_path = target_path + '.tmp'
    if os.path.exists(temp_path):
        os.remove(temp_path)

    tiles_to_fetch = list(get_tile_coordinates())
    expected_count = len(tiles_to_fetch)
    print(f"[VECTOR] Preparing to build vector.mbtiles ({expected_count} tiles, z11-z13)...")

    db = sqlite3.connect(temp_path)
    cur = db.cursor()
    cur.execute('CREATE TABLE metadata (name text, value text);')
    cur.execute('CREATE TABLE tiles (zoom_level integer, tile_column integer, tile_row integer, tile_data blob);')
    cur.execute('CREATE UNIQUE INDEX tile_index ON tiles (zoom_level, tile_column, tile_row);')

    metadata = [
        ('name', 'Kamojang Vector Shortbread'),
        ('type', 'overlay'),
        ('version', '1.0.0'),
        ('description', 'Authentic OpenStreetMap vector tiles (Shortbread schema) for Mount Kamojang'),
        ('format', 'pbf'),
        ('bounds', '107.70,-7.22,107.89,-7.09'),
        ('center', '107.795,-7.155,13'),
        ('minzoom', '11'),
        ('maxzoom', '13'),
        ('attribution', DATA_SOURCES['vector_tiles']['attribution']),
    ]
    cur.executemany('INSERT INTO metadata VALUES (?, ?)', metadata)

    sess = requests.Session()
    sess.headers.update({'User-Agent': 'StravoProDemo/1.0 (offline map research)'})
    count = 0

    try:
        for z, x, y in tiles_to_fetch:
            url = f'https://vector.openstreetmap.org/shortbread_v1/{z}/{x}/{y}.mvt'
            success = False
            last_err = None

            for attempt in range(3):
                try:
                    r = sess.get(url, timeout=12)
                    if r.status_code == 200 and len(r.content) > 0:
                        data = r.content
                        tms_y = (1 << z) - 1 - y
                        cur.execute('INSERT INTO tiles VALUES (?, ?, ?, ?)', (z, x, tms_y, data))
                        count += 1
                        success = True
                        break
                    else:
                        last_err = f"HTTP {r.status_code}"
                except Exception as e:
                    last_err = str(e)
                    time.sleep(0.5)

            if not success:
                raise RuntimeError(f"Failed to download vector tile z={z}, x={x}, y={y} from {url}: {last_err}")

            time.sleep(0.05)

        if count != expected_count:
            raise RuntimeError(f"Vector tile count mismatch: expected {expected_count}, got {count}")

        db.commit()
        db.close()

        # Safe atomic replacement preserving existing file on failure
        safe_atomic_replace(temp_path, target_path)

        hash_val = compute_sha256(target_path)
        size = os.path.getsize(target_path)
        print(f"[VECTOR] SUCCESS: {count} tiles saved to {target_path}")
        print(f"        Size: {size} B | SHA-256: {hash_val}")
        return {"count": count, "sha256": hash_val, "size": size}

    except Exception as e:
        db.close()
        if os.path.exists(temp_path):
            try:
                os.remove(temp_path)
            except Exception:
                pass
        print(f"[VECTOR] ERROR: Build aborted without modifying target file. Cause: {e}", file=sys.stderr)
        raise


def build_glyphs(output_dir):
    """Downloads Open Sans Regular glyph PBF range 0-255."""
    if not HAS_DEPS:
        raise RuntimeError("Missing required Python packages 'requests'. Run: pip install requests")

    glyph_dir = os.path.join(output_dir, 'glyphs', 'Open Sans Regular')
    os.makedirs(glyph_dir, exist_ok=True)
    target_path = os.path.join(glyph_dir, '0-255.pbf')
    temp_path = target_path + '.tmp'

    url = DATA_SOURCES['glyphs']['url_template']
    print(f"[GLYPHS] Fetching {url}...")

    r = requests.get(url, timeout=15)
    if r.status_code != 200 or len(r.content) == 0:
        raise RuntimeError(f"Failed to download glyphs: HTTP {r.status_code}")

    with open(temp_path, 'wb') as f:
        f.write(r.content)

    # Safe atomic replacement preserving existing file on failure
    safe_atomic_replace(temp_path, target_path)

    hash_val = compute_sha256(target_path)
    size = os.path.getsize(target_path)
    print(f"[GLYPHS] SUCCESS: Saved to {target_path} (Size: {size} B | SHA-256: {hash_val})")
    return {"sha256": hash_val, "size": size}


def update_manifest(output_dir, engine_dir=DEFAULT_ENGINE_DIR):
    """Recalculates SHA-256 checksums and file sizes, then safely writes manifest.json."""
    manifest_path = os.path.join(output_dir, 'manifest.json')
    if not os.path.exists(manifest_path):
        raise FileNotFoundError(f"manifest.json not found at {manifest_path}")

    with open(manifest_path, 'r', encoding='utf-8') as f:
        manifest = json.load(f)

    # 1. Update DEM info
    dem_path = os.path.join(output_dir, 'dem.mbtiles')
    if os.path.exists(dem_path):
        manifest['sources']['dem']['sha256'] = compute_sha256(dem_path)
        manifest['sources']['dem']['size_bytes'] = os.path.getsize(dem_path)
        manifest['sources']['dem']['attribution'] = DATA_SOURCES['terrain_dem']['attribution']
        manifest['sources']['dem']['license'] = DATA_SOURCES['terrain_dem']['licensure']

    # 2. Update Vector info
    vec_path = os.path.join(output_dir, 'vector.mbtiles')
    if os.path.exists(vec_path):
        manifest['sources']['vector']['sha256'] = compute_sha256(vec_path)
        manifest['sources']['vector']['size_bytes'] = os.path.getsize(vec_path)
        manifest['sources']['vector']['attribution'] = DATA_SOURCES['vector_tiles']['attribution']
        manifest['sources']['vector']['license'] = DATA_SOURCES['vector_tiles']['licensure']

    # 3. Update Style info
    style_path = os.path.join(output_dir, 'style.json')
    if os.path.exists(style_path):
        manifest['style']['sha256'] = compute_sha256(style_path)
        manifest['style']['size_bytes'] = os.path.getsize(style_path)

    # 4. Update Glyphs info
    glyph_path = os.path.join(output_dir, 'glyphs', 'Open Sans Regular', '0-255.pbf')
    if os.path.exists(glyph_path):
        manifest['glyphs']['Open Sans Regular']['sha256'] = compute_sha256(glyph_path)
        manifest['glyphs']['Open Sans Regular']['size_bytes'] = os.path.getsize(glyph_path)
        manifest['glyphs']['Open Sans Regular']['license'] = DATA_SOURCES['glyphs']['licensure']

    # 5. Update Engine info
    js_path = os.path.join(engine_dir, 'maplibre-gl.js')
    if os.path.exists(js_path):
        manifest['engine']['files']['maplibre-gl.js']['sha256'] = compute_sha256(js_path)
        manifest['engine']['files']['maplibre-gl.js']['size_bytes'] = os.path.getsize(js_path)

    css_path = os.path.join(engine_dir, 'maplibre-gl.css')
    if os.path.exists(css_path):
        manifest['engine']['files']['maplibre-gl.css']['sha256'] = compute_sha256(css_path)
        manifest['engine']['files']['maplibre-gl.css']['size_bytes'] = os.path.getsize(css_path)

    # Safe atomic write preserving existing manifest on failure
    temp_manifest = manifest_path + '.tmp'
    with open(temp_manifest, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2)
        f.write('\n')

    safe_atomic_replace(temp_manifest, manifest_path)

    manifest_hash = compute_sha256(manifest_path)
    print(f"[MANIFEST] Updated {manifest_path} (SHA-256: {manifest_hash})")
    return manifest_hash


def verify_pack(output_dir, engine_dir=DEFAULT_ENGINE_DIR):
    """Verifies existing pack files against manifest and checks SQLite schema and elevation data."""
    manifest_path = os.path.join(output_dir, 'manifest.json')
    print(f"\n{'='*70}")
    print(f"VERIFYING DEMO PACK: {output_dir}")
    print(f"{'='*70}\n")

    if not os.path.exists(manifest_path):
        print(f"[FAIL] manifest.json not found in {output_dir}")
        return False

    with open(manifest_path, 'r', encoding='utf-8') as f:
        manifest = json.load(f)

    all_passed = True

    # 1. Verify files against checksums
    files_to_check = [
        ("style.json", os.path.join(output_dir, 'style.json'), manifest.get('style', {}).get('sha256')),
        ("dem.mbtiles", os.path.join(output_dir, 'dem.mbtiles'), manifest.get('sources', {}).get('dem', {}).get('sha256')),
        ("vector.mbtiles", os.path.join(output_dir, 'vector.mbtiles'), manifest.get('sources', {}).get('vector', {}).get('sha256')),
        ("0-255.pbf", os.path.join(output_dir, 'glyphs', 'Open Sans Regular', '0-255.pbf'), manifest.get('glyphs', {}).get('Open Sans Regular', {}).get('sha256')),
        ("maplibre-gl.js", os.path.join(engine_dir, 'maplibre-gl.js'), manifest.get('engine', {}).get('files', {}).get('maplibre-gl.js', {}).get('sha256')),
        ("maplibre-gl.css", os.path.join(engine_dir, 'maplibre-gl.css'), manifest.get('engine', {}).get('files', {}).get('maplibre-gl.css', {}).get('sha256')),
    ]

    print("[1] SHA-256 File Integrity:")
    for label, fpath, expected_hash in files_to_check:
        if not os.path.exists(fpath):
            print(f"    X {label:<16}: MISSING ({fpath})")
            all_passed = False
            continue

        actual_hash = compute_sha256(fpath)
        if actual_hash == expected_hash:
            size_kb = os.path.getsize(fpath) / 1024.0
            print(f"    OK {label:<16}: MATCH ({size_kb:6.1f} KB | {actual_hash[:16]}...)")
        else:
            print(f"    X {label:<16}: MISMATCH")
            print(f"       Expected: {expected_hash}")
            print(f"       Actual:   {actual_hash}")
            all_passed = False

    # 2. Verify SQLite MBTiles internal integrity
    print("\n[2] SQLite MBTiles Schema & Tile Count:")
    dem_path = os.path.join(output_dir, 'dem.mbtiles')
    if os.path.exists(dem_path):
        try:
            db = sqlite3.connect(dem_path)
            cur = db.cursor()
            cur.execute("SELECT count(*) FROM tiles;")
            count = cur.fetchone()[0]
            cur.execute("SELECT value FROM metadata WHERE name='format';")
            fmt = cur.fetchone()
            fmt_str = fmt[0] if fmt else "unknown"

            # Sample center tile elevation
            cur.execute("SELECT tile_data FROM tiles WHERE zoom_level=13 AND tile_column=6549 LIMIT 1;")
            row = cur.fetchone()
            elev_str = "N/A"
            if row and HAS_DEPS:
                img = Image.open(io.BytesIO(row[0]))
                rgb = img.getpixel((128, 128))
                elev = (rgb[0] * 256.0 + rgb[1] + rgb[2] / 256.0) - 32768.0
                elev_str = f"{elev:.1f} m"

            db.close()
            print(f"    OK dem.mbtiles    : {count} tiles (Format: {fmt_str}, Sample Elev: {elev_str})")
            if count != 37:
                print(f"       Warning: Expected 37 tiles, found {count}")
                all_passed = False
        except Exception as e:
            print(f"    X dem.mbtiles    : SQLite Error: {e}")
            all_passed = False

    vec_path = os.path.join(output_dir, 'vector.mbtiles')
    if os.path.exists(vec_path):
        try:
            db = sqlite3.connect(vec_path)
            cur = db.cursor()
            cur.execute("SELECT count(*) FROM tiles;")
            count = cur.fetchone()[0]
            cur.execute("SELECT value FROM metadata WHERE name='format';")
            fmt = cur.fetchone()
            fmt_str = fmt[0] if fmt else "unknown"
            db.close()
            print(f"    OK vector.mbtiles : {count} tiles (Format: {fmt_str})")
            if count != 37:
                print(f"       Warning: Expected 37 tiles, found {count}")
                all_passed = False
        except Exception as e:
            print(f"    X vector.mbtiles : SQLite Error: {e}")
            all_passed = False

    print(f"\n{'='*70}")
    if all_passed:
        print("RESULT: ALL INTEGRITY CHECKS PASSED OK")
    else:
        print("RESULT: SOME CHECKS FAILED X")
    print(f"{'='*70}\n")
    return all_passed


def main():
    parser = argparse.ArgumentParser(
        description="Stravo Pro - Mount Kamojang 3D Offline Demo Pack Tool",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python build_kamojang_pack.py --verify           # Verify existing pack without network calls
  python build_kamojang_pack.py --build-dem         # Download and package Terrarium DEM tiles
  python build_kamojang_pack.py --build-vector      # Download and package OSM vector tiles
  python build_kamojang_pack.py --update-manifest   # Recalculate SHA-256 and file sizes
  python build_kamojang_pack.py --all               # Full build + manifest update
"""
    )
    parser.add_argument("--verify", action="store_true", help="Verify integrity of current pack on disk without downloading")
    parser.add_argument("--build-dem", action="store_true", help="Download and generate dem.mbtiles from AWS Open Data")
    parser.add_argument("--build-vector", action="store_true", help="Download and generate vector.mbtiles from OSM")
    parser.add_argument("--build-glyphs", action="store_true", help="Download font glyphs (Open Sans Regular 0-255)")
    parser.add_argument("--update-manifest", action="store_true", help="Recalculate manifest SHA-256 and sizes from current files")
    parser.add_argument("--all", action="store_true", help="Build all assets and update manifest")
    parser.add_argument("--output-dir", default=DEFAULT_PACK_DIR, help=f"Path to demo pack directory (default: {DEFAULT_PACK_DIR})")
    parser.add_argument("--engine-dir", default=DEFAULT_ENGINE_DIR, help=f"Path to map engine directory (default: {DEFAULT_ENGINE_DIR})")

    args = parser.parse_args()

    has_build_flag = args.build_dem or args.build_vector or args.build_glyphs or args.update_manifest or args.all
    if not has_build_flag or args.verify:
        success = verify_pack(args.output_dir, args.engine_dir)
        if not has_build_flag:
            print("Note: To build or update assets, run with --build-dem, --build-vector, or --all.")
            sys.exit(0 if success else 1)

    if args.all or args.build_dem:
        build_dem_mbtiles(args.output_dir)

    if args.all or args.build_vector:
        build_vector_mbtiles(args.output_dir)

    if args.all or args.build_glyphs:
        build_glyphs(args.output_dir)

    if args.all or args.update_manifest:
        update_manifest(args.output_dir, args.engine_dir)


if __name__ == '__main__':
    main()
