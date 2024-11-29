import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class Signup_EmailOTPSend extends StatelessWidget {
  const Signup_EmailOTPSend({super.key});

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
                    para: 'Enter Email to send one time password',
                    image: MyImages.SingupPng,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  MyTextBox(
                    hint: 'Email',
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                    child: Center(child: MyDivider()),
                  ),
                  ColoredButton(
                    text: 'Send OTP',
                    onPressed: () {
                      Navigator.pushNamed(context, '/Signup_EmailOTPVerify');
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/Signup_ContactOTPSend');
                    },
                    child: Text(
                      'Use Contact to Verify Instead',
                      style: TextStyle(
                        color: MyColors.Yellow,
                        fontSize: MaximumThing * 0.015,
                      ),
                    ),
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
