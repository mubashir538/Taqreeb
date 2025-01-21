import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
    Icons.color_lens,
    Icons.image,
    Icons.draw
  ];

  XFile? selectedImage;
  List<TextData> addedTexts = []; // List to store multiple texts
  bool isDrawingMode = false;

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
    Color selectedColor = Colors.black;
    double fontSize = 24.0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Text'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Enter your text'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Color:'),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      Color? color = await showDialog<Color>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Select Color'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: selectedColor,
                                onColorChanged: (color) {
                                  Navigator.pop(context, color);
                                },
                              ),
                            ),
                          );
                        },
                      );
                      if (color != null) {
                        setState(() {
                          selectedColor = color;
                        });
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Font Size:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: Slider(
                      min: 12.0,
                      max: 48.0,
                      value: fontSize,
                      onChanged: (value) {
                        setState(() {
                          fontSize = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
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
                  addedTexts.add(TextData(
                    text: textController.text,
                    color: selectedColor,
                    fontSize: fontSize,
                    position: Offset(100, 100),
                  ));
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

  Future<void> _saveCard() async {
    try {
      final boundary = _globalKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/invitation_card.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // Share the saved image via WhatsApp
      await Share.shareXFiles([XFile(filePath)],
          text: 'Check out my invitation card!');
    } catch (e) {
      print('Error saving card: $e');
    }
  }

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        child: Column(
          children: [
            Header(
              icon: Icons.menu,
              heading: 'Design Card',
            ),
            Expanded(
              child: RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color: MyColors.white,
                  width: screenWidth,
                  height: screenHeight * 0.6,
                  child: Stack(
                    children: [
                      if (selectedImage != null)
                        Positioned.fill(
                          child: Image.file(
                            File(selectedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      for (final textData in addedTexts)
                        Positioned(
                          left: textData.position.dx,
                          top: textData.position.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                textData.position += details.delta;
                              });
                            },
                            child: Text(
                              textData.text,
                              style: TextStyle(
                                fontSize: textData.fontSize,
                                color: textData.color,
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
                          // Add color editing functionality if needed
                        } else if (i == 2) {
                          _pickImage();
                        } else if (i == 3) {
                          setState(() {
                            isDrawingMode = !isDrawingMode;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
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
              onPressed: _saveCard,
            ),
          ],
        ),
      ),
    );
  }
}

class TextData {
  String text;
  Color color;
  double fontSize;
  Offset position;

  TextData({
    required this.text,
    required this.color,
    required this.fontSize,
    required this.position,
  });
}
