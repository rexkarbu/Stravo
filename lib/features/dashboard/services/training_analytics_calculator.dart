import '../models/dashboard_models.dart';

/// Service that computes training volume aggregations (weekly/monthly) and
/// detects all-time personal records across athlete activities.
class TrainingAnalyticsCalculator {
  const TrainingAnalyticsCalculator();

  /// Calculates weekly training volumes grouped by Monday of each week.
  List<WeeklyVolume> calculateWeeklyVolumes(List<ActivitySummary> activities) =>
      computeWeeklyVolumes(activities);

  /// Calculates monthly training volumes grouped by "YYYY-MM".
  List<MonthlyVolume> calculateMonthlyVolumes(List<ActivitySummary> activities) =>
      computeMonthlyVolumes(activities);

  /// Evaluates all-time personal records across all provided [activities].
  PersonalRecords evaluatePersonalRecords(List<ActivitySummary> activities) =>
      computePersonalRecords(activities);

  /// Static implementation for [calculateWeeklyVolumes].
  static List<WeeklyVolume> computeWeeklyVolumes(
    List<ActivitySummary> activities,
  ) {
    if (activities.isEmpty) return [];

    final groups = <DateTime, List<ActivitySummary>>{};
    for (final act in activities) {
      final d = DateTime(act.date.year, act.date.month, act.date.day);
      final monday = d.subtract(Duration(days: d.weekday - 1));
      groups.putIfAbsent(monday, () => []).add(act);
    }

    final sortedWeeks = groups.keys.toList()..sort();

    return sortedWeeks.map((week) {
      final acts = groups[week]!;
      final totalDist = acts.fold<double>(0.0, (sum, a) => sum + a.distanceKm);
      final totalElev =
          acts.fold<double>(0.0, (sum, a) => sum + a.elevationGainMeters);
      return WeeklyVolume(
        weekStart: week,
        totalDistanceKm: double.parse(totalDist.toStringAsFixed(2)),
        totalElevationGainM: double.parse(totalElev.toStringAsFixed(1)),
        activityCount: acts.length,
      );
    }).toList();
  }

  /// Static implementation for [calculateMonthlyVolumes].
  static List<MonthlyVolume> computeMonthlyVolumes(
    List<ActivitySummary> activities,
  ) {
    if (activities.isEmpty) return [];

    final groups = <String, List<ActivitySummary>>{};
    for (final act in activities) {
      final monthStr = act.date.month.toString().padLeft(2, '0');
      final ym = '${act.date.year}-$monthStr';
      groups.putIfAbsent(ym, () => []).add(act);
    }

    final sortedMonths = groups.keys.toList()..sort();

    return sortedMonths.map((ym) {
      final acts = groups[ym]!;
      final totalDist = acts.fold<double>(0.0, (sum, a) => sum + a.distanceKm);
      final totalElev =
          acts.fold<double>(0.0, (sum, a) => sum + a.elevationGainMeters);
      return MonthlyVolume(
        yearMonth: ym,
        totalDistanceKm: double.parse(totalDist.toStringAsFixed(2)),
        totalElevationGainM: double.parse(totalElev.toStringAsFixed(1)),
        activityCount: acts.length,
      );
    }).toList();
  }

  /// Static implementation for [evaluatePersonalRecords].
  static PersonalRecords computePersonalRecords(
    List<ActivitySummary> activities,
  ) {
    if (activities.isEmpty) return const PersonalRecords();

    ActivitySummary? longestDistAct;
    ActivitySummary? highestSpeedAct;
    ActivitySummary? biggestElevAct;
    ActivitySummary? fastestPaceAct;

    for (final act in activities) {
      if (longestDistAct == null ||
          act.distanceMeters > longestDistAct.distanceMeters) {
        longestDistAct = act;
      }
      if (highestSpeedAct == null ||
          act.maxSpeedMs > highestSpeedAct.maxSpeedMs) {
        highestSpeedAct = act;
      }
      if (biggestElevAct == null ||
          act.elevationGainMeters > biggestElevAct.elevationGainMeters) {
        biggestElevAct = act;
      }
      if (act.durationSeconds > 0 && act.distanceMeters > 0) {
        if (fastestPaceAct == null ||
            act.avgSpeedKmH > fastestPaceAct.avgSpeedKmH) {
          fastestPaceAct = act;
        }
      }
    }

    return PersonalRecords(
      longestDistanceKm: longestDistAct != null
          ? PersonalRecordItem(
              metricName: 'Longest Distance',
              valueFormatted:
                  '${longestDistAct.distanceKm.toStringAsFixed(1)} km',
              activityId: longestDistAct.id,
              achievedDate: longestDistAct.date,
              rawValue: longestDistAct.distanceKm,
            )
          : null,
      highestSpeedKmH: highestSpeedAct != null
          ? PersonalRecordItem(
              metricName: 'Highest Speed',
              valueFormatted:
                  '${highestSpeedAct.maxSpeedKmH.toStringAsFixed(1)} km/h',
              activityId: highestSpeedAct.id,
              achievedDate: highestSpeedAct.date,
              rawValue: highestSpeedAct.maxSpeedKmH,
            )
          : null,
      biggestElevationGainM: biggestElevAct != null
          ? PersonalRecordItem(
              metricName: 'Biggest Elevation Gain',
              valueFormatted:
                  '${biggestElevAct.elevationGainMeters.toStringAsFixed(0)} m',
              activityId: biggestElevAct.id,
              achievedDate: biggestElevAct.date,
              rawValue: biggestElevAct.elevationGainMeters,
            )
          : null,
      fastestPaceKmH: fastestPaceAct != null
          ? PersonalRecordItem(
              metricName: 'Fastest Pace',
              valueFormatted:
                  '${fastestPaceAct.avgSpeedKmH.toStringAsFixed(1)} km/h',
              activityId: fastestPaceAct.id,
              achievedDate: fastestPaceAct.date,
              rawValue: fastestPaceAct.avgSpeedKmH,
            )
          : null,
    );
  }
}
