import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class ForgotPassword_EmailorPhoneInput extends StatefulWidget {
  const ForgotPassword_EmailorPhoneInput({super.key});

  @override
  State<ForgotPassword_EmailorPhoneInput> createState() =>
      _ForgotPassword_EmailorPhoneInputState();
}

class _ForgotPassword_EmailorPhoneInputState
    extends State<ForgotPassword_EmailorPhoneInput> {
  bool isLoading = false;
  TextEditingController contactController = TextEditingController();
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
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _sendCode() async {
    setState(() {
      isLoading = true;
    });
    String contact = contactController.text.trim();
    String type = '';
    if (contact.isEmpty) {
      MyScaffold(text: 'Please enter your email/phone number').show(context);
      return;
    }
    if (contactController.text.contains('@')) {
      if (Validations.validateEmail(contact) != "Ok") {
        MyScaffold(text: Validations.validateEmail(contact)).show(context);
        return;
      }
      type = 'email';
    } else {
      if (Validations.validateContact(contact) != "Ok") {
        MyScaffold(text: Validations.validateContact(contact)).show(context);
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
            arguments: {'email': contactController.text, 'response': response});
      } else {
        MyScaffold(text: 'Something Went Wrong!').show(context);
      }
    } catch (e) {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: UI_Management.headerHeight),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Screen.max(context) * 0.02),
                        child: MyTextBox(
                          hint: "Enter Email/Phone Number",
                          valueController: contactController,
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context) * 0.05,
                        child: Center(child: MyDivider()),
                      ),
                      ColoredButton(
                        text: "Send Code",
                        onPressed: _sendCode,
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Header(
                    key: headerKey,
                    heading: 'Forgot Password',
                    para:
                        'Enter the email address with your account  and we\'ll send an email with confirmation to reset your password',
                    image: MyImages.ForgotPassword,
                  ),
                ),
              ],
            ),
    );
  }
}
