import 'package:hive/hive.dart';

part 'daily_goal_model.g.dart';

@HiveType(typeId: 2)
class DailyGoal extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int targetActivities;

  DailyGoal({
    required this.date,
    required this.targetActivities,
  });
}