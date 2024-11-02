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

    return Scaffold(
      backgroundColor: MyColors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: 'Sign Up',
              para:
                  'Unlock Success with Just One Click - Join Our Community Today!',
              image: MyImages.BusinessSignup,
            ),
            const SizedBox(height: 20),

            //TextBoxes
            MyTextBox(hint: 'CNIC'),
            MyTextBox(hint: 'City'),
            MyTextBox(
              hint: 'Category',
            ),
            MyTextBox(hint: 'Username'),

            // Divider
            MyDivider(width: screenWidth * 0.8),

            const SizedBox(height: 20),

            // Continue Button
            ColoredButton(
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
