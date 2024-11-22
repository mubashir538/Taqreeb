import 'package:flutter/material.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';

class OTPScreen2 extends StatelessWidget {
  const OTPScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Header(
                    heading: 'OTP Verification',
                    para:
                        'We have sent 4 digits verification code to your number, Please Check your Number',
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  OTPBoxes(),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Send Code Again 00:59',
                    style: TextStyle(
                      color: MyColors.white,
                      fontSize: MaximumThing * 0.02,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                    child: Center(child: MyDivider()),
                  ),
                  ColoredButton(
                    text: 'Verification',
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup3');
                    },
                  ),
                ],
              ),
              ProgressBar(
                Progress: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
