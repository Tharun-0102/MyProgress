import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 0)
class Activity extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime activityDate;

  @HiveField(3)
  List<String> imagePaths;

  Activity({
    required this.title,
    required this.description,
    required this.activityDate,
    required this.imagePaths,
  });
}