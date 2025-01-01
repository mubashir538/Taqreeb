import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/validations.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';

class ForgotPassword_NewPassword extends StatefulWidget {
  const ForgotPassword_NewPassword({super.key});

  @override
  State<ForgotPassword_NewPassword> createState() =>
      _ForgotPassword_NewPasswordState();
}

class _ForgotPassword_NewPasswordState
    extends State<ForgotPassword_NewPassword> {
  String? email = '';
  String password = '';

  bool hasMinLength = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() => _validatePassword());
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      password = passwordController.text;
      hasMinLength = password.length >= 8;
      hasNumber = RegExp(r'\d').hasMatch(password);
      hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    email = args['email'].toString();

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: "Create New Password",
              para:
                  "This password should be different from the previous password",
            ),
            Container(
              margin: EdgeInsets.only(top: MaximumThing * 0.05),
              child: Column(
                children: [
                  MyTextBox(
                    hint: 'New Password',
                    isPassword: true,
                    valueController: passwordController,
                  ),
                  MyTextBox(
                    hint: 'Confirm Password',
                    valueController: confirmpasswordController,
                    isPassword: true,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                    width: screenWidth * 0.9,
                    child: Column(
                      children: [
                        _buildRuleRow(
                          "At least 8 characters",
                          hasMinLength,
                          MaximumThing,
                        ),
                        _buildRuleRow(
                          "At least 1 number",
                          hasNumber,
                          MaximumThing,
                        ),
                        _buildRuleRow(
                          "At least one special character",
                          hasSpecialChar,
                          MaximumThing,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: MyDivider()),
            ),
            ColoredButton(
              text: "Reset Password",
              onPressed: () async {
                if (passwordController.text != confirmpasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Passwords do not match.'),
                  ));
                  return;
                }
                if (!hasMinLength || !hasNumber || !hasSpecialChar) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Password does not meet the requirements.'),
                  ));
                  return;
                }
                final response = await MyApi.postRequest(
                    endpoint: 'user/forgotpassword/reset-password/',
                    body: {
                      'contact': email,
                      'password': passwordController.text
                    });
        
                if (response['status'] == 'success') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Password reset successfully.'),
                  ));
                  Navigator.pushReplacementNamed(context, '/Login');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRuleRow(String text, bool isValid, double maximumThing) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: maximumThing * 0.01),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 20,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
        Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: maximumThing * 0.015,
            fontWeight: FontWeight.w300,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
