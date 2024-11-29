import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Iconed%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
        backgroundColor: MyColors.Dark,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(
                  heading: "Login to Continue",
                  para:
                      "We believe that your event should not be delayed so let's login your Account so we can get Started",
                  image: MyImages.Login,
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      MyTextBox(hint: "Enter Email or Phone Number"),
                      MyTextBox(hint: "Enter Password"),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context,
                                    '/ForgotPassword_EmailorPhoneInput');
                              },
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.012,
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.Yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      ColoredButton(
                        text: "Login",
                        onPressed: () {
                          Navigator.pushNamed(context, '/HomePage');
                        },
                      ),
                      BorderButton(
                        text: "Signup",
                        onPressed: () {
                          Navigator.pushNamed(context, '/basicSignup');
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                        child: MyDivider(),
                      ),
                      IconedButton(
                        text: "Continue with Google",
                        icon: MyIcons.google,
                      ),
                      IconedButton(
                          text: "Continue with Facebook",
                          icon: MyIcons.facebook),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
