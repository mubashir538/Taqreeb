import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class Signup_EmailOTPSend extends StatefulWidget {
  Signup_EmailOTPSend({super.key});

  @override
  State<Signup_EmailOTPSend> createState() => _Signup_EmailOTPSendState();
}

class _Signup_EmailOTPSendState extends State<Signup_EmailOTPSend> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  GlobalKey headerKey = GlobalKey();

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

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

  @override
  Widget build(BuildContext context) {
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
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: UI_Management.headerHeight,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: Screen.height(context) * 0.05,
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
                        height: Screen.height(context) * 0.1,
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
                            fontSize: Screen.max(context) * 0.015,
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
              key: headerKey,
              heading: 'Email Verification',
              para: 'Enter Email to send one time password',
              image: MyImages.SingupPng,
            ),
          ),
        ],
      ),
    );
  }
}
