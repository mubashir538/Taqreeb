import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/validations.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class BasicSignup extends StatefulWidget {
  BasicSignup({super.key});

  @override
  State<BasicSignup> createState() => _BasicSignupState();
}

class _BasicSignupState extends State<BasicSignup> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  void check(BuildContext context) async {
    if (await MyStorage.exists('sfname') &&
        await MyStorage.exists('slname') &&
        await MyStorage.exists('spassword')) {
      warningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to signup the app Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken('spassword');
              MyStorage.deleteToken('sfname');
              MyStorage.deleteToken('slname');
              MyStorage.deleteToken('semail');
              MyStorage.deleteToken('scity');
              MyStorage.deleteToken('sgender');

              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: () async {
              if (await MyStorage.exists('scity')) {
                Navigator.pushNamed(context, '/ProfilePictureUpload',
                              arguments: {'type': 'User'});
              } else if (await MyStorage.exists('sphone') ||
                  await MyStorage.exists('semail')) {
                Navigator.pushNamed(context, '/Signup_MoreInfo');
              } else {
                Navigator.pushNamed(context, '/Signup_ContactOTPSend');
              }
            },
          )
        ],
      ).showDialogBox(context);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      check(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: "SignUP",
              para: "Unlock exclusive events - sign up now!",
              image: MyImages.Signup1,
            ),
            MyTextBox(hint: "First Name", valueController: firstNameController),
            MyTextBox(hint: "Last Name", valueController: lastNameController),
            MyTextBox(hint: "Password", valueController: passwordController),
            MyTextBox(
                hint: "Confirm Password",
                valueController: confirmPasswordController),
            ColoredButton(
              text: "Continue",
              onPressed: () {
                if (firstNameController.text.isEmpty ||
                    lastNameController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  warningDialog(
                    message: "Please fill all the details",
                    title: "Invalid Details",
                  ).showDialogBox(context);
                } else if (Validations.validatePassword(
                        passwordController.text) !=
                    'Ok') {
                  warningDialog(
                    message:
                        Validations.validatePassword(passwordController.text),
                    title: "Invalid Details",
                  ).showDialogBox(context);
                } else if (passwordController.text !=
                    confirmPasswordController.text) {
                  warningDialog(
                    message: "Password and Confirm Password Should be Same!",
                    title: "Invalid Details",
                  ).showDialogBox(context);
                } else {
                  MyStorage.saveToken(firstNameController.text, "sfname");
                  MyStorage.saveToken(lastNameController.text, "slname");
                  MyStorage.saveToken(passwordController.text, "spassword");
                  Navigator.pushNamed(context, '/Signup_ContactOTPSend');
                }
              },
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/Login');
                },
                child: Text(
                  "Already a Member? Login",
                  style: TextStyle(color: MyColors.Yellow),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.015,
                      vertical: screenHeight * 0.02),
                  height: screenHeight * 0.06,
                  width: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      color: MyColors.DarkLighter,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: SvgPicture.asset(MyIcons.google,
                        width: screenHeight * 0.04,
                        height: screenHeight * 0.04),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenHeight * 0.015,
                      vertical: screenHeight * 0.02),
                  height: screenHeight * 0.06,
                  width: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      color: MyColors.DarkLighter,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: SvgPicture.asset(MyIcons.facebook,
                        width: screenHeight * 0.04,
                        height: screenHeight * 0.04),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
