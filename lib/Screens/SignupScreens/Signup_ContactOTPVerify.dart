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

class SignupContactOTPVerify extends StatefulWidget {
  const SignupContactOTPVerify({super.key});

  @override
  _SignupContactOTPVerifyState createState() => _SignupContactOTPVerifyState();
}

class _SignupContactOTPVerifyState extends State<SignupContactOTPVerify> {
  int _remainingTime = 120; // 2 minutes in seconds
  late Timer _timer;
  bool _isResendEnabled = false;
  String _enteredOTP = ""; // To store the user's entered OTP

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingTime = 120; // Reset timer to 2 minutes
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
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final contactNumber = arguments['contactNumber'];
    final Future<dynamic> response = arguments['response'];
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
                          _enteredOTP = otp; // Update OTP on user input
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextButton(
                        onPressed: _isResendEnabled
                            ? () async {
                                final result =
                                    await response; // Await the response

                                MyApi.postRequest(
                                    endpoint: 'resendOTP/phone',
                                    body: {
                                      'phone': result['contact'],
                                      'otp': result['otp']
                                    });
                                _startTimer(); // Restart the timer
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
                            final result = await response; // Await the response
                            final receivedOTP =
                                result['otp']; // Extract the OTP
                            if (_enteredOTP == receivedOTP) {
                              // OTP matches, navigate to the next screen
                              MyStorage.saveToken(result['contact'], 'sphone');
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
            child: Header(
              key: _headerKey,
              heading: 'OTP Verification',
              para:
                  'We have sent a 4-digit verification code to $contactNumber. Please check your number.',
            ),
          ),
        ],
      ),
    );
  }
}
