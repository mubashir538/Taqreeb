import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/core/services/api_service.dart';

class ForgotPasswordVerifyCodeViewModel with ChangeNotifier {
  int _remainingTime = 10;
  bool _isResendEnabled = false;
  String _enteredOTP = "";
  Timer? _timer;

  int get remainingTime => _remainingTime;
  bool get isResendEnabled => _isResendEnabled;
  String get enteredOTP => _enteredOTP;

  void setEnteredOTP(String value) {
    _enteredOTP = value;
    notifyListeners();
  }

  void startTimer() {
    _isResendEnabled = false;
    _remainingTime = 10;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isResendEnabled = true;
        notifyListeners();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> resendOTP(String email, String otp) async {
    await MyApi.postRequest(
        endpoint: 'resendOTP/email', body: {'email': email, 'otp': otp});
    startTimer();
  }

  Future<void> verifyOTP(int enteredOTP, int receivedOTP, BuildContext context,
      String email) async {
    if (enteredOTP == receivedOTP) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/ForgotPassword_NewPassword',
        arguments: {'email': email},
        ModalRoute.withName('/'),
      );
    } else {
      // Show error dialog
      MyScaffold(text: 'Invalid OTP').show(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
