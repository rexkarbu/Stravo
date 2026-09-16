import 'package:flutter/material.dart';
import 'package:stravo/core/widgets/surface_type_badge.dart';

class ActivityItemModel {
  final String id;
  final String title;
  final String activityType; // 'Gravel', 'Road', 'MTB', 'Run', 'Hike'
  final DateTime dateTime;
  final double distanceKm;
  final Duration duration;
  final int elevationGainMeters;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final SurfaceType primarySurface;
  final double gravelRatio; // 0.0 to 1.0
  final List<Offset> routePoints;
  final List<double> elevationProfile;
  final List<String> photos;

  const ActivityItemModel({
    required this.id,
    required this.title,
    required this.activityType,
    required this.dateTime,
    required this.distanceKm,
    required this.duration,
    required this.elevationGainMeters,
    required this.avgSpeedKmh,
    required this.maxSpeedKmh,
    required this.primarySurface,
    required this.gravelRatio,
    required this.routePoints,
    required this.elevationProfile,
    this.photos = const [],
  });

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}j ${minutes}m';
    }
    return '${minutes}m ${seconds}s';
  }

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final date = dateTime;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year} • $hour:$minute';
  }

  static List<ActivityItemModel> getMockActivities() {
    return [
      ActivityItemModel(
        id: 'act_1',
        title: 'Morning Pine Gravel Loop',
        activityType: 'Gravel',
        dateTime: DateTime.now().subtract(const Duration(hours: 3)),
        distanceKm: 42.8,
        duration: const Duration(hours: 1, minutes: 48, seconds: 12),
        elevationGainMeters: 620,
        avgSpeedKmh: 23.8,
        maxSpeedKmh: 48.5,
        primarySurface: SurfaceType.fineGravel,
        gravelRatio: 0.72,
        routePoints: const [
          Offset(10, 40),
          Offset(25, 20),
          Offset(45, 15),
          Offset(60, 30),
          Offset(80, 25),
          Offset(95, 45),
          Offset(85, 75),
          Offset(55, 80),
          Offset(30, 65),
          Offset(10, 40),
        ],
        elevationProfile: const [
          320, 340, 390, 480, 560, 610, 590, 640, 580, 490, 410, 330
        ],
        photos: const [
          'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=500&q=80',
          'https://images.unsplash.com/photo-1502744688674-c619d3864003?w=500&q=80',
          'https://images.unsplash.com/photo-1471506480208-91b3a4cc78be?w=500&q=80',
        ],
      ),
      ActivityItemModel(
        id: 'act_2',
        title: 'Kopeng Hillclimb Attack',
        activityType: 'Road',
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        distanceKm: 64.2,
        duration: const Duration(hours: 2, minutes: 35, seconds: 40),
        elevationGainMeters: 1180,
        avgSpeedKmh: 24.9,
        maxSpeedKmh: 62.4,
        primarySurface: SurfaceType.smoothAsphalt,
        gravelRatio: 0.05,
        routePoints: const [
          Offset(15, 85),
          Offset(30, 70),
          Offset(40, 50),
          Offset(60, 45),
          Offset(75, 30),
          Offset(85, 15),
          Offset(90, 25),
        ],
        elevationProfile: const [
          250, 290, 380, 520, 700, 910, 1150, 1380, 1420
        ],
        photos: const [
          'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=500&q=80',
        ],
      ),
      ActivityItemModel(
        id: 'act_3',
        title: 'Singletrack Downhill & Mud',
        activityType: 'MTB',
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        distanceKm: 28.4,
        duration: const Duration(hours: 1, minutes: 55, seconds: 0),
        elevationGainMeters: 450,
        avgSpeedKmh: 14.8,
        maxSpeedKmh: 41.2,
        primarySurface: SurfaceType.singletrack,
        gravelRatio: 0.88,
        routePoints: const [
          Offset(20, 20),
          Offset(40, 35),
          Offset(35, 60),
          Offset(60, 75),
          Offset(80, 55),
          Offset(75, 30),
          Offset(50, 15),
          Offset(20, 20),
        ],
        elevationProfile: const [
          500, 560, 510, 480, 420, 460, 390, 350, 320
        ],
        photos: const [],
      ),
      ActivityItemModel(
        id: 'act_4',
        title: 'Sunset Fast Recovery Run',
        activityType: 'Run',
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        distanceKm: 10.2,
        duration: const Duration(minutes: 51, seconds: 15),
        elevationGainMeters: 85,
        avgSpeedKmh: 12.0,
        maxSpeedKmh: 15.2,
        primarySurface: SurfaceType.smoothAsphalt,
        gravelRatio: 0.0,
        routePoints: const [
          Offset(15, 30),
          Offset(40, 25),
          Offset(80, 30),
          Offset(85, 70),
          Offset(50, 75),
          Offset(15, 60),
          Offset(15, 30),
        ],
        elevationProfile: const [
          110, 115, 125, 130, 120, 112, 110
        ],
        photos: const [],
      ),
    ];
  }
}
