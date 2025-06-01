import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
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

class BasicSignup extends StatefulWidget {
  const BasicSignup({super.key});

  @override
  State<BasicSignup> createState() => _BasicSignupState();
}

class _BasicSignupState extends State<BasicSignup> {
  // Controllers and Focus Nodes
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();

  final GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPreviousSignupAttempt();
      _measureHeaderHeight();
    });
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    super.dispose();
  }

  Future<void> _checkPreviousSignupAttempt() async {
    final hasPreviousAttempt = await MyStorage.exists(MyTokens.sfname) &&
        await MyStorage.exists(MyTokens.slname) &&
        await MyStorage.exists(MyTokens.spassword);

    if (hasPreviousAttempt) {
      _showContinueDialog();
    }
  }

  void _showContinueDialog() {
    WarningDialog(
      title: 'Fresh Start',
      message: 'We noticed that you had lately attempted to signup the app. '
          'Do you want to continue where you left or want a Fresh Start?',
      actions: [
        ColoredButton(
          text: 'Fresh Start',
          onPressed: () => _clearPreviousSignupData(context),
        ),
        ColoredButton(
          text: 'Continue',
          onPressed: () async {
            await _navigateBasedOnPreviousProgress(context);
          },
        ),
      ],
    ).showDialogBox(context);
  }

  void _clearPreviousSignupData(BuildContext context) {
    MyStorage.deleteToken(MyTokens.spassword);
    MyStorage.deleteToken(MyTokens.sfname);
    MyStorage.deleteToken(MyTokens.slname);
    MyStorage.deleteToken(MyTokens.semail);
    MyStorage.deleteToken(MyTokens.scity);
    MyStorage.deleteToken(MyTokens.sgender);
    Navigator.pop(context);
  }

  Future<void> _navigateBasedOnPreviousProgress(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      await Navigator.of(context, rootNavigator: true).maybePop();
    }

    await Future.delayed(Duration(
        milliseconds: 100)); // Small delay ensures smooth UI transition

    if (await MyStorage.exists(MyTokens.scity)) {
      context.pushNamedTransition(
          routeName: '/ProfilePictureUpload',
          type: PageTransitionType.rightToLeftWithFade,
          duration: Duration(milliseconds: 300),
          arguments: {'type': 'User'});
    } else if (await MyStorage.exists(MyTokens.sphone) ||
        await MyStorage.exists(MyTokens.semail)) {
      context.pushNamedTransition(
          routeName: '/Signup_MoreInfo',
          type: PageTransitionType.rightToLeftWithFade,
          duration: Duration(milliseconds: 300));
    } else {
      context.pushNamedTransition(
          routeName: '/Signup_EmailOTPSend',
          type: PageTransitionType.rightToLeftWithFade,
          duration: Duration(milliseconds: 300));
    }
  }

  void _measureHeaderHeight() {
    UImanagement.getHeaderHeight(
      headerKey: headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UImanagement.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  Future<void> _handleSignup() async {
    if (!_validateForm()) return;

    await _saveUserData();
    context.pushNamedTransition(
        routeName: '/Signup_EmailOTPSend',
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300));
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showErrorDialog("Please fill all the details");
      return false;
    }
    final firstNameValidation =
        Validations.validateName(firstNameController.text);
    final lastNameValidation =
        Validations.validateName(lastNameController.text);
    if (firstNameValidation != 'Ok' || lastNameValidation != 'Ok') {
      _showErrorDialog(firstNameValidation == 'Ok'
          ? lastNameValidation
          : firstNameValidation);
      return false;
    }

    final passwordValidation =
        Validations.validatePassword(passwordController.text);
    if (passwordValidation != 'Ok') {
      _showErrorDialog(passwordValidation);
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog("Password and Confirm Password Should be Same!");
      return false;
    }

    return true;
  }

  void _showErrorDialog(String message) {
    MyScaffold(text: message).show(context);
  }

  Future<void> _saveUserData() async {
    await MyStorage.saveToken(firstNameController.text, "sfname");
    await MyStorage.saveToken(lastNameController.text, "slname");
    await MyStorage.saveToken(passwordController.text, "spassword");
  }

  Future<void> _handleGoogleSignIn() async {
    final user = await AuthService().signInWithGoogle();
    if (user.isEmpty) return;

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
      await _handleSuccessfulLogin(response);
    }
  }

  Future<void> _handleSuccessfulLogin(Map<String, dynamic> response) async {
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

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/HomePage',
      ModalRoute.withName('/'),
    );
  }

  Widget _buildSocialLoginButton(
      {required String icon,
      required VoidCallback onPressed,
      required AppColors colors}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Screen.height(context) * 0.015,
          vertical: Screen.height(context) * 0.02,
        ),
        height: Screen.height(context) * 0.06,
        width: Screen.height(context) * 0.06,
        decoration: BoxDecoration(
          color: colors.darkLighter,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: Screen.height(context) * 0.04,
            height: Screen.height(context) * 0.04,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  Headersecondary(
                    heading: "Signup",
                    para: "Unlock exclusive events - sign up now!",
                    image: MyImages.signup1,
                  ),
                  SizedBox(height: Screen.height(context) * 0.01),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.user,
                    focusNode: firstNameFocus,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(lastNameFocus),
                    hint: "First Name",
                    valueController: firstNameController,
                  ),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.user,
                    focusNode: lastNameFocus,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(passwordFocus),
                    hint: "Last Name",
                    valueController: lastNameController,
                  ),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.lock,
                    focusNode: passwordFocus,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(confirmPasswordFocus),
                    hint: "Password",
                    isPassword: true,
                    valueController: passwordController,
                  ),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.lock,
                    focusNode: confirmPasswordFocus,
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    hint: "Confirm Password",
                    isPassword: true,
                    valueController: confirmPasswordController,
                  ),
                  ColoredButton(
                    text: "Continue",
                    onPressed: _handleSignup,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/Login'),
                    child: Text(
                      "Already a Member? Login",
                      style: GoogleFonts.roboto(
                          color: colors.red, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialLoginButton(
                        colors: colors,
                        icon: MyIcons.google,
                        onPressed: _handleGoogleSignIn,
                      ),
                      // _buildSocialLoginButton(
                      //   colors: colors,
                      //   icon: MyIcons.facebook,
                      //   onPressed: () => AuthService().signInWithFacebook(),
                      // ),
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
            ),
          ),
        ],
      ),
    );
  }
}
