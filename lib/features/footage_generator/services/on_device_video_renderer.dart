import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/story_card_data.dart';
import '../models/video_timeline_state.dart';
import '../widgets/video_footage_overlay.dart';

// ---------------------------------------------------------------------------
// Interface: VideoEncodingStrategy
// ---------------------------------------------------------------------------

/// Abstract contract for encoding a sequence of raw PNG frames into an MP4.
///
/// Implementations may use platform-specific native encoders (MediaCodec on
/// Android, AVAssetWriter on iOS) or delegate to an external binary.
abstract class VideoEncodingStrategy {
  /// Encodes the ordered [frames] (raw PNG bytes) into an MP4 at [outputPath].
  ///
  /// [fps] defaults to 30 frames per second for cinematic playback.
  Future<File> encodeFramesToMp4(
    List<Uint8List> frames,
    String outputPath, {
    int fps = 30,
  });
}

// ---------------------------------------------------------------------------
// Default: SkiaCanvasFrameGrabber (frame extraction pipeline)
// ---------------------------------------------------------------------------

/// Captures Full HD (1080×1920) frames from the overlay widget tree using
/// Flutter's Skia rendering pipeline.
///
/// This is the *frame supply* half of the renderer — it produces raw PNG
/// byte arrays ready to be fed into any [VideoEncodingStrategy].
class SkiaCanvasFrameGrabber {
  /// Grabs a single frame at the given [timestampSeconds] for the route.
  ///
  /// Returns raw PNG bytes of a 1080×1920 (or 1080×1080) composited frame.
  Future<Uint8List> grabFrame({
    required StoryCardData data,
    required double timestampSeconds,
    double pixelRatio = 1.0,
  }) async {
    final frame = VideoTimelineFrame.calculateFrame(
      timestampSeconds,
      totalDistanceMeters: data.distanceMeters,
    );

    final widget = VideoFootageOverlay(frame: frame, data: data);
    final logicalW = data.aspectRatio.width.toDouble();
    final logicalH = data.aspectRatio.height.toDouble();

    // Off-screen render pipeline
    final repaintBoundary = RenderRepaintBoundary();
    final view = ui.PlatformDispatcher.instance.implicitView;
    final renderView = RenderView(
      view: view!,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(Size(logicalW, logicalH)),
        devicePixelRatio: pixelRatio,
      ),
    );

    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    renderView.prepareInitialFrame();

    final buildOwner = BuildOwner(focusManager: FocusManager());
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: MediaQuery(
        data: MediaQueryData(
          size: Size(logicalW, logicalH),
          devicePixelRatio: pixelRatio,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: widget,
        ),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (byteData == null) {
      throw StateError('Failed to capture frame at t=${timestampSeconds}s');
    }

    return byteData.buffer.asUint8List();
  }

  /// Grabs all frames for a 30-second video at the given [fps].
  Future<List<Uint8List>> grabAllFrames({
    required StoryCardData data,
    int fps = 30,
    double pixelRatio = 1.0,
  }) async {
    final totalFrames = 30 * fps; // 30 seconds
    final frames = <Uint8List>[];

    for (var i = 0; i < totalFrames; i++) {
      final t = i / fps;
      final png = await grabFrame(
        data: data,
        timestampSeconds: t,
        pixelRatio: pixelRatio,
      );
      frames.add(png);
    }

    return frames;
  }
}

// ---------------------------------------------------------------------------
// Output directory resolver
// ---------------------------------------------------------------------------

/// Resolves the output directory for rendered video files.
///
/// Prefers `DCIM/Stravo/Videos/` on Android; falls back to app support dir.
class VideoOutputResolver {
  /// Returns a [Directory] where video files should be saved.
  Future<Directory> resolveOutputDir({String? customDir}) async {
    if (customDir != null) {
      final dir = Directory(customDir);
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir;
    }

    // Try DCIM/Stravo/Videos on Android
    final dcim = Directory(p.join('/storage/emulated/0/DCIM', 'Stravo', 'Videos'));
    if (await dcim.parent.exists()) {
      if (!await dcim.exists()) await dcim.create(recursive: true);
      return dcim;
    }

    // Fallback: app support
    final appSupport = await getApplicationSupportDirectory();
    final fallback = Directory(p.join(appSupport.path, 'videos'));
    if (!await fallback.exists()) await fallback.create(recursive: true);
    return fallback;
  }
}
