import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHeaderHeight();
    });
    fetchData();
  }

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    final fetchedtype = await MyApi.getRequest(
      endpoint: 'searchType/$userid',
      headers: {'Authorization': 'Bearer $token'},
    );
    final isbusinessToken = await MyStorage.exists(MyTokens.isBusinessOwner);
    final isFreelancerToken = await MyStorage.exists(MyTokens.isFreelancer);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          types = fetchedtype ?? {};
          if (types == {} || types['status'] == 'error') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Something Went Wrong!',
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: MyColors.white,
                      fontWeight: FontWeight.w400)),
              backgroundColor: MyColors.red,
            ));
            return;
          } else {
            businessOwnerSwitch = bool.parse(isbusinessToken.toString());
            freelancerSwitch = bool.parse(isFreelancerToken.toString());
            isLoading = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: _headerHeight),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                //   child:
                //       SearchBox(controller: controller, width: screenWidth * 0.9),
                // ),
                // SizedBox(
                //   height: screenHeight * 0.025,
                // ),
                isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
                      )
                    : Container(
                        constraints:
                            BoxConstraints(minHeight: screenHeight * 0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            this.types['business']
                                ? Container(
                                    height:
                                        (MaximumThing * 0.08).clamp(60, 80.0),
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      color: MyColors.DarkLighter,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: MyColors.DarkLighter),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.business_rounded,
                                          color: MyColors.white,
                                          size: MaximumThing * 0.02,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "Business Owner Mode",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                fontSize: MaximumThing * 0.015,
                                                fontWeight: FontWeight.w500,
                                                color: MyColors.white,
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
                                    height:
                                        (MaximumThing * 0.08).clamp(60, 80.0),
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      color: MyColors.DarkLighter,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: MyColors.DarkLighter),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.business_rounded,
                                          color: MyColors.white,
                                          size: MaximumThing * 0.02,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "Freelancer Mode",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                fontSize: MaximumThing * 0.015,
                                                fontWeight: FontWeight.w500,
                                                color: MyColors.white,
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
                                          MyColors.switchTheme();
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
                              text: 'Apperence',
                              leftIcon: Icons.palette_rounded,
                              rightIcon: Icons.arrow_forward_ios_rounded,
                            ),
                            GuideButton(
                              onpressed: () {
                                Navigator.pushNamed(
                                    context, '/AccountInfoEdit');
                              },
                              text: 'Edit Account Info',
                              leftIcon: Icons.edit_rounded,
                              rightIcon: Icons.arrow_forward_ios_rounded,
                            ),
                            // GuideButton(
                            //   onpressed: () {},
                            //   text: 'Help & Support',
                            //   leftIcon: Icons.help_rounded,
                            //   rightIcon: Icons.arrow_forward_ios_rounded,
                            // ),
                            // GuideButton(
                            //   onpressed: () {},
                            //   text: 'About',
                            //   leftIcon: Icons.info_rounded,
                            //   rightIcon: Icons.arrow_forward_ios_rounded,
                            // ),
                            // GuideButton(
                            //   onpressed: () {},
                            //   text: 'Terms and Conditions',
                            //   leftIcon: Icons.privacy_tip_rounded,
                            //   rightIcon: Icons.arrow_forward_ios_rounded,
                            // ),
                          ],
                        ),
                      )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Settings',
              icon: Icons.logout_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
