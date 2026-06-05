import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ImageService {
  static Future<String> saveImage(
    File image,
  ) async {
    final directory =
        await getApplicationDocumentsDirectory();

    final imageDirectory = Directory(
      '${directory.path}/activity_images',
    );

    if (!await imageDirectory.exists()) {
      await imageDirectory.create(
        recursive: true,
      );
    }

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedImage =
        await image.copy(
      '${imageDirectory.path}/$fileName',
    );

    return savedImage.path;
  }
}