import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Iconed%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

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
        final compressedFile = await _compressImage(
            image == 'f' ? File(frontImage!.path) : File(backImage!.path));
        setState(() {
          if (image == 'f') frontImage = compressedFile;
          if (image == 'b') backImage = compressedFile;
        });
      }
    } catch (e) {
      warningDialog(
              title: 'Error',
              message: 'Failed to pick an image. Please try again.')
          .showDialogBox(context);
    }
  }

  Future<File> _compressImage(File file) async {
    final compressedPath = file.path.replaceFirst('.jpg', '_compressed.jpg');
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      compressedPath,
      quality: 50,
    );
    return compressedFile ?? file;
  }

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: (screenHeight * 0.02) + _headerHeight),
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  child: Column(
                    children: [
                      frontImage != null
                          ? Image.file(
                              frontImage!,
                              width: screenWidth * 0.5,
                              height: screenWidth * 0.5,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              MyImages.Cnic,
                              height: screenHeight * 0.2,
                              fit: BoxFit.contain,
                            ),
                      GestureDetector(
                        onTap: () => _pickImage('f'),
                        child: IconedButton(
                          icon: MyIcons.upload2,
                          text: 'Upload Front',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Column(
                    children: [
                      backImage != null
                          ? Image.file(
                              backImage!,
                              width: screenWidth * 0.5,
                              height: screenWidth * 0.5,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              MyImages.Cnic,
                              height: screenHeight * 0.2,
                              fit: BoxFit.contain,
                            ),
                      GestureDetector(
                        onTap: () => _pickImage('b'),
                        child: IconedButton(
                          icon: MyIcons.upload2,
                          text: 'Upload Back',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                MyDivider(),
                SizedBox(height: screenHeight * 0.02),
                ColoredButton(
                  onPressed: () {
                    if (frontImage == null || backImage == null) {
                      warningDialog(
                        message:
                            'Please upload both front and back of your CNIC',
                        title: 'Invalid Details',
                      ).showDialogBox(context);
                    } else {
                      MyStorage.saveToken(frontImage!.path, 'bsfront');
                      MyStorage.saveToken(backImage!.path, 'bsback');
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
