import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class ForgotPassword_VerifyCode extends StatelessWidget {
  const ForgotPassword_VerifyCode({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: 'Verify Code',
              para: 'We have send the code to abc@gmail.com',
            ),
            Container(
                margin: EdgeInsets.only(
                    top: MaximumThing * 0.07, bottom: MaximumThing * 0.02),
                child: OTPBoxes(
                  onChanged: (value) {},
                )),
            Text(
              'Send Code Again 00:59',
              style: TextStyle(
                color: MyColors.white,
                fontSize: MaximumThing * 0.015,
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
                Navigator.pushNamed(context, '/ForgotPassword_NewPassword');
              },
            ),
          ],
        ),
      ),
    );
  }
}
