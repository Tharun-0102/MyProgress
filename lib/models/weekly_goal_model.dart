import 'package:hive/hive.dart';

part 'weekly_goal_model.g.dart';

@HiveType(typeId: 1)
class WeeklyGoal extends HiveObject {
  @HiveField(0)
  DateTime weekStartDate;

  @HiveField(1)
  int targetActivities;

  WeeklyGoal({
    required this.weekStartDate,
    required this.targetActivities,
  });
}