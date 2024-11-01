import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/images.dart';
//import 'package:taqreeb/Components/textbox.dart'; 

class BusinessSignup2 extends StatelessWidget {
  BusinessSignup2({Key? key}) : super(key: key);

  final TextEditingController frontIDController = TextEditingController();
  final TextEditingController backIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, 
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                heading: 'Upload your ID Card for Verification',
                para:
                    'Uploading your ID card ensures secure identity verification for your account.',
              ),

              SizedBox(height: 20), 

              // Front ID 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  children: [
                    // Placeholder for ID front image
                    Image(image: MyImages.Cnic, 
                      height: 100,
                    ),
                    SizedBox(height: 10),

                    // Upload front
                    TextBox(controller: frontIDController),
                    Text(
                      'Upload Front',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20), 

              // Back ID 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  children: [
                    // Placeholder for ID back image
                    Image(image: MyImages.Cnic, 
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    
                    // Upload back 
                    TextBox(controller: backIDController),
                    Text(
                      'Upload Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20), 

              // Divider bar
              Divider(
                color: Colors.grey, 
                thickness: 1.5, 
                indent: screenWidth * 0.1, 
                endIndent: screenWidth * 0.1, 
              ),

              SizedBox(height: 20), 

              // Colored button
              ColoredButton(
                text: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
