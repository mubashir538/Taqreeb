import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/Iconed Button.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/icons.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Header(
                heading: "SignUP",
                para: "Unlock exclusive events – sign up now!",
                image: "assets/your_image.svg",
              ),
              SizedBox(height: 20),
              MyTextBox(hint: "First Name"),
              SizedBox(height: 10),
              MyTextBox(hint: "Last Name"),
              SizedBox(height: 10),
              MyTextBox(hint: "Password"),
              SizedBox(height: 10),
              MyTextBox(hint: "Confirm Password"),
              SizedBox(height: 20),
              ColoredButton(
                text: "Continue",
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Already a Member? Login",
                  style: TextStyle(color: MyColors.Yellow),
                ),
              ),
              SizedBox(height: 20),
              IconedButton(
                text: "Continue with Google",
                icon: MyIcons.google,
              ),
              SizedBox(height: 10),
              IconedButton(
                text: "Continue with Facebook",
                icon: MyIcons.facebook,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
