import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class ForgotPassword_EmailorPhoneInput extends StatelessWidget {
  const ForgotPassword_EmailorPhoneInput({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Forgot Password',
              para:
                  'Enter the email address with your account  and we’ll send an email with confirmation to restetyour password',
              image: MyImages.ForgotPassword,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child: MyTextBox(hint: "Enter Email/Phone Number"),
            ),
            SizedBox(
              height: screenHeight * 0.05,
              child: Center(child: MyDivider()),
            ),
            ColoredButton(
              text: "Send Code",
              onPressed: () {
                Navigator.pushNamed(context, '/ForgotPassword_VerifyCode');
              },
            )
          ],
        ),
      ),
    );
  }
}
