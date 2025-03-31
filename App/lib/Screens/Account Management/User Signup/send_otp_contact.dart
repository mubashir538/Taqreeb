import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/phone_auth_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class SignupContactOtpSend extends StatefulWidget {
  const SignupContactOtpSend({super.key});

  @override
  State<SignupContactOtpSend> createState() => _SignupContactOtpSendState();
}

class _SignupContactOtpSendState extends State<SignupContactOtpSend> {
  final TextEditingController _contactController = TextEditingController();
  final FocusNode _contactFocus = FocusNode();
  final GlobalKey _headerKey = GlobalKey();
  bool _isLoading = false;

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
    _contactController.dispose();
    _contactFocus.dispose();
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
    if (!_validateContact()) return;

    setState(() => _isLoading = true);

    try {
      await PhoneAuthService()
          .sendOTP("+92${_contactController.text.substring(1)}");
      //   final response = await MyApi.postRequest(
      //     endpoint: 'sendOTP/phone',
      //     body: {'contactNumber': },
      //   );

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/Signup_ContactOTPVerify',
          arguments: {
            'contactNumber': _contactController.text,
          },
        );
      } else {
        MyScaffold(text: 'Failed to send OTP. Please try again later.')
            .show(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateContact() {
    final validationResult =
        Validations.validateContact(_contactController.text);
    if (validationResult != "Ok") {
      _showErrorDialog('Invalid Contact Number', validationResult);
      return false;
    }
    return true;
  }

  void _showErrorDialog(String title, String message) {
    MyScaffold(text: message).show(context);
  }

  void _navigateToEmailVerification() {
    Navigator.pushReplacementNamed(context, '/Signup_EmailOTPSend');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
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
                      SizedBox(
                        height: (Screen.height(context) * _topPaddingFactor) +
                            UI_Management.headerHeight,
                      ),
                      MyTextBox(
                        focusNode: _contactFocus,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                        hint: 'Contact Number',
                        isNum: true,
                        valueController: _contactController,
                      ),
                      SizedBox(
                        height: Screen.height(context) * _dividerHeightFactor,
                        child: const Center(child: MyDivider()),
                      ),
                      ColoredButton(
                        onPressed: _isLoading ? null : _sendOtp,
                        text: 'Send OTP',
                      ),
                      InkWell(
                        onTap: _navigateToEmailVerification,
                        child: Text(
                          'Verify Email Instead',
                          style: TextStyle(
                            color: MyColors.Yellow,
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
              heading: 'Contact Verification',
              para: 'Enter Phone number to send one time password',
              image: MyImages.SingupPng,
            ),
          ),
        ],
      ),
    );
  }
}
