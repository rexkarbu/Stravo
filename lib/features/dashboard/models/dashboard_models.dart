import 'package:flutter/foundation.dart';
import 'package:stravo/core/constants/enums.dart';

/// Summary of a single completed outdoor activity.
@immutable
class ActivitySummary {
  final String id;
  final DateTime date;
  final double distanceMeters;
  final double durationSeconds;
  final double elevationGainMeters;
  final double maxSpeedMs;
  final SportType sportType;

  const ActivitySummary({
    required this.id,
    required this.date,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.elevationGainMeters,
    required this.maxSpeedMs,
    required this.sportType,
  });

  double get distanceKm => distanceMeters / 1000.0;
  double get maxSpeedKmH => maxSpeedMs * 3.6;
  double get avgSpeedKmH =>
      durationSeconds > 0 ? (distanceMeters / durationSeconds) * 3.6 : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivitySummary &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Aggregated training volume for a single calendar week (Monday to Sunday).
@immutable
class WeeklyVolume {
  final DateTime weekStart;
  final double totalDistanceKm;
  final double totalElevationGainM;
  final int activityCount;

  const WeeklyVolume({
    required this.weekStart,
    required this.totalDistanceKm,
    required this.totalElevationGainM,
    required this.activityCount,
  });

  @override
  String toString() =>
      'WeeklyVolume(week: ${weekStart.toIso8601String().split('T')[0]}, dist: ${totalDistanceKm}km, elev: ${totalElevationGainM}m, count: $activityCount)';
}

/// Aggregated training volume for a single calendar month.
@immutable
class MonthlyVolume {
  /// Year and month in YYYY-MM format (e.g. "2026-09").
  final String yearMonth;
  final double totalDistanceKm;
  final double totalElevationGainM;
  final int activityCount;

  const MonthlyVolume({
    required this.yearMonth,
    required this.totalDistanceKm,
    required this.totalElevationGainM,
    required this.activityCount,
  });

  @override
  String toString() =>
      'MonthlyVolume(month: $yearMonth, dist: ${totalDistanceKm}km, elev: ${totalElevationGainM}m, count: $activityCount)';
}

/// A specific personal record entry.
@immutable
class PersonalRecordItem {
  final String metricName;
  final String valueFormatted;
  final String activityId;
  final DateTime achievedDate;
  final double rawValue;

  const PersonalRecordItem({
    required this.metricName,
    required this.valueFormatted,
    required this.activityId,
    required this.achievedDate,
    this.rawValue = 0.0,
  });

  @override
  String toString() => '$metricName: $valueFormatted ($activityId)';
}

/// All-time personal records container.
@immutable
class PersonalRecords {
  final PersonalRecordItem? longestDistanceKm;
  final PersonalRecordItem? highestSpeedKmH;
  final PersonalRecordItem? biggestElevationGainM;
  final PersonalRecordItem? fastestPaceKmH;

  const PersonalRecords({
    this.longestDistanceKm,
    this.highestSpeedKmH,
    this.biggestElevationGainM,
    this.fastestPaceKmH,
  });

  bool get isEmpty =>
      longestDistanceKm == null &&
      highestSpeedKmH == null &&
      biggestElevationGainM == null &&
      fastestPaceKmH == null;

  bool get isNotEmpty => !isEmpty;
}
