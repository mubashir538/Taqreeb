import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Classes/validations.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Iconed%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  void _getHeaderHeight() {
    final RenderObject? renderObject =
        _headerKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      setState(() {
        _headerHeight = renderObject.size.height;
      });
    }
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
          if (_headerHeight > 0)
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: (screenHeight * 0.03) + _headerHeight),
                      MyTextBox(
                        focusNode: emailFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                        hint: "Enter Email or Phone Number",
                        valueController: emailController,
                      ),
                      MyTextBox(
                        focusNode: passwordFocus,
                        onFieldSubmitted: (_) {
                          passwordFocus.unfocus();
                        },
                        hint: "Enter Password",
                        isPassword: true,
                        valueController: passwordController,
                      ),
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
                        onPressed: () async {
                          if (emailController.text.contains("@")) {
                            if (Validations.validateEmail(
                                    emailController.text) !=
                                "Ok") {
                              warningDialog(
                                      title: "Invalid Email",
                                      message: Validations.validateEmail(
                                          emailController.text))
                                  .showDialogBox(context);
                              return;
                            }
                          } else {
                            if (Validations.validateContact(
                                    emailController.text) !=
                                "Ok") {
                              warningDialog(
                                      title: "Invalid Contact",
                                      message: Validations.validateContact(
                                          emailController.text))
                                  .showDialogBox(context);
                              return;
                            }
                          }
                          final response = await MyApi.postRequest(
                              endpoint: 'User/login/',
                              body: {
                                "contact": emailController.text,
                                "password": passwordController.text
                              });
                          if (response != null) {
                            if (response['status'] == 'success') {
                              await MyStorage.saveToken(
                                  response['refresh'], MyTokens.refreshToken);
                              await MyStorage.saveToken(
                                  response['access'], MyTokens.accessToken);
                              await MyStorage.saveToken(
                                  response['userid'].toString(),
                                  MyTokens.userId);
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/HomePage', ModalRoute.withName('/'));
                            } else {
                              warningDialog(
                                message: "Invalid Credentials",
                                title: "Error",
                              ).showDialogBox(context);
                            }
                          } else {
                            warningDialog(
                              message: "Something Went Wrong!",
                              title: "Error",
                            ).showDialogBox(context);
                          }
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
                ],
              ),
            ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Login to Continue",
              para:
                  "We believe that your event should not be delayed so let's login your Account so we can get Started",
              image: MyImages.Login,
            ),
          ),
        ],
      ),
    );
  }
}
