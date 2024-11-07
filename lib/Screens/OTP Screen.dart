import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart'; 
import 'package:taqreeb/theme/color.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // Set the background color to match your design
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Adjust height as needed
        child: Header(
          heading: 'OTP Verification',
          para: 'Enter Phone number to send one time password',
          image: '', // Add an image path if you need to display one
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // Use MyTextBox instead of TextBox
            MyTextBox(hint: 'Enter your phone number'),

            SizedBox(height: 20),

            // Colored button for sending OTP
            ColoredButton(text: 'Send OTP'),

            SizedBox(height: 10),

            // "Skip for Later" text
            GestureDetector(
              onTap: () {
                // Handle skip action
              },
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

            // Progress bar
            ProgressBar(
              Progress: 4,
            ), // A simple example of a progress bar component

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
