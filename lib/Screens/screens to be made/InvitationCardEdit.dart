import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

class InvitationCardEdit extends StatefulWidget {
  const InvitationCardEdit({super.key});

  @override
  State<InvitationCardEdit> createState() => _InvitationCardEditState();
}

class _InvitationCardEditState extends State<InvitationCardEdit> {
  List<IconData> editIcons = [
    Icons.text_fields,
    Icons.crop,
    Icons.image,
    Icons.draw
  ];

  XFile? selectedImage; // For storing the selected image
  String? addedText; // For storing the text added by the user
  bool isDrawingMode = false; // To enable/disable drawing mode

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void _addText() async {
    final TextEditingController textController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Text'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: 'Enter your text'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  addedText = textController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _enableDrawing() {
    setState(() {
      isDrawingMode = !isDrawingMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      body: Container(
        width: screenWidth,
        child: Column(
          children: [
            Header(
              icon: Icons.menu,
              heading: 'Design Card',
            ),
            Container(
              height: screenHeight * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    color: MyColors.white,
                    width: screenWidth,
                    height: screenHeight * 0.5,
                    child: Stack(
                      children: [
                        if (selectedImage != null)
                          Positioned.fill(
                            child: Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (addedText != null)
                          Center(
                            child: Text(
                              addedText!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        if (isDrawingMode)
                          Positioned.fill(
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                // Drawing logic can be implemented here
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenWidth * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 0; i < editIcons.length; i++)
                          GestureDetector(
                            onTap: () {
                              if (i == 0) {
                                _addText();
                              } else if (i == 1) {
                                // Add cropping functionality here
                              } else if (i == 2) {
                                _pickImage();
                              } else if (i == 3) {
                                _enableDrawing();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: maximumThing * 0.02),
                              width: screenWidth * 0.15,
                              height: screenWidth * 0.15,
                              decoration: BoxDecoration(
                                color: MyColors.DarkLighter,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                editIcons[i],
                                color: MyColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ColoredButton(
                    text: 'Save Card',
                    width: screenWidth * 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
