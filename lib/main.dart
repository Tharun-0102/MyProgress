import 'package:day_activity_tracker/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';

import 'models/daily_goal_model.dart';
import 'models/weekly_goal_model.dart';
import 'viewmodels/activity_view_model.dart';
import 'viewmodels/goal_view_model.dart';

import 'models/activity_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(DailyGoalAdapter());
  Hive.registerAdapter(WeeklyGoalAdapter());

  await Hive.openBox<Activity>('activities');
  await Hive.openBox<DailyGoal>('daily_goals');
  await Hive.openBox<WeeklyGoal>('weekly_goals');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ActivityViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}