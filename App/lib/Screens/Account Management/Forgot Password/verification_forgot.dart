import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_otp.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';

class ForgotPassword_VerifyCode extends StatefulWidget {
  const ForgotPassword_VerifyCode({super.key});

  @override
  State<ForgotPassword_VerifyCode> createState() =>
      _ForgotPassword_VerifyCodeState();
}

class _ForgotPassword_VerifyCodeState extends State<ForgotPassword_VerifyCode> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  int _remainingTime = 120;
  late Timer _timer;
  bool _isResendEnabled = false;
  String _enteredOTP = "";

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingTime = 120;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && mounted) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        if (mounted) {
          setState(() {
            _isResendEnabled = true;
          });
        }
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHeaderHeight();
      _startTimer();
    });
  }

  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = arguments['email'];
    final Map<String, dynamic> response = arguments['response'];
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: _headerHeight),
                Container(
                    margin: EdgeInsets.only(
                        top: MaximumThing * 0.07, bottom: MaximumThing * 0.02),
                    child: OTPBoxes(
                      onChanged: (value) {
                        setState(() {
                          _enteredOTP = value;
                        });
                      },
                    )),
                TextButton(
                  onPressed: _isResendEnabled
                      ? () async {
                          final result = await response;
                          await MyApi.postRequest(
                              endpoint: 'resendOTP/email',
                              body: {
                                'email': result['email'],
                                'otp': result['otp']
                              });
                          _startTimer();
                        }
                      : null,
                  child: Text(
                    _isResendEnabled
                        ? 'Send Code Again'
                        : 'Send Code Again in ${_formatTime(_remainingTime)}',
                    style: TextStyle(
                      color: MyColors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      decoration:
                          _isResendEnabled ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Verify Code',
                  onPressed: () async {
                    try {
                      final result = await response;
                      final receivedOTP = result['otp'];
                      if (int.parse(_enteredOTP) == receivedOTP) {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/ForgotPassword_NewPassword',
                            arguments: {
                              'email': email,
                            },
                            ModalRoute.withName('/'));
                      } else {
                        warningDialog(
                                title: 'Invalid OTP',
                                message: 'The entered OTP is incorrect.')
                            .showDialogBox(context);
                      }
                    } catch (e) {
                      print('Error: $e');
                      warningDialog(
                              title: 'Error',
                              message:
                                  'Failed to verify OTP. Please try again.')
                          .showDialogBox(context);
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Verify Code',
              para: 'We have send the code to $email',
            ),
          ),
        ],
      ),
    );
  }
}
