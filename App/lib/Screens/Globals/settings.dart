import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/providers/theme_provider.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Checklist/c_checklist_items.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController controller = TextEditingController();
  String token = '';
  Map<String, dynamic> types = {};
  bool isLoading = true;
  bool businessOwnerSwitch = false;
  bool freelancerSwitch = false;
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
          headerKey: headerKey,
          callback: (renderbox) {
            changeHeight(renderbox);
          });
    });
    fetchData();
  }

  void fetchData() async {
    final isbusinessToken = await MyStorage.exists(MyTokens.isBusinessOwner);
    final isFreelancerToken = await MyStorage.exists(MyTokens.isFreelancer);
    final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    ApiCall.fetchAPI('searchType/$userid', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          token = token;
          types = data;
          businessOwnerSwitch = bool.parse(isbusinessToken.toString());
          freelancerSwitch = bool.parse(isFreelancerToken.toString());
          isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final colors = AppColors(context);

    UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    final mycolors = AppColors(context);
    return Scaffold(
      backgroundColor: mycolors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(height: UImanagement.headerHeight),
                  isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(mycolors.white),
                        )
                      : Container(
                          constraints: BoxConstraints(
                              minHeight: Screen.height(context) * 0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              types['business']
                                  ? Container(
                                      height: (Screen.max(context) * 0.08)
                                          .clamp(60, 80.0),
                                      width: Screen.width(context) * 0.9,
                                      decoration: BoxDecoration(
                                        color: colors.lightDark,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.building,
                                            color: colors.white,
                                            size: Screen.max(context) * 0.02,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                "Business Owner Mode",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                  fontSize:
                                                      Screen.max(context) *
                                                          0.015,
                                                  fontWeight: FontWeight.w500,
                                                  color: colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Switch(
                                            value: businessOwnerSwitch,
                                            onChanged: (value) {
                                              setState(() {
                                                businessOwnerSwitch = value;
                                                if (businessOwnerSwitch) {
                                                  MyStorage.saveToken(
                                                    value.toString(),
                                                    MyTokens.isBusinessOwner,
                                                  );
                                                  MyStorage.deleteToken(
                                                    MyTokens.isFreelancer,
                                                  );
                                                  setState(() {
                                                    freelancerSwitch = false;
                                                  });
                                                } else {
                                                  MyStorage.deleteToken(
                                                      MyTokens.isBusinessOwner);
                                                }
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  '/HomePage',
                                                  ModalRoute.withName('/'),
                                                );
                                              });
                                            },
                                            activeColor: mycolors.white,
                                            activeTrackColor: mycolors.green,
                                            inactiveThumbColor: mycolors.white,
                                            inactiveTrackColor: mycolors.red,
                                          ),
                                        ],
                                      ),
                                    )
                                  : GuideButton(
                                      onpressed: () {
                                        context.pushNamedTransition(
                                            routeName:
                                                '/BusinessSignup_BasicInfo',
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            duration:
                                                Duration(milliseconds: 300));
                                      },
                                      text: 'Signup As Business',
                                      leftIcon: FontAwesomeIcons.building,
                                      rightIcon: FontAwesomeIcons.chevronRight,
                                    ),
                              types['freelancer']
                                  ? Container(
                                      height: (Screen.max(context) * 0.08)
                                          .clamp(60, 80.0),
                                      width: Screen.width(context) * 0.9,
                                      decoration: BoxDecoration(
                                        color: colors.lightDark,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.building,
                                            color: colors.white,
                                            size: Screen.max(context) * 0.02,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                "Freelancer Mode",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                  fontSize:
                                                      Screen.max(context) *
                                                          0.015,
                                                  fontWeight: FontWeight.w500,
                                                  color: colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Switch(
                                            value: freelancerSwitch,
                                            onChanged: (value) {
                                              setState(() {
                                                freelancerSwitch = value;
                                                if (freelancerSwitch) {
                                                  MyStorage.saveToken(
                                                    value.toString(),
                                                    MyTokens.isFreelancer,
                                                  );
                                                  MyStorage.deleteToken(
                                                    MyTokens.isBusinessOwner,
                                                  );
                                                  setState(() {
                                                    businessOwnerSwitch = false;
                                                  });
                                                } else {
                                                  MyStorage.deleteToken(
                                                      MyTokens.isFreelancer);
                                                }
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  '/HomePage',
                                                  ModalRoute.withName('/'),
                                                );
                                              });
                                            },
                                            activeColor: mycolors.white,
                                            activeTrackColor: mycolors.green,
                                            inactiveThumbColor: mycolors.white,
                                            inactiveTrackColor: mycolors.red,
                                          ),
                                        ],
                                      ),
                                    )
                                  : GuideButton(
                                      onpressed: () {
                                        context.pushNamedTransition(
                                            routeName:
                                                '/FreelancerSignup_BasicInfo',
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            duration:
                                                Duration(milliseconds: 300));
                                      },
                                      text: 'Signup As Freelancer',
                                      leftIcon: FontAwesomeIcons.userTie,
                                      rightIcon: FontAwesomeIcons.chevronRight,
                                    ),
                              GuideButton(
                                onpressed: () {
                                  WarningDialog(
                                    title: 'Switch Theme',
                                    message: 'Change the theme of the App',
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            themeProvider.switchTheme();
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/HomePage',
                                              ModalRoute.withName('/'),
                                            );
                                          },
                                          child: Text('Confirm')),
                                    ],
                                  ).showDialogBox(context);
                                },
                                text: 'Appearance',
                                leftIcon: FontAwesomeIcons.moon,
                                rightIcon: FontAwesomeIcons.chevronRight,
                              ),
                              GuideButton(
                                onpressed: () {
                                  context.pushNamedTransition(
                                      routeName: businessOwnerSwitch ||
                                              freelancerSwitch
                                          ? '/BusinessInfoEdit'
                                          : '/AccountInfoEdit',
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      duration: Duration(milliseconds: 300));
                                },
                                text: 'Edit Account Info',
                                leftIcon: FontAwesomeIcons.pen,
                                rightIcon: FontAwesomeIcons.chevronRight,
                              ),
                              GuideButton(
                                onpressed: () {
                                  _showLogoutDialog();
                                },
                                text: 'Logout',
                                leftIcon:
                                    FontAwesomeIcons.arrowRightFromBracket,
                                rightIcon: FontAwesomeIcons.chevronRight,
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Settings',
              icon: FontAwesomeIcons.arrowRightFromBracket,
            ),
          ),
        ],
      ),
    );
  }
}
