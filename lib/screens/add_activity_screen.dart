import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../viewmodels/activity_view_model.dart';
import '../models/activity_model.dart';
import '../services/image_service.dart';

class AddActivityScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Activity? activity;

  const AddActivityScreen({
    super.key,
    required this.selectedDate,
    this.activity,
  });

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  List<File> selectedImages = [];

  bool hasChanges = false;

  bool get isEditMode => widget.activity != null;

  @override
  void initState() {
    super.initState();

    if (widget.activity != null) {
      titleController.text = widget.activity!.title;

      descriptionController.text = widget.activity!.description;

      selectedImages = widget.activity!.imagePaths
          .map((path) => File(path))
          .toList();
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          selectedImages.add(File(image.path));
          hasChanges = true;
        });
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);

      if (images.isNotEmpty) {
        setState(() {
          selectedImages.addAll(images.map((image) => File(image.path)));

          hasChanges = true;
        });
      }
    } catch (e) {
      debugPrint("Gallery Error: $e");
    }
  }

  Future<void> showImageOptions() async {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF665A48),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                iconColor: const Color(0xFF8BB56A),
                textColor: const Color(0xFFEDE4E0),
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  await takePhoto();
                },
              ),
              ListTile(
                iconColor: const Color(0xFFC98867),
                textColor: const Color(0xFFEDE4E0),
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImages();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _showDiscardDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF665A48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                "Discard Changes?",
                style: TextStyle(
                  color: Color(0xFFEDE4E0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                "You have unsaved changes. Are you sure you want to leave?",
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Discard"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _handleBack() async {
    if (!hasChanges) {
      Navigator.pop(context);
      return;
    }

    final discard = await _showDiscardDialog();

    if (discard) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await _handleBack();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF3F3F3F),

        appBar: AppBar(
          backgroundColor: const Color(0xFF3F3F3F),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFFEDE4E0)),
          title: Text(
            isEditMode ? "Edit Activity" : "Add Activity",
            style: const TextStyle(
              color: Color(0xFFEDE4E0),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Color(0xFFEDE4E0)),
                  onChanged: (_) {
                    setState(() {
                      hasChanges = true;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Activity Title",
                    labelStyle: const TextStyle(color: Color(0xFFC8D3BE)),
                    filled: true,
                    fillColor: const Color(0xFF665A48),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFF93765A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: Color(0xFF8BB56A),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  style: const TextStyle(color: Color(0xFFEDE4E0)),
                  onChanged: (_) {
                    setState(() {
                      hasChanges = true;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Description (Optional)",
                    alignLabelWithHint: true,
                    labelStyle: const TextStyle(color: Color(0xFFC8D3BE)),
                    filled: true,
                    fillColor: const Color(0xFF665A48),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFF93765A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: Color(0xFF8BB56A),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFF665A48),
                      side: const BorderSide(color: Color(0xFF8BB56A)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: showImageOptions,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Color(0xFF8BB56A),
                    ),
                    label: const Text(
                      "Add Photos",
                      style: TextStyle(
                        color: Color(0xFFEDE4E0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (selectedImages.isNotEmpty)
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                image: DecorationImage(
                                  image: FileImage(selectedImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 14,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFC98867),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Color(0xFFEDE4E0),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BB56A),
                      foregroundColor: const Color(0xFF3F3F3F),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFFC98867),
                            content: Text("Please enter activity title"),
                          ),
                        );
                        return;
                      }

                      try {
                        List<String> savedPaths = [];

                        for (final image in selectedImages) {
                          if (image.path.contains('activity_images')) {
                            savedPaths.add(image.path);
                          } else {
                            final savedPath = await ImageService.saveImage(
                              image,
                            );

                            savedPaths.add(savedPath);
                          }
                        }
                        if (isEditMode) {
                          await context
                              .read<ActivityViewModel>()
                              .updateActivity(
                                widget.activity!,
                                titleController.text.trim(),
                                descriptionController.text.trim(),
                                savedPaths,
                              );
                        } else {
                          await context.read<ActivityViewModel>().addActivity(
                            Activity(
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              activityDate: widget.selectedDate,
                              imagePaths: savedPaths,
                            ),
                          );
                        }

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF8BB56A),
                            content: Text(
                              isEditMode
                                  ? "Activity Updated"
                                  : "Activity Saved",
                              style: const TextStyle(
                                color: Color(0xFF3F3F3F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );

                        Navigator.pop(context, true);
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFFC98867),
                            content: Text("Error: $e"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      isEditMode ? "Update Activity" : "Save Activity",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
