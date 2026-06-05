import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/activity_model.dart';

class ActivityViewModel extends ChangeNotifier {
  final Box<Activity> _box = Hive.box<Activity>('activities');

  List<Activity> get allActivities => _box.values.toList();

  List<Activity> getActivitiesByDate(DateTime date) {
    return _box.values.where((activity) {
      return activity.activityDate.year == date.year &&
          activity.activityDate.month == date.month &&
          activity.activityDate.day == date.day;
    }).toList();
  }

  Future<void> addActivity(Activity activity) async {
    await _box.add(activity);
    notifyListeners();
  }

  Future<void> deleteActivity(Activity activity) async {
    await activity.delete();
    notifyListeners();
  }

  Future<void> updateActivity(
    Activity activity,
    String title,
    String description,
    List<String> imagePaths,
  ) async {
    activity.title = title;
    activity.description = description;
    activity.imagePaths = imagePaths;

    await activity.save();

    notifyListeners();
  }

  int getActivityCount(DateTime date) {
    return _box.values.where((activity) {
      return activity.activityDate.year == date.year &&
          activity.activityDate.month == date.month &&
          activity.activityDate.day == date.day;
    }).length;
  }

  int get totalActivities => _box.length;

  int get totalTrackedDays {
    final dates = _box.values
        .map(
          (e) =>
              "${e.activityDate.year}-${e.activityDate.month}-${e.activityDate.day}",
        )
        .toSet();

    return dates.length;
  }

  int get activitiesThisMonth {
    final now = DateTime.now();

    return _box.values.where((activity) {
      return activity.activityDate.month == now.month &&
          activity.activityDate.year == now.year;
    }).length;
  }

  int getCurrentStreak() {
    final dates = _box.values
        .map(
          (e) => DateTime(
            e.activityDate.year,
            e.activityDate.month,
            e.activityDate.day,
          ),
        )
        .toSet();

    int streak = 0;

    DateTime day = DateTime.now();

    while (dates.contains(DateTime(day.year, day.month, day.day))) {
      streak++;

      day = day.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Map<DateTime, int> getHeatMapData() {
  final currentYear = DateTime.now().year;

  final Map<DateTime, int> data = {};

  for (final activity in _box.values) {
    if (activity.activityDate.year != currentYear) {
      continue;
    }

    final date = DateTime(
      activity.activityDate.year,
      activity.activityDate.month,
      activity.activityDate.day,
    );

    data[date] =
        (data[date] ?? 0) + 1;
  }

  return data;
}
  Map<int, int> getCurrentYearMonthlyData() {
    final currentYear = DateTime.now().year;

    // Initialize all 12 months with 0
    final Map<int, int> monthlyData = {
      for (int month = 1; month <= 12; month++) month: 0,
    };

    for (final activity in _box.values) {
      if (activity.activityDate.year == currentYear) {
        monthlyData[activity.activityDate.month] =
            monthlyData[activity.activityDate.month]! + 1;
      }
    }

    return monthlyData;
  }
}
