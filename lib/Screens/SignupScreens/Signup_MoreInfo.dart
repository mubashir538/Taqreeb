import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class Signup_MoreInfo extends StatelessWidget {
  const Signup_MoreInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double MaximumThing =
    //     screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Header(
                  heading: 'OTP Verification',
                  para: 'Unlock exclusive events - sign up now!',
                  image: MyImages.Signup1,
                ),
                SizedBox(height: screenHeight * 0.01),
                MyTextBox(
                  hint: 'City',
                ),
                MyTextBox(
                  hint: 'Gender',
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.pushNamed(context, '/ProfilePictureUpload');
                  },
                ),
              ]),
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
