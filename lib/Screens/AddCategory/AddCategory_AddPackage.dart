import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';

class AddcategoryAddpackage extends StatelessWidget {
  const AddcategoryAddpackage({super.key});

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
              heading: 'Add Packages',
            ),
            SizedBox(height: screenHeight * 0.03),
            MyTextBox(hint: 'Name'),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(hint: 'Details'),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(hint: 'Price'),
          ],
        ),
      ),
    );
  }
}
