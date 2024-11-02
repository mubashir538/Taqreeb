import 'package:flutter/material.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';

class OTPScreen4 extends StatelessWidget {
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
                para: 'We have sent 4 digits verification code to your email',
              ),
              SizedBox(height: 20),
              OTPBoxes(),
              SizedBox(height: 20),
              Text(
                'Send Code Again 00:59',
                style: TextStyle(
                  color: MyColors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 20),
              MyDivider(),
              SizedBox(height: 20),
              ColoredButton(
                text: 'Verification',
              ),
              SizedBox(height: 20),
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
