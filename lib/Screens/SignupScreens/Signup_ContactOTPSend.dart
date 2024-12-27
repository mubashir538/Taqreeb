import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/validations.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class Signup_ContactOTPSend extends StatefulWidget {
  const Signup_ContactOTPSend({super.key});

  @override
  State<Signup_ContactOTPSend> createState() => _Signup_ContactOTPSendState();
}

class _Signup_ContactOTPSendState extends State<Signup_ContactOTPSend> {
  TextEditingController contactController = TextEditingController();

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
                  Column(
                    children: [
                      SizedBox(
                        height: (screenHeight * 0.05) + _headerHeight,
                      ),
                      MyTextBox(
                        hint: 'Contact Number',
                        isNum: true,
                        valueController: contactController,
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                        child: Center(child: MyDivider()),
                      ),
                      ColoredButton(
                        onPressed: () {
                          if (Validations.validateContact(
                                  contactController.text) !=
                              "Ok") {
                            warningDialog(
                                    title: 'Invalid Contact Number',
                                    message: Validations.validateContact(
                                        contactController.text))
                                .showDialogBox(context);
                          } else {
                            late Future<dynamic> response = MyApi.postRequest(
                                endpoint: 'sendOTP/phone',
                                body: {
                                  'contactNumber': contactController.text
                                });
                            Navigator.pushNamed(
                                context, '/Signup_ContactOTPVerify',
                                arguments: {
                                  'contactNumber': contactController.text,
                                  'response': response
                                });
                          }
                        },
                        text: 'Send OTP',
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/Signup_EmailOTPSend');
                        },
                        child: Text(
                          'Verify Email Instead',
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
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'OTP Verification',
              para: 'Enter Phone number to send one time password',
              image: MyImages.SingupPng,
            ),
          ),
        ],
      ),
    );
  }
}
