import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';

import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';

import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class CreateGuestList3 extends StatelessWidget {
  const CreateGuestList3({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Guest List',
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            MyTextBox(hint: 'Person Name'),
            MyTextBox(hint: 'Contact Number'),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            ColoredButton(
              text: 'Add Person',
              width: screenWidth * 0.7,
            ),
            BorderButton(text: 'Done', width: screenWidth * 0.7)
          ],
        ),
      ),
    );
  }
}
