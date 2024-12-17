import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';

class AddcategoryAddaddons extends StatelessWidget {
  const AddcategoryAddaddons({super.key});

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
              heading: 'Add AddOns',
            ),
            SizedBox(height: screenHeight * 0.03),
            MyTextBox(hint: 'Name'),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(hint: 'Price'),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(hint: 'Per Head'),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(hint: 'Head Type'),
          ],
        ),
      ),
    );
  }
}
