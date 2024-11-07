import 'package:flutter/material.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/Iconed Button.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: "SignUP",
              para: "Unlock exclusive events - sign up now!",
              image: MyImages.Signup1,
            ),
            MyTextBox(hint: "First Name"),
            MyTextBox(hint: "Last Name"),
            MyTextBox(hint: "Password"),
            MyTextBox(hint: "Confirm Password"),
            ColoredButton(
              text: "Continue",
            ),
            SizedBox(height: 10),
            Text(
              "Already a Member? Login",
              style: TextStyle(color: MyColors.Yellow),
            ),
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: MyDivider()),
            ),
            IconedButton(
              text: "Continue with Google",
              icon: MyIcons.google,
            ),
            IconedButton(
              text: "Continue with Facebook",
              icon: MyIcons.facebook,
            ),
          ],
        ),
      ),
    );
  }
}
