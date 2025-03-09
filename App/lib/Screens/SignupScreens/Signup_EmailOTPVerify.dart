import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';

class SignupEmailOTPVerify extends StatefulWidget {
  const SignupEmailOTPVerify({super.key});

  @override
  _SignupEmailOTPVerifyState createState() => _SignupEmailOTPVerifyState();
}

class _SignupEmailOTPVerifyState extends State<SignupEmailOTPVerify> {
  int _remainingTime = 120; 
  late Timer _timer;
  bool _isResendEnabled = false;
  String _enteredOTP = ""; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());

    _startTimer();
  }

 void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingTime = 120;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
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
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = arguments['email'];
    final Map<String, dynamic> response = arguments['response'];
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height * 0.1) +
                            _headerHeight,
                      ),
                      OTPBoxes(
                        onChanged: (otp) {
                          _enteredOTP = otp;
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextButton(
                        onPressed: _isResendEnabled
                            ? () async {
                                final result =
                                    await response; 
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
                            decoration: _isResendEnabled
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(child: MyDivider()),
                      ),
                      ColoredButton(
                        text: 'Verify OTP',
                        onPressed: () async {
                          try {
                            final result = await response;
                            final receivedOTP = result['otp'];
                            if (int.parse(_enteredOTP) == receivedOTP) {
                              MyStorage.saveToken(result['email'], 'semail');
                              Navigator.pushNamed(context, '/Signup_MoreInfo');
                            } else {
                              warningDialog(
                                      title: 'Invalid OTP',
                                      message: 'The entered OTP is incorrect.')
                                  .showDialogBox(context);
                            }
                          } catch (e) {
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
                  ProgressBar(
                    Progress: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'OTP Verification',
              para:
                  'We have sent a 4-digit verification code to $email. Please check your email.',
            ),
          ),
        ],
      ),
    );
  }
}
