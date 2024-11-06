import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';

class OTPScreen extends StatelessWidget {
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
                para: 'Enter Phone number to send one time password',
                image: 'assets/images/signuppng.svg',
              ),
              SizedBox(height: 20),
              MyTextBox(
                hint: 'Contact Number',
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
                Progress: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
