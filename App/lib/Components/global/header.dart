import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

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

    bool hasSomething = widget.heading.isNotEmpty ||
        widget.para.isNotEmpty ||
        widget.image.isNotEmpty;
    bool isSvg = false;
    if (widget.image.isNotEmpty) {
      isSvg = widget.image.substring(widget.image.length - 3) == 'svg'
          ? true
          : false;
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
      height: hasSomething ? null : Screen.height(context) * 0.1,
      width: Screen.width(context),
      padding: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.04),
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
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, '/HomePage',
                            (Route<dynamic> route) => false);
                      }
                    } catch (e) {
                      MyApi.postRequest(
                          endpoint: 'error/application',
                          body: {'error': 'Exceptions: $e'});
                      Navigator.pushNamedAndRemoveUntil(context, '/HomePage',
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: Icon(Icons.chevron_left_outlined,
                      color: MyColors.redonWhite,
                      size: Screen.max(context) * 0.03),
                ),
                Text(
                  'Taqreeb',
                  style: GoogleFonts.montserrat(
                      fontSize: Screen.max(context) * 0.03,
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
                                    textSize: Screen.max(context) * 0.015,
                                    width: Screen.width(context) * 0.3,
                                  ),
                                  ColoredButton(
                                    onPressed: () async {
                                      await MyApi.postRequest(
                                          endpoint: 'notification/DeleteFCM',
                                          body: {
                                            'token': await MyStorage.yourFCM(),
                                          },
                                          headers: {
                                            'Authorization':
                                                'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                                          });
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
                                    width: Screen.width(context) * 0.3,
                                    textSize: Screen.max(context) * 0.015,
                                  ),
                                ]).showDialogBox(context);
                          } else if (currentRoute == '/InvitationCardEdit') {
                          } else {
                            Navigator.pushNamed(context, '/settings');
                          }
                        },
                        child: Icon(widget.icon,
                            color: MyColors.redonWhite,
                            size: Screen.max(context) * 0.03),
                      ),
              ],
            ),
          ),
          widget.heading.isNotEmpty
              ? Column(children: [
                  SizedBox(height: Screen.height(context) * 0.02),
                  Text(
                    widget.heading,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.025,
                        fontWeight: FontWeight.w700,
                        color: MyColors.Yellow),
                  ),
                  SizedBox(
                      height: widget.para.isNotEmpty || widget.image.isNotEmpty
                          ? Screen.height(context) * 0.01
                          : Screen.height(context) * 0.03),
                ])
              : Container(),
          widget.para.isNotEmpty
              ? Column(children: [
                  SizedBox(height: Screen.height(context) * 0.005),
                  Text(
                    widget.para,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.013,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white),
                  ),
                  SizedBox(
                      height: widget.image.isNotEmpty
                          ? Screen.height(context) * 0.01
                          : Screen.height(context) * 0.03),
                ])
              : Container(),
          widget.image.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: Screen.height(context) * 0.01),
                    SizedBox(height: Screen.height(context) * 0.03),
                    isSvg
                        ? SvgPicture.asset(widget.image,
                            height: Screen.height(context) * 0.2)
                        : Image.asset(widget.image,
                            height: Screen.height(context) * 0.2),
                    SizedBox(height: Screen.height(context) * 0.03),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
