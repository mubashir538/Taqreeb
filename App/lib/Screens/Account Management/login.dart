import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Buttons/c_icon_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/auth_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';
import 'package:taqreeb/core/utils/images.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey _headerKey = GlobalKey();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _measureHeaderHeight() {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UImanagement.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  Future<void> _handleLogin() async {
    if (!_validateCredentials()) return;

    setState(() => _isLoading = true);

    try {
      final response = await MyApi.postRequest(
        endpoint: 'User/login/',
        body: {
          "contact": _emailController.text,
          "password": _passwordController.text,
        },
      );

      if (response == null || response['status'] != 'success') {
        _showErrorDialog(
            "Error", response?['message'] ?? "Invalid Credentials");
        return;
      }

      await _handleSuccessfulLogin(response);
    } catch (e) {
      _showErrorDialog("Error", "Something went wrong!");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateCredentials() {
    if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
      _showErrorDialog("Invalid Credentials", "Please fill all the fields");
      return false;
    }
    if (_emailController.text.contains("@")) {
      final emailValidation = Validations.validateEmail(_emailController.text);
      if (emailValidation != "Ok") {
        _showErrorDialog("", 'Invalid Email');
        return false;
      }
    } else {
      final contactValidation =
          Validations.validateContact(_emailController.text);
      if (contactValidation != "Ok") {
        _showErrorDialog("", 'Invalid Credentials');
        return false;
      }
    }
    return true;
  }

  Future<bool> saveFCMToken() async {
    try {
      final response = await MyApi.postRequest(
        endpoint: 'notification/saveFCM',
        body: {
          'token': await MyStorage.yourFCM(),
          'userId': await MyStorage.getToken(MyTokens.userId),
        },
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error saving FCM token: $e');
      return false;
    }
  }

  Future<void> _handleSuccessfulLogin(Map<String, dynamic> response) async {
    await MyStorage.saveToken(response['refresh'], MyTokens.refreshToken);
    await MyStorage.saveToken(response['access'], MyTokens.accessToken);
    await MyStorage.saveToken(response['userid'].toString(), MyTokens.userId);

    await saveFCMToken();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/HomePage',
        ModalRoute.withName('/'),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final user = await AuthService().signInWithGoogle();
    if (user.isEmpty) return;

    try {
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
        await _handleSocialLoginSuccess(response);
      }
    } catch (e) {
      _showErrorDialog("Error", "Google sign-in failed");
    }
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      await AuthService().signInWithFacebook();
    } catch (e) {
      _showErrorDialog("Error", "Facebook sign-in failed");
    }
  }

  Future<void> _handleSocialLoginSuccess(Map<String, dynamic> response) async {
    await MyStorage.saveToken(response['refresh'].toString(), 'refresh');
    await MyStorage.saveToken(
        response['access'].toString(), MyTokens.accessToken);
    await MyStorage.saveToken(response['userId'].toString(), 'userId');
    await MyStorage.saveToken(MyTokens.user, MyTokens.userType);

    await MyApi.postRequest(
      endpoint: 'notification/saveFCM',
      body: {
        'token': await MyStorage.yourFCM(),
        'userId': await MyStorage.getToken(MyTokens.userId),
      },
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
    );

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/HomePage',
        ModalRoute.withName('/'),
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    MyScaffold(text: message).show(context);
  }

  void _navigateToForgotPassword() {
    context.pushNamedTransition(
        routeName: '/ForgotPassword_EmailorPhoneInput',
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300));
  }

  void _navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/BasicSignup');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          if (UImanagement.headerHeight > 0)
            SingleChildScrollView(
              child: SizedBox(
                width: Screen.width(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Headersecondary(
                          heading: "Login to Continue",
                          para:
                              "We believe that your event should not be delayed so let's "
                              "login your Account so we can get Started",
                          image: MyImages.login,
                        ),
                        SizedBox(height: (Screen.height(context) * 0.03)),
                        MyTextBox(
                          focusNode: _emailFocus,
                          prefixIcon: FontAwesomeIcons.envelope,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                          hint: "Enter Email or Phone Number",
                          valueController: _emailController,
                        ),
                        MyTextBox(
                          prefixIcon: FontAwesomeIcons.lock,
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (_) => _passwordFocus.unfocus(),
                          hint: "Enter Password",
                          isPassword: true,
                          valueController: _passwordController,
                        ),
                        SizedBox(
                          width: Screen.width(context) * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: _navigateToForgotPassword,
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.roboto(
                                    fontSize: Screen.max(context) * 0.013,
                                    fontWeight: FontWeight.w400,
                                    color: colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Screen.height(context) * 0.03),
                        ColoredButton(
                          text: "Login",
                          onPressed: _isLoading ? null : _handleLogin,
                        ),
                        BorderButton(
                          text: "Signup",
                          onPressed: _navigateToSignup,
                        ),
                        SizedBox(
                          height: Screen.height(context) * 0.05,
                          child: const MyDivider(),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconedButton(
                                onPressed: _handleGoogleSignIn,
                                icon: MyIcons.google,
                              ),
                              SizedBox(width: Screen.width(context) * 0.05),
                              IconedButton(
                                onPressed: _handleFacebookSignIn,
                                icon: MyIcons.facebook,
                              ),
                            ])
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
            ),
          ),
        ],
      ),
    );
  }
}
