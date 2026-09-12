import 'package:flutter_test/flutter_test.dart';
import 'package:stravo/core/constants/enums.dart';
import 'package:stravo/features/dashboard/models/dashboard_models.dart';
import 'package:stravo/features/dashboard/services/training_analytics_calculator.dart';

void main() {
  const calculator = TrainingAnalyticsCalculator();

  final sampleActivities = [
    ActivitySummary(
      id: 'act_1',
      date: DateTime(2026, 9, 1, 8, 0), // Tuesday
      distanceMeters: 45000.0, // 45 km
      durationSeconds: 5400.0, // 1.5 hr -> avg speed 30 km/h
      elevationGainMeters: 650.0,
      maxSpeedMs: 15.0, // 54 km/h
      sportType: SportType.gravelCycling,
    ),
    ActivitySummary(
      id: 'act_2',
      date: DateTime(2026, 9, 3, 7, 30), // Thursday (same week)
      distanceMeters: 25000.0, // 25 km
      durationSeconds: 3600.0, // 1 hr -> avg speed 25 km/h
      elevationGainMeters: 400.0,
      maxSpeedMs: 12.0, // 43.2 km/h
      sportType: SportType.gravelCycling,
    ),
    ActivitySummary(
      id: 'act_3',
      date: DateTime(2026, 9, 10, 6, 0), // Next week
      distanceMeters: 80000.0, // 80 km (longest!)
      durationSeconds: 8000.0, // 36 km/h (fastest pace!)
      elevationGainMeters: 1250.0, // biggest elevation!
      maxSpeedMs: 20.0, // 72 km/h (highest speed!)
      sportType: SportType.roadCycling,
    ),
    ActivitySummary(
      id: 'act_4',
      date: DateTime(2026, 8, 25, 9, 0), // August
      distanceMeters: 30000.0, // 30 km
      durationSeconds: 4000.0,
      elevationGainMeters: 300.0,
      maxSpeedMs: 11.0,
      sportType: SportType.roadRunning,
    ),
  ];

  group('TrainingAnalyticsCalculator - Weekly Volumes', () {
    test('aggregates distance, elevation, and count per week correctly', () {
      final weekly = calculator.calculateWeeklyVolumes(sampleActivities);

      expect(weekly, isNotEmpty);
      // Week 1 (from Aug 24 to Aug 30) -> act_4
      // Week 2 (from Aug 31 to Sep 6) -> act_1 and act_2
      // Week 3 (from Sep 7 to Sep 13) -> act_3
      expect(weekly.length, equals(3));

      // Check sorted chronologically
      expect(weekly[0].weekStart.isBefore(weekly[1].weekStart), isTrue);
      expect(weekly[1].weekStart.isBefore(weekly[2].weekStart), isTrue);

      // Week 2 (Sep 1 and Sep 3): 45km + 25km = 70km, 650m + 400m = 1050m, 2 acts
      final week2 = weekly[1];
      expect(week2.totalDistanceKm, closeTo(70.0, 0.01));
      expect(week2.totalElevationGainM, closeTo(1050.0, 0.01));
      expect(week2.activityCount, equals(2));
    });

    test('returns empty list for empty activity input', () {
      final weekly = calculator.calculateWeeklyVolumes([]);
      expect(weekly, isEmpty);
    });
  });

  group('TrainingAnalyticsCalculator - Monthly Volumes', () {
    test('aggregates distance, elevation, and count per month correctly', () {
      final monthly = calculator.calculateMonthlyVolumes(sampleActivities);

      expect(monthly.length, equals(2));
      // Chronological: 2026-08 first, then 2026-09
      expect(monthly[0].yearMonth, equals('2026-08'));
      expect(monthly[0].totalDistanceKm, closeTo(30.0, 0.01));
      expect(monthly[0].activityCount, equals(1));

      expect(monthly[1].yearMonth, equals('2026-09'));
      // Sep: 45 + 25 + 80 = 150 km
      expect(monthly[1].totalDistanceKm, closeTo(150.0, 0.01));
      // Elev: 650 + 400 + 1250 = 2300 m
      expect(monthly[1].totalElevationGainM, closeTo(2300.0, 0.01));
      expect(monthly[1].activityCount, equals(3));
    });

    test('returns empty list for empty activity input', () {
      final monthly = calculator.calculateMonthlyVolumes([]);
      expect(monthly, isEmpty);
    });
  });

  group('TrainingAnalyticsCalculator - Personal Records', () {
    test('correctly detects all-time PR records', () {
      final prs = calculator.evaluatePersonalRecords(sampleActivities);

      expect(prs.isEmpty, isFalse);
      expect(prs.isNotEmpty, isTrue);

      // Longest distance: act_3 with 80 km
      expect(prs.longestDistanceKm, isNotNull);
      expect(prs.longestDistanceKm!.activityId, equals('act_3'));
      expect(prs.longestDistanceKm!.rawValue, closeTo(80.0, 0.01));
      expect(prs.longestDistanceKm!.valueFormatted, contains('80.0 km'));

      // Highest speed: act_3 with 20 m/s = 72 km/h
      expect(prs.highestSpeedKmH, isNotNull);
      expect(prs.highestSpeedKmH!.activityId, equals('act_3'));
      expect(prs.highestSpeedKmH!.rawValue, closeTo(72.0, 0.01));
      expect(prs.highestSpeedKmH!.valueFormatted, contains('72.0 km/h'));

      // Biggest elevation gain: act_3 with 1250 m
      expect(prs.biggestElevationGainM, isNotNull);
      expect(prs.biggestElevationGainM!.activityId, equals('act_3'));
      expect(prs.biggestElevationGainM!.rawValue, closeTo(1250.0, 0.01));
      expect(prs.biggestElevationGainM!.valueFormatted, contains('1250 m'));

      // Fastest pace: act_3 with 80000m / 8000s = 10 m/s * 3.6 = 36 km/h
      expect(prs.fastestPaceKmH, isNotNull);
      expect(prs.fastestPaceKmH!.activityId, equals('act_3'));
      expect(prs.fastestPaceKmH!.rawValue, closeTo(36.0, 0.01));
    });

    test('returns empty PersonalRecords when activities list is empty', () {
      final prs = calculator.evaluatePersonalRecords([]);
      expect(prs.isEmpty, isTrue);
      expect(prs.longestDistanceKm, isNull);
      expect(prs.highestSpeedKmH, isNull);
      expect(prs.biggestElevationGainM, isNull);
      expect(prs.fastestPaceKmH, isNull);
    });
  });
}
