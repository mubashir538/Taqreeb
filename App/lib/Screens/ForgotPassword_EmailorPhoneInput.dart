import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/validations.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class ForgotPassword_EmailorPhoneInput extends StatefulWidget {
  const ForgotPassword_EmailorPhoneInput({super.key});

  @override
  State<ForgotPassword_EmailorPhoneInput> createState() =>
      _ForgotPassword_EmailorPhoneInputState();
}

class _ForgotPassword_EmailorPhoneInputState
    extends State<ForgotPassword_EmailorPhoneInput> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  bool isLoading = false;
  TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
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

  Future<void> _sendCode() async {
    setState(() {
      isLoading = true;
    });
    String contact = contactController.text.trim();
    String type = '';
    if (contact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter your email/phone number'),
      ));
      return;
    }
    if (contactController.text.contains('@')) {
      if (Validations.validateEmail(contact) != "Ok") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Validations.validateEmail(contact)),
        ));
        return;
      }
      type = 'email';
    } else {
      if (Validations.validateContact(contact) != "Ok") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Validations.validateContact(contact)),
        ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Verification code sent successfully.'),
        ));
        Navigator.pushNamed(context, '/ForgotPassword_VerifyCode',
            arguments: {'email': contactController.text, 'response': response});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['message'] ?? 'Something went wrong.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    _getHeaderHeight();
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
                      SizedBox(height: _headerHeight),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                        child: MyTextBox(
                          hint: "Enter Email/Phone Number",
                          valueController: contactController,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
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
                    key: _headerKey,
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
