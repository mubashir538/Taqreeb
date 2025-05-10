import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';

class ForgotPasswordNewPassword extends StatefulWidget {
  const ForgotPasswordNewPassword({super.key});

  @override
  State<ForgotPasswordNewPassword> createState() =>
      _ForgotPasswordNewPasswordState();
}

class _ForgotPasswordNewPasswordState extends State<ForgotPasswordNewPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _email;
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      _hasMinLength = _passwordController.text.length >= 8;
      _hasNumber = RegExp(r'\d').hasMatch(_passwordController.text);
      _hasSpecialChar =
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);
    });
  }

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      MyScaffold(text: 'Passwords do not match.').show(context);
      return;
    }
    if (!_hasMinLength || !_hasNumber || !_hasSpecialChar) {
      MyScaffold(text: 'Password does not meet the requirements.')
          .show(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await MyApi.postRequest(
        endpoint: 'user/forgotpassword/reset-password/',
        body: {
          'contact': _email,
          'password': _passwordController.text,
        },
      );

      if (response['status'] == 'success') {
        MyScaffold(text: 'Password reset successfully.').show(context);
        Navigator.pushReplacementNamed(context, '/Login');
      } else {
        MyScaffold(text: 'Something Went Wrong!').show(context);
      }
    } catch (e) {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _email = args['email'].toString();

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
              ),
            )
          : SingleChildScrollView(
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
                          valueController: _passwordController,
                        ),
                        MyTextBox(
                          hint: 'Confirm Password',
                          valueController: _confirmPasswordController,
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
                                _hasMinLength,
                              ),
                              _buildRuleRow(
                                "At least 1 number",
                                _hasNumber,
                              ),
                              _buildRuleRow(
                                "At least one special character",
                                _hasSpecialChar,
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
                    onPressed: _resetPassword,
                  ),
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
          style: GoogleFonts.roboto(
            fontSize: Screen.max(context) * 0.015,
            fontWeight: FontWeight.w300,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
