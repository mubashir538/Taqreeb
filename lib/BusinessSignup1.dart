import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/images.dart';
//import 'package:taqreeb/Components/textbox.dart'; 

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController cnicController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

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
                heading: 'Sign Up',
                para: 'Unlock Success with Just One Click - Join Our Community Today!',
                image: MyImages.BusinessSignup, 
              ),

              SizedBox(height: 20), // Spacing between header and text fields

              // TextBoxes
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  children: [
                    TextBox(controller: cnicController),
                    SizedBox(height: 10),
                    TextBox(controller: cityController),
                    SizedBox(height: 10),
                    TextBox(controller: categoryController),
                    SizedBox(height: 10),
                    TextBox(controller: usernameController),
                  ],
                ),
              ),

              SizedBox(height: 30), // Spacing between text fields and divider

              // Divider bar
              Divider(
                color: Colors.grey, 
                thickness: 1.5, 
                indent: screenWidth * 0.1, 
                endIndent: screenWidth * 0.1, 
              ),

              SizedBox(height: 30), // Spacing between divider and button

              //Colored Button
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
