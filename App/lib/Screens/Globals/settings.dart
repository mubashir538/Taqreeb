import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/core/providers/ThemeProvider.dart';
import 'package:taqreeb/core/services/api_calls.dart';
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
      UI_Management.getHeaderHeight(
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
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Get the ThemeProvider

    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? MyColors.Dark
          : MyColors.white, // Use theme-based colors
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: UI_Management.headerHeight),
                isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
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
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? MyColors.DarkLighter
                                          : MyColors.whiteDarker,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? MyColors.DarkLighter
                                              : MyColors.whiteDarker),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.business_rounded,
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? MyColors.white
                                              : MyColors.Dark,
                                          size: Screen.max(context) * 0.02,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "Business Owner Mode",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                fontSize:
                                                    Screen.max(context) * 0.015,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    themeProvider.themeMode ==
                                                            ThemeMode.dark
                                                        ? MyColors.white
                                                        : MyColors.Dark,
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
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/HomePage',
                                                ModalRoute.withName('/'),
                                              );
                                            });
                                          },
                                          activeColor: MyColors.white,
                                          activeTrackColor: MyColors.green,
                                          inactiveThumbColor: MyColors.white,
                                          inactiveTrackColor: MyColors.red,
                                        ),
                                      ],
                                    ),
                                  )
                                : GuideButton(
                                    onpressed: () {
                                      Navigator.pushNamed(
                                          context, '/BusinessSignup_BasicInfo');
                                    },
                                    text: 'Signup As Business',
                                    leftIcon: Icons.business_rounded,
                                    rightIcon: Icons.arrow_forward_ios_rounded,
                                  ),
                            this.types['freelancer']
                                ? Container(
                                    height: (Screen.max(context) * 0.08)
                                        .clamp(60, 80.0),
                                    width: Screen.width(context) * 0.9,
                                    decoration: BoxDecoration(
                                      color: themeProvider.themeMode ==
                                              ThemeMode.dark
                                          ? MyColors.DarkLighter
                                          : MyColors.whiteDarker,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? MyColors.DarkLighter
                                              : MyColors.whiteDarker),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.business_rounded,
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? MyColors.white
                                              : MyColors.Dark,
                                          size: Screen.max(context) * 0.02,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "Freelancer Mode",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                fontSize:
                                                    Screen.max(context) * 0.015,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    themeProvider.themeMode ==
                                                            ThemeMode.dark
                                                        ? MyColors.white
                                                        : MyColors.Dark,
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
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/HomePage',
                                                ModalRoute.withName('/'),
                                              );
                                            });
                                          },
                                          activeColor: MyColors.white,
                                          activeTrackColor: MyColors.green,
                                          inactiveThumbColor: MyColors.white,
                                          inactiveTrackColor: MyColors.red,
                                        ),
                                      ],
                                    ),
                                  )
                                : GuideButton(
                                    onpressed: () {
                                      Navigator.pushNamed(context,
                                          '/FreelancerSignup_BasicInfo');
                                    },
                                    text: 'Signup As Freelancer',
                                    leftIcon: Icons.work_outline_rounded,
                                    rightIcon: Icons.arrow_forward_ios_rounded,
                                  ),
                            GuideButton(
                              onpressed: () {
                                warningDialog(
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
                                          themeProvider
                                              .switchTheme(); // Use ThemeProvider
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
                              leftIcon: Icons.palette_rounded,
                              rightIcon: Icons.arrow_forward_ios_rounded,
                            ),
                            GuideButton(
                              onpressed: () {
                                Navigator.pushNamed(
                                    context,
                                    businessOwnerSwitch || freelancerSwitch
                                        ? '/BusinessInfoEdit'
                                        : '/AccountInfoEdit');
                              },
                              text: 'Edit Account Info',
                              leftIcon: Icons.edit_rounded,
                              rightIcon: Icons.arrow_forward_ios_rounded,
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Settings',
              icon: Icons.logout_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
