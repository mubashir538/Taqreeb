import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';

class Header extends StatefulWidget {
  final String heading;
  final IconData icon;
  final String para;
  final String image;
  const Header(
      {this.icon = Icons.settings,
      this.heading = '',
      this.para = '',
      this.image = '',
      super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool nosettings = false;
  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool hasSomething = widget.heading.isNotEmpty ||
        widget.para.isNotEmpty ||
        widget.image.isNotEmpty;
    bool isSvg = false;
    if (widget.image.isNotEmpty) {
      isSvg = widget.image.substring(widget.image.length - 3) == 'svg'
          ? true
          : false;
    }
    double MaximumThing;
    if (screenWidth > screenHeight) {
      MaximumThing = screenWidth;
    } else {
      MaximumThing = screenHeight;
    }

    if (currentRoute == '/Login' ||
        currentRoute == '/basicSignup' ||
        currentRoute == '/Signup_ContactOTPSend' ||
        currentRoute == '/Signup_ContactOTPVerify' ||
        currentRoute == '/Signup_EmailOTPSend' ||
        currentRoute == '/Signup_EmailOTPVerify' ||
        currentRoute == '/Signup_MoreInfo' ||
        currentRoute == '/ProfilePictureUpload' ||
        currentRoute == '/BusinessSignup_BasicInfo' ||
        currentRoute == '/BusinessSignup_CNICUpload' ||
        currentRoute == '/BusinessSignup_Description' ||
        currentRoute == '/SubmissionSucessful' ||
        currentRoute == '/ForgotPassword_EmailorPhoneInput' ||
        currentRoute == '/ForgotPassword_VerifyCode' ||
        currentRoute == '/ForgotPassword_NewPassword') {
      nosettings = true;
    }
    return Container(
      height: hasSomething ? null : screenHeight * 0.1,
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: MyColors.red,
        borderRadius: hasSomething
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))
            : BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      print('error: $e');
                      SystemNavigator.pop();
                      exit(0);
                    }
                  },
                  child: Icon(Icons.chevron_left_outlined,
                      color: MyColors.redonWhite, size: MaximumThing * 0.03),
                ),
                Text(
                  'Taqreeb',
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.03,
                      fontWeight: FontWeight.w500,
                      color: MyColors.redonWhite),
                ),
                nosettings
                    ? Container()
                    : InkWell(
                        onTap: () async {
                          if (currentRoute == '/settings') {
                            warningDialog(
                                title: 'Logout',
                                message: 'Are you sure you want to logout?',
                                actions: [
                                  ColoredButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    text: 'Cancel',
                                    textSize: MaximumThing * 0.015,
                                    width: screenWidth * 0.3,
                                  ),
                                  ColoredButton(
                                    onPressed: () async {
                                      await MyStorage.deleteToken(
                                          MyTokens.refreshToken);
                                      await MyStorage.deleteToken(
                                          MyTokens.accessToken);
                                      await MyStorage.deleteToken(
                                          MyTokens.userId);
                                      await MyStorage.deleteToken(
                                          MyTokens.userType);
                                      await MyStorage.deleteToken(
                                          MyTokens.isBusinessOwner);
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/Login',
                                              (Route<dynamic> route) => false);
                                    },
                                    text: 'Logout',
                                    width: screenWidth * 0.3,
                                    textSize: MaximumThing * 0.015,
                                  ),
                                ]).showDialogBox(context);
                          } else {
                            Navigator.pushNamed(context, '/settings');
                          }
                        },
                        child: Icon(widget.icon,
                            color: MyColors.redonWhite,
                            size: MaximumThing * 0.03),
                      ),
              ],
            ),
          ),
          widget.heading.isNotEmpty
              ? Column(children: [
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    widget.heading,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.025,
                        fontWeight: FontWeight.w700,
                        color: MyColors.Yellow),
                  ),
                  SizedBox(
                      height: widget.para.isNotEmpty || widget.image.isNotEmpty
                          ? screenHeight * 0.01
                          : screenHeight * 0.03),
                ])
              : Container(),
          widget.para.isNotEmpty
              ? Column(children: [
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    widget.para,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.013,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white),
                  ),
                  SizedBox(
                      height: widget.image.isNotEmpty
                          ? screenHeight * 0.01
                          : screenHeight * 0.03),
                ])
              : Container(),
          widget.image.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(height: screenHeight * 0.03),
                    isSvg
                        ? SvgPicture.asset(widget.image,
                            height: screenHeight * 0.2)
                        : Image.asset(widget.image, height: screenHeight * 0.2),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
