import 'package:day_activity_tracker/viewmodels/goal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../activity_screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/activity_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGoals();
    });
  }

  Future<void> _checkGoals() async {
    final goalVM = context.read<GoalViewModel>();
    final now = DateTime.now();

    if (now.weekday == DateTime.monday && !goalVM.isCurrentWeekGoalSet()) {
      await _showWeeklyGoalDialog();
    }

    if (!goalVM.isTodayGoalSet()) {
      await _showDailyGoalDialog();
    }
  }

  Future<void> _showWeeklyGoalDialog() async {
    final controller = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF665A48),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "🎯 Weekly Goal",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEDE4E0),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "How many activities will you complete this week?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFC8D3BE)),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(color: Color(0xFFEDE4E0)),
                decoration: InputDecoration(
                  hintText: "Enter weekly goal",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF3F3F3F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC98867),
                    foregroundColor: const Color(0xFF3F3F3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final value = int.tryParse(controller.text) ?? 0;
                    await context.read<GoalViewModel>().saveWeeklyGoal(value);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save Goal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDailyGoalDialog() async {
    final controller = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF665A48),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "🎯 Daily Goal",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEDE4E0),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "How many activities will you complete today?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFC8D3BE)),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(color: Color(0xFFEDE4E0)),
                decoration: InputDecoration(
                  hintText: "Enter daily goal",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF3F3F3F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BB56A),
                    foregroundColor: const Color(0xFF3F3F3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final value = int.tryParse(controller.text) ?? 0;
                    await context.read<GoalViewModel>().saveDailyGoal(value);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save Goal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFF3F3F3F),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF3F3F3F),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFFC8D3BE),
              size: 26,
            ),
            SizedBox(width: 8),
            Text(
              "Daily Tracker",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Color(0xFFEDE4E0),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(                          // ← scrollable body
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Daily goal progress card ──────────────────────────────────
            Consumer<GoalViewModel>(
              builder: (context, goalVM, child) {
                final goal = goalVM.getTodayGoal();
                if (goal == null) return const SizedBox();

                final activityVM = context.watch<ActivityViewModel>();       // ← live count
                final completed  = activityVM.getActivityCount(today);
                final target     = goal.targetActivities;
                final progress   = target > 0 ? completed / target : 0.0;

                return Card(
                  color: const Color(0xFF665A48),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "🎯 Today's Goal",
                          style: TextStyle(
                            color: Color(0xFFEDE4E0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$completed / $target",
                          style: const TextStyle(
                            color: Color(0xFFC8D3BE),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: Colors.black26,
                          color: const Color(0xFF8BB56A),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // ── Calendar ─────────────────────────────────────────────────
            Consumer<ActivityViewModel>(
              builder: (context, vm, child) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF665A48),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime(2026),
                    lastDay: DateTime(3000),
                    focusedDay: _focusedDay,
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        final count = vm.getActivityCount(day);
                        if (count == 0) return null;

                        return Positioned(
                          bottom: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8BB56A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Color(0xFF3F3F3F),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay  = focusedDay;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ActivityScreen(selectedDate: selectedDay),
                        ),
                      );
                    },
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        color: Color(0xFFEDE4E0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Color(0xFFC8D3BE),
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Color(0xFFC8D3BE),
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Color(0xFFC8D3BE),
                        fontWeight: FontWeight.w600,
                      ),
                      weekendStyle: TextStyle(
                        color: Color(0xFFD4B1A0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(
                        color: Color(0xFFEDE4E0),
                        fontWeight: FontWeight.w500,
                      ),
                      weekendTextStyle: TextStyle(color: Color(0xFFD4B1A0)),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFFC98867),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF8BB56A),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Color(0xFF3F3F3F),
                        fontWeight: FontWeight.bold,
                      ),
                      todayTextStyle: TextStyle(
                        color: Color(0xFF3F3F3F),
                        fontWeight: FontWeight.bold,
                      ),
                      disabledTextStyle: TextStyle(color: Colors.grey),
                      outsideTextStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // ── Today's activity summary card ─────────────────────────────
            Consumer<ActivityViewModel>(
              builder: (context, vm, child) {
                final count = vm.getActivityCount(today);

                return Card(
                  color: const Color(0xFF665A48),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Activities",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEDE4E0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${today.day}/${today.month}/${today.year}",
                          style: const TextStyle(
                            color: Color(0xFFC8D3BE),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "$count ${count == 1 ? 'Activity' : 'Activities'}",   // ← live + pluralised
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEDE4E0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}