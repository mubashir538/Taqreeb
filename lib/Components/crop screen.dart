import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropPopup extends StatelessWidget {
  final Uint8List imageBytes;
  final Function(Uint8List croppedBytes) onCropped;

  CropPopup({required this.imageBytes, required this.onCropped});

  @override
  Widget build(BuildContext context) {
    final CropController _cropController = CropController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Expanded(
              child: Crop(
                image: imageBytes,
                controller: _cropController,
                onCropped: (CropResult result) {
                  Uint8List croppedBytes = (result as CropSuccess).croppedImage;
                  Navigator.of(context).pop();
                  onCropped(croppedBytes);
                },
                withCircleUi: false, 
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                   
                    _cropController.crop();
                  },
                  child: const Text('Crop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
