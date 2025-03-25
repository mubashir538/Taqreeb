import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Inputs/c_input_otp.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class SignupContactOtpVerify extends StatefulWidget {
  const SignupContactOtpVerify({super.key});

  @override
  State<SignupContactOtpVerify> createState() => _SignupContactOtpVerifyState();
}

class _SignupContactOtpVerifyState extends State<SignupContactOtpVerify> {
  final GlobalKey _headerKey = GlobalKey();
  final int _initialTimerDuration = 120;
  int _remainingTime = 120;
  late Timer _timer;
  bool _isResendEnabled = false;
  String _enteredOTP = "";
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
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

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingTime = _initialTimerDuration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        _timer.cancel();
        setState(() => _isResendEnabled = true);
      }
    });
  }

  Future<void> _resendOtp(Map<String, dynamic> response) async {
    try {
      await MyApi.postRequest(
        endpoint: 'resendOTP/phone',
        body: {
          'phone': response['contact'],
          'otp': response['otp'],
        },
      );
      _startTimer();
    } catch (e) {
      _showErrorDialog('Error', 'Failed to resend OTP. Please try again.');
    }
  }

  Future<void> _verifyOtp(Map<String, dynamic> response) async {
    if (_enteredOTP.isEmpty || _enteredOTP.length != 4) {
      _showErrorDialog('Invalid OTP', 'Please enter a 4-digit code');
      return;
    }

    setState(() => _isVerifying = true);

    try {
      if (_enteredOTP == response['otp']) {
        await MyStorage.saveToken(response['contact'], 'sphone');
        if (mounted) {
          Navigator.pushNamed(context, '/Signup_MoreInfo');
        }
      } else {
        _showErrorDialog('Invalid OTP', 'The entered OTP is incorrect.');
      }
    } catch (e) {
      _showErrorDialog('Error', 'Failed to verify OTP. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    warningDialog(
      title: title,
      message: message,
    ).showDialogBox(context);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final contactNumber = arguments?['contactNumber'] ?? '';
    final response = arguments?['response'] as Future<dynamic>?;

    if (response == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                              UI_Management.headerHeight),
                      OTPBoxes(
                        onChanged: (otp) => _enteredOTP = otp,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      FutureBuilder<dynamic>(
                        future: response,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Error loading OTP',
                              style: TextStyle(color: MyColors.white),
                            );
                          }

                          return TextButton(
                            onPressed: _isResendEnabled && snapshot.hasData
                                ? () => _resendOtp(snapshot.data!)
                                : null,
                            child: Text(
                              _isResendEnabled
                                  ? 'Send Code Again'
                                  : 'Send Code Again in ${_formatTime(_remainingTime)}',
                              style: TextStyle(
                                color: MyColors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                decoration: _isResendEnabled
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: const Center(child: MyDivider()),
                      ),
                      FutureBuilder<dynamic>(
                        future: response,
                        builder: (context, snapshot) {
                          return ColoredButton(
                            text: 'Verify OTP',
                            onPressed: snapshot.hasData && !_isVerifying
                                ? () => _verifyOtp(snapshot.data!)
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                  const ProgressBar(Progress: 1),
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
                  'We have sent a 4-digit verification code to $contactNumber. '
                  'Please check your number.',
            ),
          ),
        ],
      ),
    );
  }
}
