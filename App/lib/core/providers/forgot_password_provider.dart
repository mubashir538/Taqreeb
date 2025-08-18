import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';

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
        MyScaffold(text: 'Invalid Credentials').show(context);
        _isLoading = false;
        notifyListeners();
        return;
      }
      type = 'email';
    } else {
      if (Validations.validateContact(contact) != "Ok") {
        MyScaffold(text: 'Invalid Credentials').show(context);
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
        context.pushNamedTransition(
            routeName: '/ForgotPassword_VerifyCode',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            arguments: {'email': contact, 'response': response});
      } else if(response['status'] == 'error') {
        MyScaffold(text: 'You Already have an Account, Try a Different Email')
            .show(context);
        return;
      }
      else {
        MyScaffold(text: 'Something Went Wrong!').show(context);
      }
    } catch (e) {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }

    _isLoading = false;
    notifyListeners();
  }
}
