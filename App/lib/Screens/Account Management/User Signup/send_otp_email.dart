import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class SignupEmailOtpSend extends StatefulWidget {
  const SignupEmailOtpSend({super.key});

  @override
  State<SignupEmailOtpSend> createState() => _SignupEmailOtpSendState();
}

class _SignupEmailOtpSendState extends State<SignupEmailOtpSend> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final GlobalKey _headerKey = GlobalKey();
  bool _isLoading = false;

  // Constants
  static const double _topPaddingFactor = 0.05;
  static const double _dividerHeightFactor = 0.1;
  static const double _textSizeFactor = 0.015;
  static const int _progressStep = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _measureHeaderHeight() {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UI_Management.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  Future<void> _sendOtp() async {
    if (!_validateEmail()) return;

    setState(() => _isLoading = true);

    try {
      final response = await MyApi.postRequest(
        endpoint: 'sendOTP/email',
        body: {'email': _emailController.text},
      );
      if (response['status'] == 'error') {
        MyScaffold(text: 'You Already have an Account, Try a Different Email')
            .show(context);
        return;
      }
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/Signup_EmailOTPVerify',
          arguments: {
            'email': _emailController.text,
            'response': response,
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateEmail() {
    final validationResult = Validations.validateEmail(_emailController.text);
    if (validationResult != "Ok") {
      _showErrorDialog('Invalid Email', validationResult);
      return false;
    }
    return true;
  }

  void _showErrorDialog(String title, String message) {
    MyScaffold(text: message).show(context);
  }

  void _navigateToContactVerification() {
    Navigator.pushReplacementNamed(context, '/Signup_ContactOTPSend');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: UI_Management.headerHeight),
                      SizedBox(
                          height: Screen.height(context) * _topPaddingFactor),
                      MyTextBox(
                        focusNode: _emailFocus,
                        onFieldSubmitted: (_) => _emailFocus.unfocus(),
                        hint: 'Email',
                        valueController: _emailController,
                      ),
                      SizedBox(
                        height: Screen.height(context) * _dividerHeightFactor,
                        child: const Center(child: MyDivider()),
                      ),
                      _isLoading
                          ? CircularProgressIndicator.adaptive()
                          : ColoredButton(
                              text: 'Send OTP',
                              onPressed: _isLoading ? null : _sendOtp,
                            ),
                      InkWell(
                        onTap: _navigateToContactVerification,
                        child: Text(
                          'Use Contact to Verify Instead',
                          style: TextStyle(
                            color: MyColors.yellow,
                            fontSize: Screen.max(context) * _textSizeFactor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const ProgressBar(progress: _progressStep),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Email Verification',
              para: 'Enter Email to send one time password',
              image: MyImages.SingupPng,
            ),
          ),
        ],
      ),
    );
  }
}
