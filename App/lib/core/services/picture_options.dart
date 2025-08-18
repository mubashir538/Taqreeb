import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';

class Picture {
  static Future<void> pickImage(
    BuildContext context, {
    required Function(File compressedFile) callback,
  }) async {
    try {
      // 1. Pick image from gallery
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      // 2. Immediately crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors(context).red,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        // 3. Compress and return the file
        final compressedFile = await compressImage(File(croppedFile.path));
        callback(compressedFile);
      }
    } catch (e) {
      unawaited(MyApi.postRequest(
          context: context,
          endpoint: 'error/application',
          body: {'error': 'Image processing error: $e'}));
      MyScaffold(text: 'Failed to process image. Please try again.')
          .show(context);
    }
  }

  static Future<List<File>> pickMultipleImages(
    BuildContext context, {
    int maxImages = 10,
  }) async {
    try {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 90,
      );

      if (pickedFiles.isEmpty) return [];

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final List<File> processedImages = [];

      for (final pickedFile in pickedFiles) {
        try {
          // Skip cropping, just compress the original image
          final compressedFile = await compressImage(File(pickedFile.path));
          processedImages.add(compressedFile);
        } catch (e) {
          unawaited(MyApi.postRequest(
              context: context,
              endpoint: 'error/application',
              body: {
                'error': 'Error processing image ${pickedFile.path}: $e'
              }));
          processedImages.add(File(pickedFile.path));
        }
      }

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      return processedImages;
    } catch (e) {
      unawaited(MyApi.postRequest(
          context: context,
          endpoint: 'error/application',
          body: {'error': 'Multiple image processing error: $e'}));
      if (context.mounted) {
        MyScaffold(text: 'Failed to process images. Please try again.')
            .show(context);
      }
      return [];
    }
  }

  static Future<File> saveCroppedImage(Uint8List croppedBytes) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/cropped_image.png';
    final croppedFile = File(path);
    await croppedFile.writeAsBytes(croppedBytes);
    return croppedFile;
  }

  static Future<File> compressImage(File file) async {
    final originalPath = file.path;
    final compressedPath =
        originalPath.replaceFirst(RegExp(r'\.\w+$'), '_compressed.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      originalPath,
      compressedPath,
      quality: 50,
    );

    if (result != null) {
      final fcompressedFile = File(result.path);
      return fcompressedFile;
    } else {
      throw Exception('Image compression failed.');
    }
  }
}
