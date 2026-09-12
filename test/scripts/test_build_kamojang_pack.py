#!/usr/bin/env python3
"""
Unit tests for build_kamojang_pack.py
======================================
Verifies atomic file replacement, failure preservation, and integrity checks
using local file fixtures without downloading any network assets.
"""

import json
import os
import shutil
import sys
import tempfile
import unittest
from unittest.mock import patch

# Add scripts directory to path
SCRIPT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'scripts'))
sys.path.insert(0, SCRIPT_DIR)

import build_kamojang_pack as pkg


class TestSafeAtomicReplace(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.mkdtemp(prefix='stravo_test_atomic_')

    def tearDown(self):
        if os.path.exists(self.test_dir):
            shutil.rmtree(self.test_dir)

    def test_safe_atomic_replace_new_file(self):
        """When target does not exist, temp file is moved to target."""
        temp_file = os.path.join(self.test_dir, 'asset.mbtiles.tmp')
        target_file = os.path.join(self.test_dir, 'asset.mbtiles')

        with open(temp_file, 'w', encoding='utf-8') as f:
            f.write('initial_asset_data')

        pkg.safe_atomic_replace(temp_file, target_file)

        self.assertTrue(os.path.exists(target_file))
        self.assertFalse(os.path.exists(temp_file))
        with open(target_file, 'r', encoding='utf-8') as f:
            self.assertEqual(f.read(), 'initial_asset_data')

    def test_safe_atomic_replace_existing_file_success(self):
        """When target exists, replacement cleanly updates target without leaving .bak or .tmp."""
        target_file = os.path.join(self.test_dir, 'dem.mbtiles')
        temp_file = os.path.join(self.test_dir, 'dem.mbtiles.tmp')

        with open(target_file, 'w', encoding='utf-8') as f:
            f.write('old_valid_mbtiles_data')

        with open(temp_file, 'w', encoding='utf-8') as f:
            f.write('new_updated_mbtiles_data')

        pkg.safe_atomic_replace(temp_file, target_file)

        self.assertTrue(os.path.exists(target_file))
        self.assertFalse(os.path.exists(temp_file))
        self.assertFalse(os.path.exists(target_file + '.bak'))
        with open(target_file, 'r', encoding='utf-8') as f:
            self.assertEqual(f.read(), 'new_updated_mbtiles_data')

    def test_safe_atomic_replace_failure_preserves_old_target(self):
        """When rename/replace fails, the original target file is preserved intact."""
        target_file = os.path.join(self.test_dir, 'dem.mbtiles')
        temp_file = os.path.join(self.test_dir, 'dem.mbtiles.tmp')

        original_content = 'crucial_original_mbtiles_must_not_be_lost'
        with open(target_file, 'w', encoding='utf-8') as f:
            f.write(original_content)

        with open(temp_file, 'w', encoding='utf-8') as f:
            f.write('incoming_update_attempt')

        # Simulate failure during os.replace
        with patch('os.replace', side_effect=OSError("Simulated disk I/O failure during rename")):
            with self.assertRaises(RuntimeError) as ctx:
                pkg.safe_atomic_replace(temp_file, target_file)

            self.assertIn("Target preserved", str(ctx.exception))

        # CRITICAL ASSERTION: The original target file was NOT deleted or lost!
        self.assertTrue(os.path.exists(target_file), "Target file must still exist after replacement failure!")
        with open(target_file, 'r', encoding='utf-8') as f:
            self.assertEqual(f.read(), original_content, "Target file content must remain unchanged!")

        # Temp file should be cleaned up
        self.assertFalse(os.path.exists(temp_file))
        # Backup file should be cleaned up
        self.assertFalse(os.path.exists(target_file + '.bak'))

    def test_safe_atomic_replace_missing_temp_raises(self):
        """If source temp file does not exist, FileNotFoundError is raised."""
        target_file = os.path.join(self.test_dir, 'nonexistent.mbtiles')
        temp_file = os.path.join(self.test_dir, 'nonexistent.mbtiles.tmp')

        with self.assertRaises(FileNotFoundError):
            pkg.safe_atomic_replace(temp_file, target_file)


class TestManifestAndPackIntegrity(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.mkdtemp(prefix='stravo_test_manifest_')
        self.engine_dir = os.path.join(self.test_dir, 'map_engine')
        os.makedirs(self.engine_dir, exist_ok=True)

        # Create mock engine files
        self.js_path = os.path.join(self.engine_dir, 'maplibre-gl.js')
        with open(self.js_path, 'w', encoding='utf-8') as f:
            f.write('console.log("engine");')

        self.css_path = os.path.join(self.engine_dir, 'maplibre-gl.css')
        with open(self.css_path, 'w', encoding='utf-8') as f:
            f.write('body { margin: 0; }')

        # Create mock pack files
        self.dem_path = os.path.join(self.test_dir, 'dem.mbtiles')
        with open(self.dem_path, 'w', encoding='utf-8') as f:
            f.write('mock_dem_bytes')

        self.vec_path = os.path.join(self.test_dir, 'vector.mbtiles')
        with open(self.vec_path, 'w', encoding='utf-8') as f:
            f.write('mock_vector_bytes')

        self.style_path = os.path.join(self.test_dir, 'style.json')
        with open(self.style_path, 'w', encoding='utf-8') as f:
            f.write('{"version": 8}')

        glyph_dir = os.path.join(self.test_dir, 'glyphs', 'Open Sans Regular')
        os.makedirs(glyph_dir, exist_ok=True)
        self.glyph_path = os.path.join(glyph_dir, '0-255.pbf')
        with open(self.glyph_path, 'w', encoding='utf-8') as f:
            f.write('mock_glyph_bytes')

        # Create base manifest
        self.manifest_path = os.path.join(self.test_dir, 'manifest.json')
        manifest_data = {
            "version": 1,
            "engine": {"files": {"maplibre-gl.js": {}, "maplibre-gl.css": {}}},
            "sources": {"dem": {}, "vector": {}},
            "style": {},
            "glyphs": {"Open Sans Regular": {}}
        }
        with open(self.manifest_path, 'w', encoding='utf-8') as f:
            json.dump(manifest_data, f)

    def tearDown(self):
        if os.path.exists(self.test_dir):
            shutil.rmtree(self.test_dir)

    def test_update_manifest_success(self):
        """update_manifest accurately computes SHA-256 and updates manifest.json atomically."""
        pkg.update_manifest(self.test_dir, self.engine_dir)

        with open(self.manifest_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        self.assertEqual(data['sources']['dem']['sha256'], pkg.compute_sha256(self.dem_path))
        self.assertEqual(data['sources']['vector']['sha256'], pkg.compute_sha256(self.vec_path))
        self.assertEqual(data['style']['sha256'], pkg.compute_sha256(self.style_path))
        self.assertEqual(data['glyphs']['Open Sans Regular']['sha256'], pkg.compute_sha256(self.glyph_path))

    def test_update_manifest_failure_preserves_old_manifest(self):
        """When manifest replacement fails, existing manifest.json is preserved intact."""
        with open(self.manifest_path, 'r', encoding='utf-8') as f:
            original_manifest_text = f.read()

        # Simulate replacement failure
        with patch('build_kamojang_pack.safe_atomic_replace', side_effect=RuntimeError("Simulated replacement failure")):
            with self.assertRaises(RuntimeError):
                pkg.update_manifest(self.test_dir, self.engine_dir)

        # Existing manifest was preserved
        with open(self.manifest_path, 'r', encoding='utf-8') as f:
            self.assertEqual(f.read(), original_manifest_text)


if __name__ == '__main__':
    unittest.main()
