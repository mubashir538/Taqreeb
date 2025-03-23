import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Buttons/c_icon_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/auth_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';
import 'package:taqreeb/core/utils/images.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
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
          if (UI_Management.headerHeight > 0)
            SingleChildScrollView(
              child: Container(
                width: Screen.width(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            height: (Screen.height(context) * 0.03) +
                                UI_Management.headerHeight),
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
                          width: Screen.width(context) * 0.9,
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
                                    fontSize: Screen.max(context) * 0.012,
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Screen.height(context) * 0.03,
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
                                await MyApi.postRequest(
                                    endpoint: 'notification/saveFCM',
                                    body: {
                                      'token': await MyStorage.yourFCM(),
                                      'userId': await MyStorage.getToken(
                                          MyTokens.userId),
                                    },
                                    headers: {
                                      'Authorization':
                                          'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                                    });
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
                          height: Screen.height(context) * 0.05,
                          child: MyDivider(),
                        ),
                        IconedButton(
                          onPressed: () async {
                            Map<String, dynamic>? user =
                                await AuthService().signInWithGoogle();
                            if (user.length != 0) {
                              final response = await MyApi.postRequest(
                                endpoint: 'Login/googleAuthentication',
                                body: {
                                  'userId': user['user'].uid,
                                  'email': user['user'].email,
                                  'name': user['user'].displayName,
                                  'picture': user['user'].photoURL,
                                  'phone': user['phone'],
                                  'gender': user['gender'],
                                  'age': user['age'],
                                },
                              );
                              if (response['status'] == 'success') {
                                MyStorage.saveToken(
                                    response['refresh'].toString(), 'refresh');
                                MyStorage.saveToken(
                                    response['access'].toString(),
                                    MyTokens.accessToken);
                                MyStorage.saveToken(
                                    response['userId'].toString(), 'userId');
                                MyStorage.saveToken(
                                    MyTokens.user, MyTokens.userType);
                                await MyApi.postRequest(
                                    endpoint: 'notification/saveFCM',
                                    body: {
                                      'token': await MyStorage.yourFCM(),
                                      'userId': await MyStorage.getToken(
                                          MyTokens.userId),
                                    },
                                    headers: {
                                      'Authorization':
                                          'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                                    });
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/HomePage', ModalRoute.withName('/'));
                              }
                            }
                          },
                          text: "Continue with Google",
                          icon: MyIcons.google,
                        ),
                        IconedButton(
                            onPressed: () async {
                              await AuthService().signInWithFacebook();
                            },
                            text: "Continue with Facebook",
                            icon: MyIcons.facebook),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
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
