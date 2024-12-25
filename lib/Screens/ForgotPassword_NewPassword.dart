import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';

class ForgotPassword_NewPassword extends StatefulWidget {
  const ForgotPassword_NewPassword({super.key});

  @override
  State<ForgotPassword_NewPassword> createState() =>
      _ForgotPassword_NewPasswordState();
}

class _ForgotPassword_NewPasswordState
    extends State<ForgotPassword_NewPassword> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
  _getHeaderHeight();

    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmpasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              key: _headerKey,
              heading: "Create New Password",
              para:
                  "This password should br different  from the previous password",
            ),
            Container(
              margin: EdgeInsets.only(top: MaximumThing * 0.05),
              child: Column(
                children: [
                  MyTextBox(
                    hint: 'New Password',
                    valueController: passwordController,
                  ),
                  MyTextBox(
                    hint: 'Confirm Password',
                    valueController: confirmpasswordController,
                  ),
                  Container(
                      margin:
                          EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                      width: screenWidth * 0.9,
                      child: Column(
                        children: [
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MaximumThing * 0.01),
                              child: Icon(Icons.check_circle_outline_rounded,
                                  size: 20, color: MyColors.white),
                            ),
                            Text(
                              "At least 8 characters",
                              style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.015,
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.white),
                            ),
                          ]),
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MaximumThing * 0.01),
                              child: Icon(Icons.check_circle_outline_rounded,
                                  size: 20, color: MyColors.white),
                            ),
                            Text(
                              "At least 1 number",
                              style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.015,
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.white),
                            ),
                          ]),
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MaximumThing * 0.01),
                              child: Icon(Icons.check_circle_outline_rounded,
                                  size: 20, color: MyColors.white),
                            ),
                            Text(
                              "Both upper and lower case letters",
                              style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.015,
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.white),
                            ),
                          ]),
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: MyDivider()),
            ),
            ColoredButton(
              text: "Reset Password",
              onPressed: () {
                Navigator.pushNamed(context, '/Login');
              },
            )
          ],
        ),
      ),
    );
  }
}
