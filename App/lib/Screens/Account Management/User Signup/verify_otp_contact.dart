import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/Components/Inputs/c_input_otp.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/utils/color.dart';

class SignupContactOTPVerify extends StatefulWidget {
  const SignupContactOTPVerify({super.key});

  @override
  _SignupContactOTPVerifyState createState() => _SignupContactOTPVerifyState();
}

class _SignupContactOTPVerifyState extends State<SignupContactOTPVerify> {
  int _remainingTime = 120;
  late Timer _timer;
  bool _isResendEnabled = false;
  String _enteredOTP = "";
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));

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

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final contactNumber = arguments['contactNumber'];
    final Future<dynamic> response = arguments['response'];
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
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
                            UI_Management.headerHeight,
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
                                final result = await response;

                                MyApi.postRequest(
                                    endpoint: 'resendOTP/phone',
                                    body: {
                                      'phone': result['contact'],
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
                            if (_enteredOTP == receivedOTP) {
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
            top: 0,
            child: Header(
              key: headerKey,
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
