import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
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
  final List<HeaderIcon>? additionalIcons;

  const Header({
    this.icon = FontAwesomeIcons.gear,
    this.heading = '',
    this.para = '',
    this.image = '',
    this.additionalIcons,
    super.key,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class HeaderIcon {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  HeaderIcon({
    required this.icon,
    required this.onPressed,
    this.color,
  });
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
      '/ChatBox',
      '/GroupChatBox',
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
    final additionalIcons = widget.additionalIcons?.take(2).toList() ?? [];
    final colors = AppColors(context);

    return Container(
      height: hasContent ? null : Screen.height(context) * 0.1,
      width: Screen.width(context),
      padding: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.04),
      decoration: BoxDecoration(
        color: colors.red,
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
                          FontAwesomeIcons.chevronLeft,
                          color: colors.redonWhite,
                          size: Screen.max(context) * 0.03,
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(
                      left: (Screen.width(context) * 0.02 +
                              Screen.max(context) * 0.03) *
                          additionalIcons.length,
                      right: _noSettings ? Screen.width(context) * 0.03 : 0),
                  child: Text(
                    'Taqreeb',
                    style: GoogleFonts.pacifico(
                      fontSize: Screen.max(context) * 0.03,
                      fontWeight: FontWeight.w500,
                      color: colors.redonWhite,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Additional icons (up to 2)
                    if (additionalIcons.isNotEmpty)
                      ...additionalIcons.map((headerIcon) => Padding(
                            padding: EdgeInsets.only(
                                right: Screen.width(context) * 0.02),
                            child: InkWell(
                              onTap: headerIcon.onPressed,
                              child: Icon(
                                headerIcon.icon,
                                color: headerIcon.color ?? colors.redonWhite,
                                size: Screen.max(context) * 0.03,
                              ),
                            ),
                          )),
                    // Settings icon (if not in noSettingsRoutes)
                    if (!_noSettings)
                      InkWell(
                        onTap: () {
                          if (ModalRoute.of(context)?.settings.name ==
                              '/Settings') {
                            _showLogoutDialog();
                          } else {
                            context.pushNamedTransition(
                                routeName: '/Settings',
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: Duration(milliseconds: 300));
                          }
                        },
                        child: Icon(
                          widget.icon,
                          color: colors.redonWhite,
                          size: Screen.max(context) * 0.03,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.heading.isNotEmpty) ...[
            SizedBox(height: Screen.height(context) * 0.02),
            Text(
              widget.heading,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.w700,
                color: colors.yellow,
              ),
            ),
            SizedBox(
              height: widget.para.isNotEmpty || widget.image.isNotEmpty
                  ? Screen.height(context) * 0.01
                  : Screen.height(context) * 0.03,
            ),
          ],
          if (widget.para.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.all(Screen.max(context) * 0.01),
              width: Screen.width(context) * 0.9,
              child: Text(
                widget.para,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: Screen.max(context) * 0.015,
                  fontWeight: FontWeight.w400,
                  color: colors.white,
                ),
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
            SizedBox(
              width: Screen.width(context) * 0.5, // your fixed width
              height: Screen.height(context) * 0.25, // your fixed height
              child: isSvg
                  ? SvgPicture.asset(
                      widget.image,
                      fit: BoxFit
                          .contain, // scales the SVG to fit within the box
                    )
                  : Image.asset(
                      widget.image,
                      fit: BoxFit
                          .contain, // scales the raster image to fit within the box
                    ),
            ),
            SizedBox(height: Screen.height(context) * 0.03),
          ],
        ],
      ),
    );
  }
}
