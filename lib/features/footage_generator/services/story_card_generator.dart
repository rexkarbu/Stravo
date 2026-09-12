import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/story_card_data.dart';
import '../widgets/story_card_widget.dart';

/// Off-screen renderer that snapshots [StoryCardWidget] into a PNG byte array.
class StoryCardGenerator {
  /// Renders a [StoryCardWidget] for the given [data] and returns raw PNG bytes.
  ///
  /// [pixelRatio] controls the super-sampling multiplier (default 3.0 for
  /// crystal-clear output on high-DPI screens).
  Future<Uint8List> renderToPngBytes(
    StoryCardData data, {
    double pixelRatio = 3.0,
  }) async {
    final widget = StoryCardWidget(data: data);
    final logicalWidth = data.aspectRatio.width.toDouble();
    final logicalHeight = data.aspectRatio.height.toDouble();

    // Build an off-screen render pipeline
    final repaintBoundary = RenderRepaintBoundary();
    final view = ui.PlatformDispatcher.instance.implicitView;
    final renderView = RenderView(
      view: view!,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(
          Size(logicalWidth, logicalHeight),
        ),
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
          size: Size(logicalWidth, logicalHeight),
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
      throw StateError('Failed to encode story card to PNG');
    }

    return byteData.buffer.asUint8List();
  }

  /// Writes [pngBytes] to disk as [fileName].png.
  ///
  /// Tries DCIM/Stravo first; falls back to app support directory.
  Future<File> savePngToDisk(
    Uint8List pngBytes,
    String fileName, {
    String? customDir,
  }) async {
    late final Directory targetDir;

    if (customDir != null) {
      targetDir = Directory(customDir);
    } else {
      // Try DCIM/Stravo on Android
      final dcim = Directory(p.join('/storage/emulated/0/DCIM', 'Stravo'));
      if (await dcim.exists()) {
        targetDir = dcim;
      } else {
        // Fallback: app support directory
        final appSupport = await getApplicationSupportDirectory();
        targetDir = Directory(p.join(appSupport.path, 'story_cards'));
      }
    }

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final filePath = p.join(targetDir.path, '$fileName.png');
    final file = File(filePath);
    await file.writeAsBytes(pngBytes, flush: true);
    return file;
  }
}
