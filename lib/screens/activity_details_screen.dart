import 'dart:io';

import 'package:flutter/material.dart';

import '../models/activity_model.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final Activity activity;

  const ActivityDetailsScreen({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F3F3F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3F3F3F),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDE4E0),
        ),
        title: const Text(
          "Activity Details",
          style: TextStyle(
            color: Color(0xFFEDE4E0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF665A48),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEDE4E0),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF665A48),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8BB56A),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    activity.description.isEmpty
                        ? "No Description"
                        : activity.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFFEDE4E0),
                    ),
                  ),
                ],
              ),
            ),

            if (activity.imagePaths.isNotEmpty) ...[
              const SizedBox(height: 25),

              const Text(
                "Photos",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEDE4E0),
                ),
              ),

              const SizedBox(height: 15),

              ...activity.imagePaths.map(
                (path) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(
                        File(path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}