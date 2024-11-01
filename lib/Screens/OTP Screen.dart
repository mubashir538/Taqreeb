import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
//import 'package:taqreeb/Components/textBox.dart';
import 'package:taqreeb/theme/color.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({Key? key}) : super(key: key);

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), 
        child: Header(
          heading: 'OTP Verification',
          para: 'Enter Phone number to send one-time password',
          image: '', 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            
            // Text box 
            //TextBox(controller: phoneController),

            SizedBox(height: 20),
            
            // Colored button
            ColoredButton(text: 'Send OTP'),
            
            SizedBox(height: 10),
            
            // Text
            GestureDetector(
              onTap: () {
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
           // ProgressBar(), //Iska code ni h
            //SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

