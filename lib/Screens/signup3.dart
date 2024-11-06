import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';

class OTPScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Header(
                heading: 'OTP Verification',
                image: 'assets/images/signuppng.svg',
              ),
              SizedBox(height: 20),
              Text(
                'Enter Email address to send one time password',
                style: TextStyle(
                  color: MyColors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
              MyTextBox(
                hint: 'Email',
              ),
              SizedBox(height: 10),
              MyDivider(),
              ColoredButton(
                text: 'Send OTP',
              ),
              SizedBox(height: 20),
              Text(
                'Skip for Later',
                style: TextStyle(
                  color: MyColors.Yellow,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
              ProgressBar(
                Progress: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
