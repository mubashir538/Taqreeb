import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class BusinessSignup2 extends StatelessWidget {
  const BusinessSignup2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.black, // Set background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                heading: 'Upload your ID Card for Verification',
                para: 'Uploading your ID card ensures secure identity verification for your account.',
              ),
              const SizedBox(height: 20),

              // Front Image and TextBox
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Image.asset("assets/images/CNIC.png", 
                      width: 150, 
                      height: 150,
                      // fit: BoxFit.contain,
                    ),
                    MyTextBox(
                      hint: 'Upload Front',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Back Image and TextBox
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    SvgPicture.asset("images/cnic.svg", 
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    MyTextBox(
                      hint: 'Upload Back',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Divider to separate sections
              MyDivider(width: screenWidth * 0.8),
              const SizedBox(height: 20),

              // Continue Button
              ColoredButton(
                text: 'Continue',
                height: screenHeight * 0.09,
                width: screenWidth * 0.3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
