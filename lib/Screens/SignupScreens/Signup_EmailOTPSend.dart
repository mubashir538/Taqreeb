import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/validations.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class Signup_EmailOTPSend extends StatefulWidget {
  Signup_EmailOTPSend({super.key});

  @override
  State<Signup_EmailOTPSend> createState() => _Signup_EmailOTPSendState();
}

class _Signup_EmailOTPSendState extends State<Signup_EmailOTPSend> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
 
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: _headerHeight,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      MyTextBox(
                        focusNode: emailFocus,
                        onFieldSubmitted: (value) {
                          emailFocus.unfocus();
                        },
                        hint: 'Email',
                        valueController: emailController,
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                        child: Center(child: MyDivider()),
                      ),
                      ColoredButton(
                        text: 'Send OTP',
                        onPressed: () async {
                          if (Validations.validateEmail(emailController.text) !=
                              "Ok") {
                            warningDialog(
                                    title: 'Invalid Contact Number',
                                    message: Validations.validateEmail(
                                        emailController.text))
                                .showDialogBox(context);
                          } else {
                            dynamic response = await MyApi.postRequest(
                                endpoint: 'sendOTP/email',
                                body: {'email': emailController.text});
                            print(response);
                            Navigator.pushNamed(
                                context, '/Signup_EmailOTPVerify', arguments: {
                              'email': emailController.text,
                              'response': response
                            });
                          }
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/Signup_ContactOTPSend');
                        },
                        child: Text(
                          'Use Contact to Verify Instead',
                          style: TextStyle(
                            color: MyColors.Yellow,
                            fontSize: MaximumThing * 0.015,
                          ),
                        ),
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
              para: 'Enter Email to send one time password',
              image: MyImages.SingupPng,
            ),
          ),
        ],
      ),
    );
  }
}
