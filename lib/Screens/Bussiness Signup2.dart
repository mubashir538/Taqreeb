import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Iconed%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class BusinessSignup2 extends StatelessWidget {
  const BusinessSignup2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.black, // Set background color
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: 'Upload your ID Card for Verification',
              para:
                  'Uploading your ID card ensures secure identity verification for your account.',
            ),
            SizedBox(height: screenHeight * 0.02),

            // Front Image and TextBox
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              child: Column(
                children: [
                  Image.asset(
                    MyImages.Cnic,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
                  IconedButton(
                    icon: MyIcons.upload2,
                    text: 'Upload Back',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Back Image and TextBox
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: Column(
                children: [
                  Image.asset(
                    MyImages.Cnic,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
                  IconedButton(
                    icon: MyIcons.upload2,
                    text: 'Upload Back',
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Divider to separate sections
            MyDivider(),
            SizedBox(height: screenHeight * 0.02),

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
