import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/description.dart';

import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';

class BusinessSignup_Description extends StatefulWidget {
  const BusinessSignup_Description({super.key});

  @override
  State<BusinessSignup_Description> createState() =>
      _BusinessSignup_DescriptionState();
}

class _BusinessSignup_DescriptionState
    extends State<BusinessSignup_Description> {
  int charactersLeft = 1100;
  TextEditingController descriptionController = TextEditingController();

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: screenWidth,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: _headerHeight,
                          ),
                          DescriptionBox(
                              valueController: descriptionController,
                              onChanged: (value) {
                                setState(() {
                                  charactersLeft = 1100 - value.length;
                                });
                              }),
                          SizedBox(
                            width: screenWidth * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${charactersLeft.toString()} characters left",
                                  style: GoogleFonts.montserrat(
                                    color: MyColors.white,
                                    fontSize: MaximumThing * 0.018,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                            child: MyDivider(),
                          ),
                          ColoredButton(
                              text: "Continue",
                              onPressed: () {
                                MyStorage.saveToken(descriptionController.text,
                                    'bsdescription');
                                Navigator.pushNamed(
                                    context, '/ProfilePictureUpload',
                                    arguments: {'type': 'Business'});
                              })
                        ],
                      )
                    ]),
              ),
            ),
            Positioned(
              top: 0,
              child: Header(
                  key: _headerKey,
                  heading: "Create a Description",
                  para: 'Your Description Creates a Great Impact on the\n'
                      'customers and can help your get more clients '),
            ),
          ],
        ));
  }
}
