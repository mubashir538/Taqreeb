import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/screen_size.dart';

class Header extends StatefulWidget {
  final String heading;
  final IconData icon;
  final String para;
  final String image;

  const Header({
    this.icon = Icons.settings,
    this.heading = '',
    this.para = '',
    this.image = '',
    super.key,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _noSettings = false;
  bool _noBack = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkCurrentRoute();
  }

  void _checkCurrentRoute() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    const noSettingsRoutes = {
      '/Login',
      '/BasicSignup',
      '/Signup_ContactOTPSend',
      '/Signup_ContactOTPVerify',
      '/Signup_EmailOTPSend',
      '/Signup_EmailOTPVerify',
      '/Signup_MoreInfo',
      '/ProfilePictureUpload',
      '/BusinessSignup_BasicInfo',
      '/BusinessSignup_CNICUpload',
      '/BusinessSignup_Description',
      '/SubmissionSucessful',
      '/ForgotPassword_EmailorPhoneInput',
      '/ForgotPassword_VerifyCode',
      '/ForgotPassword_NewPassword',
    };

    const noBackRoutes = {
      '/Login',
      '/BasicSignup',
      '/ForgotPassword_EmailorPhoneInput',
      '/ForgotPassword_VerifyCode',
      '/ForgotPassword_NewPassword',
      '/SubmissionSucessful',
      '/HomePage',
      '/YourEvents',
      '/YourListings',
      '/AccountInfo',
      '/BusinessAccountInfo',
      '/ChatsScreen',
    };
    setState(() {
      _noSettings = noSettingsRoutes.contains(currentRoute);
      _noBack = noBackRoutes.contains(currentRoute);
    });
  }

  Future<void> _handleLogout() async {
    await MyApi.postRequest(
      endpoint: 'notification/DeleteFCM',
      body: {'token': await MyStorage.yourFCM()},
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
    );

    await Future.wait([
      MyStorage.deleteToken(MyTokens.refreshToken),
      MyStorage.deleteToken(MyTokens.accessToken),
      MyStorage.deleteToken(MyTokens.userId),
      MyStorage.deleteToken(MyTokens.userType),
      MyStorage.deleteToken(MyTokens.isBusinessOwner),
    ]);
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/Login',
        (Route<dynamic> route) => false,
      );
    }
  }

  void _showLogoutDialog() {
    WarningDialog(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      actions: [
        ColoredButton(
          onPressed: () => Navigator.pop(context),
          text: 'Cancel',
          textSize: Screen.max(context) * 0.015,
          width: Screen.width(context) * 0.3,
        ),
        ColoredButton(
          onPressed: () async {
            await MyApi.cacheManager.emptyCache();
            await _handleLogout();
          },
          text: 'Logout',
          width: Screen.width(context) * 0.3,
          textSize: Screen.max(context) * 0.015,
        ),
      ],
    ).showDialogBox(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.heading.isNotEmpty ||
        widget.para.isNotEmpty ||
        widget.image.isNotEmpty;
    final isSvg = widget.image.endsWith('.svg');

    return Container(
      height: hasContent ? null : Screen.height(context) * 0.1,
      width: Screen.width(context),
      padding: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.04),
      decoration: BoxDecoration(
        color: MyColors.red,
        borderRadius: hasContent
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : BorderRadius.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _noBack
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: () async {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            await MyApi.cacheManager.emptyCache();
                          }
                        },
                        child: Icon(
                          Icons.chevron_left_outlined,
                          color: MyColors.redonWhite,
                          size: Screen.max(context) * 0.03,
                        ),
                      ),
                Text(
                  'Taqreeb',
                  style: GoogleFonts.montserrat(
                    fontSize: Screen.max(context) * 0.03,
                    fontWeight: FontWeight.w500,
                    color: MyColors.redonWhite,
                  ),
                ),
                _noSettings
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: () {
                          if (ModalRoute.of(context)?.settings.name ==
                              '/Settings') {
                            _showLogoutDialog();
                          } else {
                            Navigator.pushNamed(context, '/Settings');
                          }
                        },
                        child: Icon(
                          widget.icon,
                          color: MyColors.redonWhite,
                          size: Screen.max(context) * 0.03,
                        ),
                      ),
              ],
            ),
          ),
          if (widget.heading.isNotEmpty) ...[
            SizedBox(height: Screen.height(context) * 0.02),
            Text(
              widget.heading,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.w700,
                color: MyColors.Yellow,
              ),
            ),
            SizedBox(
              height: widget.para.isNotEmpty || widget.image.isNotEmpty
                  ? Screen.height(context) * 0.01
                  : Screen.height(context) * 0.03,
            ),
          ],
          if (widget.para.isNotEmpty) ...[
            SizedBox(height: Screen.height(context) * 0.005),
            Text(
              widget.para,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.013,
                fontWeight: FontWeight.w400,
                color: MyColors.white,
              ),
            ),
            SizedBox(
              height: widget.image.isNotEmpty
                  ? Screen.height(context) * 0.01
                  : Screen.height(context) * 0.03,
            ),
          ],
          if (widget.image.isNotEmpty) ...[
            SizedBox(height: Screen.height(context) * 0.01),
            SizedBox(height: Screen.height(context) * 0.03),
            isSvg
                ? SvgPicture.asset(
                    widget.image,
                    height: Screen.height(context) * 0.2,
                  )
                : Image.asset(
                    widget.image,
                    height: Screen.height(context) * 0.2,
                  ),
            SizedBox(height: Screen.height(context) * 0.03),
          ],
        ],
      ),
    );
  }
}
