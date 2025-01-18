import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController phoneController = TextEditingController();
  FocusNode phoneFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Header(
          heading: 'OTP Verification',
          para: 'Enter Phone number to send one time password',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            MyTextBox(
              focusNode: phoneFocus,
              onFieldSubmitted: (_) {
                phoneFocus.unfocus();
              },
              hint: 'Enter your phone number',
              isNum: true,
              valueController: phoneController,
            ),
            SizedBox(height: 20),
            ColoredButton(text: 'Send OTP'),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Skip for Later',
                style: TextStyle(
                  color: MyColors.Yellow,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Spacer(),
            ProgressBar(
              Progress: 4,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
