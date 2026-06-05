import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';
import '../viewmodels/activity_view_model.dart';
import 'activity_details_screen.dart';
import 'add_activity_screen.dart';

class ActivityScreen extends StatefulWidget {
  final DateTime selectedDate;

  const ActivityScreen({super.key, required this.selectedDate});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool get isToday {
    final now = DateTime.now();

    return widget.selectedDate.year == now.year &&
        widget.selectedDate.month == now.month &&
        widget.selectedDate.day == now.day;
  }

  bool get canModify => isToday;

  Future<void> _navigateToAddActivity() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddActivityScreen(selectedDate: widget.selectedDate),
      ),
    );
  }

  Future<void> _deleteActivity(Activity activity) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF665A48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Delete Activity",
                style: TextStyle(
                  color: Color(0xFFEDE4E0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                "Are you sure you want to delete this activity?",
                style: TextStyle(color: Color(0xFFC8D3BE)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFFD4B1A0)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC98867),
                    foregroundColor: const Color(0xFF3F3F3F),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!shouldDelete) return;

    await context.read<ActivityViewModel>().deleteActivity(activity);
  }

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<ActivityViewModel>().getActivitiesByDate(
      widget.selectedDate,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF3F3F3F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3F3F3F),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDE4E0),
        ),
        title: Text(
          DateFormat('dd MMM yyyy').format(widget.selectedDate),
          style: const TextStyle(
            color: Color(0xFFEDE4E0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Date Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF665A48),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('EEEE').format(widget.selectedDate),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEDE4E0),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('dd MMMM yyyy').format(widget.selectedDate),
                    style: const TextStyle(
                      color: Color(0xFFC8D3BE),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            if (!canModify)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF93765A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Color(0xFFEDE4E0),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Archived Day (View Only)",
                      style: TextStyle(
                        color: Color(0xFFEDE4E0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            if (canModify)
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BB56A),
                    foregroundColor: const Color(0xFF3F3F3F),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _navigateToAddActivity,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Add Activity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            if (canModify) const SizedBox(height: 16),

            Expanded(
              child: activities.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF665A48),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          isToday
                              ? "No Activities Yet"
                              : "No Activities Recorded",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEDE4E0),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ActivityDetailsScreen(activity: activity),
                              ),
                            );
                          },
                          child: Card(
                            color: const Color(0xFF665A48),
                            margin: const EdgeInsets.only(bottom: 14),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEDE4E0),
                                    ),
                                  ),

                                  if (activity.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        activity.description,
                                        style: const TextStyle(
                                          color: Color(0xFFC8D3BE),
                                        ),
                                      ),
                                    ),

                                  if (activity.imagePaths.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: SizedBox(
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: activity.imagePaths.length,
                                          itemBuilder: (
                                            context,
                                            imageIndex,
                                          ) {
                                            return Container(
                                              width: 100,
                                              margin: const EdgeInsets.only(
                                                right: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                image: DecorationImage(
                                                  image: FileImage(
                                                    File(
                                                      activity.imagePaths[
                                                          imageIndex],
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                  if (canModify)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    AddActivityScreen(
                                                      selectedDate:
                                                          widget.selectedDate,
                                                      activity: activity,
                                                    ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color(0xFF8BB56A),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _deleteActivity(activity);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFC98867),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}