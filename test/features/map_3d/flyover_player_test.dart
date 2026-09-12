import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/features/map_3d/controllers/camera_3d_controller.dart';
import 'package:stravo/features/map_3d/domain/models/route_coordinate.dart';
import 'package:stravo/features/map_3d/widgets/flyover_player.dart';

void main() {
  final sampleRoute = [
    const RouteCoordinate(latitude: -7.150, longitude: 107.780, elevation: 1400.0, speed: 5.0),
    const RouteCoordinate(latitude: -7.151, longitude: 107.782, elevation: 1450.0, speed: 7.0),
    const RouteCoordinate(latitude: -7.152, longitude: 107.784, elevation: 1500.0, speed: 10.0),
  ];

  late Camera3DController controller;

  setUp(() {
    controller = Camera3DController(route: sampleRoute);
  });

  testWidgets('FlyoverPlayer renders initial Telemetry HUD with correct metric formats', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlyoverPlayer(
            controller: controller,
            baseDuration: const Duration(seconds: 10),
          ),
        ),
      ),
    );

    // Initial progress 0.0 checks
    expect(find.byKey(const Key('hud_speed_text')), findsOneWidget);
    expect(find.byKey(const Key('hud_elevation_text')), findsOneWidget);
    expect(find.byKey(const Key('hud_gradient_text')), findsOneWidget);
    expect(find.byKey(const Key('hud_distance_text')), findsOneWidget);

    // Initial distance is 0.00 km
    final distFinder = find.byKey(const Key('hud_distance_text'));
    final Text distText = tester.widget(distFinder);
    expect(distText.data, '0.00 km');

    // Initial elevation is 1400 m
    final elevFinder = find.byKey(const Key('hud_elevation_text'));
    final Text elevText = tester.widget(elevFinder);
    expect(elevText.data, '1400 m');
  });

  testWidgets('Play/Pause toggle button changes playback state', (tester) async {
    Camera3DState? lastUpdatedState;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlyoverPlayer(
            controller: controller,
            baseDuration: const Duration(seconds: 10),
            onCameraUpdate: (state) {
              lastUpdatedState = state;
            },
          ),
        ),
      ),
    );

    final playerState = tester.state<FlyoverPlayerState>(find.byType(FlyoverPlayer));
    expect(playerState.isPlaying, isFalse);

    // Tap play
    await tester.tap(find.byKey(const Key('flyover_play_pause_button')));
    await tester.pump();
    expect(playerState.isPlaying, isTrue);

    // Advance 1 second
    await tester.pump(const Duration(seconds: 1));
    expect(lastUpdatedState, isNotNull);
    expect(lastUpdatedState!.progress, greaterThan(0.0));

    // Tap pause
    await tester.tap(find.byKey(const Key('flyover_play_pause_button')));
    await tester.pump();
    expect(playerState.isPlaying, isFalse);
  });

  testWidgets('Scrubber slider interaction triggers camera position updates', (tester) async {
    Camera3DState? lastUpdatedState;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlyoverPlayer(
            controller: controller,
            baseDuration: const Duration(seconds: 10),
            onCameraUpdate: (state) {
              lastUpdatedState = state;
            },
          ),
        ),
      ),
    );

    final playerState = tester.state<FlyoverPlayerState>(find.byType(FlyoverPlayer));

    // Programmatically seek to 50%
    playerState.seek(0.5);
    await tester.pump();

    expect(playerState.currentState.progress, closeTo(0.5, 0.01));
    expect(lastUpdatedState, isNotNull);
    expect(lastUpdatedState!.progress, closeTo(0.5, 0.01));
  });

  testWidgets('Selecting speed chips changes speed multiplier (1x, 2x, 4x, 8x)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlyoverPlayer(
            controller: controller,
            baseDuration: const Duration(seconds: 40),
          ),
        ),
      ),
    );

    final playerState = tester.state<FlyoverPlayerState>(find.byType(FlyoverPlayer));
    expect(playerState.speedMultiplier, 1.0);

    // Select 2x
    await tester.tap(find.byKey(const Key('speed_2x')));
    await tester.pump();
    expect(playerState.speedMultiplier, 2.0);

    // Select 4x
    await tester.tap(find.byKey(const Key('speed_4x')));
    await tester.pump();
    expect(playerState.speedMultiplier, 4.0);

    // Select 8x
    await tester.tap(find.byKey(const Key('speed_8x')));
    await tester.pump();
    expect(playerState.speedMultiplier, 8.0);

    // Back to 1x
    await tester.tap(find.byKey(const Key('speed_1x')));
    await tester.pump();
    expect(playerState.speedMultiplier, 1.0);
  });
}
