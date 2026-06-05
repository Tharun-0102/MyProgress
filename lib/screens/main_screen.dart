import 'package:day_activity_tracker/screens/goals/goal_screen.dart';
import 'package:flutter/material.dart';

import 'Home/home_screen.dart';
import 'statistics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final pages = const [HomeScreen(), StatisticsScreen(), GoalScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F3F3F),

      body: pages[selectedIndex],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            backgroundColor: const Color(0xFF665A48),

            indicatorColor: const Color(0xFF8BB56A),

            selectedIndex: selectedIndex,

            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },

            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: selectedIndex == 0
                      ? const Color(0xFF3F3F3F)
                      : const Color(0xFFC8D3BE),
                ),
                label: 'Calendar',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: selectedIndex == 1
                      ? const Color(0xFF3F3F3F)
                      : const Color(0xFFC8D3BE),
                ),
                label: 'Statistics',
              ),

              NavigationDestination(
                icon: Icon(Icons.flag_rounded,
                color: selectedIndex == 1
                      ? const Color(0xFF3F3F3F)
                      : const Color(0xFFC8D3BE),),
                label: 'Goals',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
