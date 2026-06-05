import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/daily_goal_model.dart';
import '../models/weekly_goal_model.dart';
import '../models/activity_model.dart';

class GoalViewModel extends ChangeNotifier {
  final Box<DailyGoal> _dailyGoalBox =
      Hive.box<DailyGoal>('daily_goals');

  final Box<WeeklyGoal> _weeklyGoalBox =
      Hive.box<WeeklyGoal>('weekly_goals');

  final Box<Activity> _activityBox =
      Hive.box<Activity>('activities');

  // ======================
  // DAILY GOAL
  // ======================

  DailyGoal? getTodayGoal() {
    final today = DateTime.now();

    try {
      return _dailyGoalBox.values.firstWhere(
        (goal) =>
            goal.date.year == today.year &&
            goal.date.month == today.month &&
            goal.date.day == today.day,
      );
    } catch (_) {
      return null;
    }
  }

  bool isTodayGoalSet() {
    return getTodayGoal() != null;
  }

  Future<void> saveDailyGoal(
    int targetActivities,
  ) async {
    await _dailyGoalBox.add(
      DailyGoal(
        date: DateTime.now(),
        targetActivities: targetActivities,
      ),
    );

    notifyListeners();
  }

  // ======================
  // WEEKLY GOAL
  // ======================

  WeeklyGoal? getCurrentWeekGoal() {
    final now = DateTime.now();

    try {
      return _weeklyGoalBox.values.firstWhere(
        (goal) {
          final difference =
              now.difference(
                goal.weekStartDate,
              ).inDays;

          return difference >= 0 &&
              difference < 7;
        },
      );
    } catch (_) {
      return null;
    }
  }

  bool isCurrentWeekGoalSet() {
    return getCurrentWeekGoal() != null;
  }

  Future<void> saveWeeklyGoal(
    int targetActivities,
  ) async {
    final now = DateTime.now();

    final monday = now.subtract(
      Duration(
        days: now.weekday - 1,
      ),
    );

    await _weeklyGoalBox.add(
      WeeklyGoal(
        weekStartDate: monday,
        targetActivities: targetActivities,
      ),
    );

    notifyListeners();
  }

  // ======================
  // DAILY PROGRESS
  // ======================

  int getTodayCompletedActivities() {
    final today = DateTime.now();

    return _activityBox.values.where(
      (activity) {
        return activity.activityDate.year ==
                today.year &&
            activity.activityDate.month ==
                today.month &&
            activity.activityDate.day ==
                today.day;
      },
    ).length;
  }

  double getTodayProgress() {
    final goal = getTodayGoal();

    if (goal == null ||
        goal.targetActivities == 0) {
      return 0;
    }

    return getTodayCompletedActivities() /
        goal.targetActivities;
  }

  // ======================
  // WEEKLY PROGRESS
  // ======================

  int getWeeklyCompletedActivities() {
    final now = DateTime.now();

    final monday = now.subtract(
      Duration(
        days: now.weekday - 1,
      ),
    );

    return _activityBox.values.where(
      (activity) {
        return activity.activityDate.isAfter(
              monday.subtract(
                const Duration(days: 1),
              ),
            ) &&
            activity.activityDate.isBefore(
              monday.add(
                const Duration(days: 7),
              ),
            );
      },
    ).length;
  }

  double getWeeklyProgress() {
    final goal = getCurrentWeekGoal();

    if (goal == null ||
        goal.targetActivities == 0) {
      return 0;
    }

    return getWeeklyCompletedActivities() /
        goal.targetActivities;
  }
}