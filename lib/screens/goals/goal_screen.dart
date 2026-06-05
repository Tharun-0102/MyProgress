import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/goal_view_model.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GoalViewModel>();

    final dailyGoal = vm.getTodayGoal();
    final weeklyGoal = vm.getCurrentWeekGoal();

    final dailyCompleted =
        vm.getTodayCompletedActivities();

    final weeklyCompleted =
        vm.getWeeklyCompletedActivities();

    return Scaffold(
      backgroundColor: const Color(0xFF3F3F3F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3F3F3F),
        title: const Text(
          "Goals",
          style: TextStyle(
            color: Color(0xFFEDE4E0),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // DAILY GOAL CARD

          _goalCard(
            title: "Today's Goal",
            icon: Icons.today,
            target:
                dailyGoal?.targetActivities ??
                0,
            completed:
                dailyCompleted,
            progress:
                vm.getTodayProgress(),
            color:
                const Color(0xFF8BB56A),
          ),

          const SizedBox(height: 20),

          // WEEKLY GOAL CARD

          _goalCard(
            title: "Weekly Goal",
            icon: Icons.flag,
            target:
                weeklyGoal?.targetActivities ??
                0,
            completed:
                weeklyCompleted,
            progress:
                vm.getWeeklyProgress(),
            color:
                const Color(0xFFC98867),
          ),

          const SizedBox(height: 30),

          if (dailyGoal == null)
            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF8BB56A,
                ),
                foregroundColor:
                    const Color(
                  0xFF3F3F3F,
                ),
                minimumSize:
                    const Size(
                  double.infinity,
                  55,
                ),
              ),
              onPressed: () {
                _showDailyGoalDialog(
                  context,
                );
              },
              icon: const Icon(
                Icons.add,
              ),
              label: const Text(
                "Set Daily Goal",
              ),
            ),

          const SizedBox(height: 15),

          if (weeklyGoal == null)
            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFC98867,
                ),
                foregroundColor:
                    const Color(
                  0xFF3F3F3F,
                ),
                minimumSize:
                    const Size(
                  double.infinity,
                  55,
                ),
              ),
              onPressed: () {
                _showWeeklyGoalDialog(
                  context,
                );
              },
              icon: const Icon(
                Icons.add,
              ),
              label: const Text(
                "Set Weekly Goal",
              ),
            ),
        ],
      ),
    );
  }

  Widget _goalCard({
    required String title,
    required IconData icon,
    required int target,
    required int completed,
    required double progress,
    required Color color,
  }) {
    return Card(
      color: const Color(0xFF665A48),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFFEDE4E0,
                    ),
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              "$completed / $target Completed",
              style:
                  const TextStyle(
                color:
                    Color(
                  0xFFEDE4E0,
                ),
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            LinearProgressIndicator(
              value: progress > 1
                  ? 1
                  : progress,
              backgroundColor:
                  Colors.black26,
              color: color,
              minHeight: 12,
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style:
                  const TextStyle(
                color:
                    Color(
                  0xFFC8D3BE,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDailyGoalDialog(
    BuildContext context,
  ) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Daily Goal",
          ),
          content: TextField(
            controller:
                controller,
            keyboardType:
                TextInputType.number,
            decoration:
                const InputDecoration(
              hintText:
                  "Enter target",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final value =
                    int.tryParse(
                          controller.text,
                        ) ??
                        0;

                await context
                    .read<
                        GoalViewModel>()
                    .saveDailyGoal(
                      value,
                    );

                if (context.mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child:
                  const Text(
                "Save",
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWeeklyGoalDialog(
    BuildContext context,
  ) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Weekly Goal",
          ),
          content: TextField(
            controller:
                controller,
            keyboardType:
                TextInputType.number,
            decoration:
                const InputDecoration(
              hintText:
                  "Enter target",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final value =
                    int.tryParse(
                          controller.text,
                        ) ??
                        0;

                await context
                    .read<
                        GoalViewModel>()
                    .saveWeeklyGoal(
                      value,
                    );

                if (context.mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child:
                  const Text(
                "Save",
              ),
            ),
          ],
        );
      },
    );
  }
}