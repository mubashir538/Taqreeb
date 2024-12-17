import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';

class CreateGuestList_AddFamily extends StatelessWidget {
  const CreateGuestList_AddFamily({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double MaximumThing =
    //     screenWidth > screenHeight ? screenWidth : screenHeight;

    TextEditingController familynamecontroller = TextEditingController();
    TextEditingController memberscontroller = TextEditingController();
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
            MyTextBox(hint: 'Family Name',valueController: familynamecontroller,),
            MyTextBox(hint: 'Members',valueController: memberscontroller,),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            ColoredButton(
              text: 'Add Family',
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
