import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taqreeb/Components/Buttons/c_icon_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/crop_dialog.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';
import 'package:taqreeb/core/utils/images.dart';

class BusinessSignup_CNICUpload extends StatefulWidget {
  const BusinessSignup_CNICUpload({super.key});

  @override
  State<BusinessSignup_CNICUpload> createState() =>
      _BusinessSignup_CNICUploadState();
}

class _BusinessSignup_CNICUploadState extends State<BusinessSignup_CNICUpload> {
  File? frontImage;
  File? backImage;

  Future<void> _pickImage(image) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await File(pickedFile.path).readAsBytes();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CropPopup(
              imageBytes: imageBytes,
              onCropped: (croppedBytes) async {
                final croppedFile = await _saveCroppedImage(croppedBytes);
                final compressedFile = await _compressImage(croppedFile);
                setState(() {
                  if (image == 'f') {
                    frontImage = compressedFile;
                  } else {
                    backImage = compressedFile;
                  }
                });
              },
            );
          },
        );
      }
    } catch (e) {
      warningDialog(
        title: 'Error',
        message: 'Failed to pick or crop the image. Please try again.',
      ).showDialogBox(context);
    }
  }

  Future<File> _saveCroppedImage(Uint8List croppedBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/cropped_image.png';
    final croppedFile = File(path);
    await croppedFile.writeAsBytes(croppedBytes);
    return croppedFile;
  }

  Future<File> _compressImage(File file) async {
    try {
      final tempDir = Directory.systemTemp;
      final compressedPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        compressedPath,
        quality: 50,
      );

      if (compressedFile != null) {
        final FcompressedFile = File(compressedFile.path);
        return FcompressedFile;
      } else {
        throw Exception("Failed to compress image.");
      }
    } catch (e) {
      throw Exception("Compression error: ${e.toString()}");
    }
  }

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: (Screen.height(context) * 0.02) + _headerHeight),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Screen.height(context) * 0.02),
                  child: Column(
                    children: [
                      frontImage != null
                          ? Image.file(
                              frontImage!,
                              width: Screen.width(context) * 0.5,
                              height: Screen.width(context) * 0.5,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              MyImages.Cnic,
                              height: Screen.height(context) * 0.2,
                              fit: BoxFit.contain,
                            ),
                      IconedButton(
                        onPressed: () => _pickImage('f'),
                        icon: MyIcons.upload2,
                        text: 'Upload Front',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Screen.height(context) * 0.01),
                  child: Column(
                    children: [
                      backImage != null
                          ? Image.file(
                              backImage!,
                              width: Screen.width(context) * 0.5,
                              height: Screen.width(context) * 0.5,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              MyImages.Cnic,
                              height: Screen.height(context) * 0.2,
                              fit: BoxFit.contain,
                            ),
                      IconedButton(
                        onPressed: () => _pickImage('b'),
                        icon: MyIcons.upload2,
                        text: 'Upload Back',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.03),
                MyDivider(),
                SizedBox(height: Screen.height(context) * 0.02),
                ColoredButton(
                  onPressed: () {
                    if (frontImage == null || backImage == null) {
                      warningDialog(
                        message:
                            'Please upload both front and back of your CNIC',
                        title: 'Invalid Details',
                      ).showDialogBox(context);
                    } else {
                      MyStorage.saveToken(frontImage!.path, MyTokens.bsfront);
                      MyStorage.saveToken(backImage!.path, MyTokens.bsback);
                      Navigator.pushNamed(
                          context, '/BusinessSignup_Description');
                    }
                  },
                  text: 'Continue',
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Upload your ID Card for Verification',
              para:
                  'Uploading your ID card ensures secure identity verification for your account.',
            ),
          ),
        ],
      ),
    );
  }
}
