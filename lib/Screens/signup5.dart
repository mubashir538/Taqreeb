import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';

class OTPScreen5 extends StatelessWidget {
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
                para: 'Unlock exclusive events – sign up now!',
                image: 'assets/images/signuppng.svg',
              ),
              SizedBox(height: 20),
              MyTextBox(
                hint: 'City',
              ),
              SizedBox(height: 10),
              MyTextBox(
                hint: 'Gender',
              ),
              SizedBox(height: 10),
              MyDivider(),
              ColoredButton(
                text: 'Continue',
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
