import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
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
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();

  void check(BuildContext context) async {
    if (await MyStorage.exists(MyTokens.sfname) &&
        await MyStorage.exists(MyTokens.slname) &&
        await MyStorage.exists(MyTokens.spassword)) {
      warningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to signup the app Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken(MyTokens.spassword);
              MyStorage.deleteToken(MyTokens.sfname);
              MyStorage.deleteToken(MyTokens.slname);
              MyStorage.deleteToken(MyTokens.semail);
              MyStorage.deleteToken(MyTokens.scity);
              MyStorage.deleteToken(MyTokens.sgender);

              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: () async {
              if (await MyStorage.exists(MyTokens.scity)) {
                Navigator.pushNamed(context, '/ProfilePictureUpload',
                    arguments: {'type': 'User'});
              } else if (await MyStorage.exists(MyTokens.sphone) ||
                  await MyStorage.exists(MyTokens.semail)) {
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
      _getHeaderHeight();
    });
  }

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

  // Future<void> signUpWithGoogle() async {
  //   try {
  //     // Trigger the Google Authentication flow
  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //     if (googleUser != null) {
  //       // Obtain the Google Sign-In authentication details
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;

  //       // Create a new credential
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       // Sign in to Firebase with the Google credential
  //       final UserCredential userCredential =
  //           await FirebaseAuth.instance.signInWithCredential(credential);

  //       final User? user = userCredential.user;

  //     //   if (user != null) {
  //     //     // Check if the user already exists in the database
  //     //     final userRef =
  //     //         FirebaseFirestore.instance.collection('users').doc(user.uid);
  //     //     final doc = await userRef.get();

  //     //     if (!doc.exists) {
  //     //       // If the user does not exist, add them to the database
  //     //       await userRef.set({
  //     //         'uid': user.uid,
  //     //         'name': user.displayName ?? '',
  //     //         'email': user.email ?? '',
  //     //         'photoUrl': user.photoURL ?? '',
  //     //         'createdAt': FieldValue.serverTimestamp(),
  //     //       });
  //     //     }

  //     //     return user;
  //     //   }
  //     }
  //   } catch (e) {
  //     print('Error signing in with Google: $e');
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                ),
                MyTextBox(
                    focusNode: firstNameFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(lastNameFocus);
                    },
                    hint: "First Name",
                    valueController: firstNameController),
                MyTextBox(
                    focusNode: lastNameFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(passwordFocus);
                    },
                    hint: "Last Name",
                    valueController: lastNameController),
                MyTextBox(
                    focusNode: passwordFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(confirmPasswordFocus);
                    },
                    hint: "Password",
                    isPassword: true,
                    valueController: passwordController),
                MyTextBox(
                    focusNode: confirmPasswordFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    hint: "Confirm Password",
                    isPassword: true,
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
                        message: Validations.validatePassword(
                            passwordController.text),
                        title: "Invalid Details",
                      ).showDialogBox(context);
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      warningDialog(
                        message:
                            "Password and Confirm Password Should be Same!",
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
                      style: TextStyle(color: MyColors.yellowonDark),
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
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "SignUP",
              para: "Unlock exclusive events - sign up now!",
              image: MyImages.Signup1,
            ),
          ),
        ],
      ),
    );
  }
}
