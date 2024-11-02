import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class BusinessSignup1 extends StatelessWidget {
  const BusinessSignup1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.black, 
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: 'Sign Up',
              para: 'Unlock Success with Just One Click - Join Our Community Today!',
              image: MyImages.BusinessSignup, 
            ),
            const SizedBox(height: 20),

            //TextBoxes
            MyTextBox(hint: 'CNIC'),
            const SizedBox(height: 25),
            MyTextBox(hint: 'City'),
            const SizedBox(height: 25),
            MyTextBox(hint: 'Category', ),
            const SizedBox(height: 25),
            MyTextBox(hint: 'Username'),
            const SizedBox(height: 25),

            // Divider
            MyDivider(width: screenWidth * 0.8),

            const SizedBox(height: 20),

            // Continue Button
            ColoredButton(
              text: 'Continue',
              height: screenHeight * 0.09,
              width: screenWidth * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
