import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';

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
              margin: EdgeInsets.only(top: Screen.max(context) * 0.05),
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
                    margin: EdgeInsets.symmetric(
                        vertical: Screen.max(context) * 0.02),
                    width: Screen.width(context) * 0.9,
                    child: Column(
                      children: [
                        _buildRuleRow(
                          "At least 8 characters",
                          hasMinLength,
                        ),
                        _buildRuleRow(
                          "At least 1 number",
                          hasNumber,
                        ),
                        _buildRuleRow(
                          "At least one special character",
                          hasSpecialChar,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Screen.height(context) * 0.1,
              child: Center(child: MyDivider()),
            ),
            ColoredButton(
              text: "Reset Password",
              onPressed: () async {
                if (passwordController.text != confirmpasswordController.text) {
                  MyScaffold(text: 'Something Went Wrong!').show(context);
                  return;
                }
                if (!hasMinLength || !hasNumber || !hasSpecialChar) {
                  MyScaffold(text: 'Password does not meet the requirements.')
                      .show(context);
                  return;
                }
                final response = await MyApi.postRequest(
                    endpoint: 'user/forgotpassword/reset-password/',
                    body: {
                      'contact': email,
                      'password': passwordController.text
                    });

                if (response['status'] == 'success') {
                  MyScaffold(text: 'Password reset successfully.')
                      .show(context);
                  Navigator.pushReplacementNamed(context, '/Login');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRuleRow(String text, bool isValid) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.01),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 20,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
        Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: Screen.max(context) * 0.015,
            fontWeight: FontWeight.w300,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
