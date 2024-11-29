import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';

class CreateGuestList_AddPerson extends StatelessWidget {
  const CreateGuestList_AddPerson({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double MaximumThing =
    //     screenWidth > screenHeight ? screenWidth : screenHeight;

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
              onPressed: () {
                Navigator.pushNamed(context, '/CreateGuestList_List');
              },
            ),
            BorderButton(text: 'Done', width: screenWidth * 0.7)
          ],
        ),
      ),
    );
  }
}
