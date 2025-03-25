import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';

class ForgotPasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendCode(String contact, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    String type = '';
    if (contact.isEmpty) {
      MyScaffold(text: 'Please enter your email/phone number').show(context);
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (contact.contains('@')) {
      if (Validations.validateEmail(contact) != "Ok") {
        MyScaffold(text: Validations.validateEmail(contact)).show(context);
        _isLoading = false;
        notifyListeners();
        return;
      }
      type = 'email';
    } else {
      if (Validations.validateContact(contact) != "Ok") {
        MyScaffold(text: Validations.validateContact(contact)).show(context);
        _isLoading = false;
        notifyListeners();
        return;
      }
      type = 'phone';
    }

    try {
      final Map<String, dynamic> data = {type: contact};

      final response = await MyApi.postRequest(
        endpoint: 'user/forgotpassword/phoneorEmail/',
        body: data,
      );

      if (response['status'] == 'success') {
        MyScaffold(text: 'Verification code sent successfully.').show(context);
        Navigator.pushNamed(context, '/ForgotPassword_VerifyCode',
            arguments: {'email': contact, 'response': response});
      } else {
        MyScaffold(text: 'Something Went Wrong!').show(context);
      }
    } catch (e) {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }

    _isLoading = false;
    notifyListeners();
  }
}
