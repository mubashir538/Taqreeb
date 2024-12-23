import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Settings',
              icon: Icons.logout_rounded,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
            //   child:
            //       SearchBox(controller: controller, width: screenWidth * 0.9),
            // ),
            // SizedBox(
            //   height: screenHeight * 0.025,
            // ),
            Container(
              constraints: BoxConstraints(minHeight: screenHeight * 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GuideButton(
                    onpressed: () {
                      Navigator.pushNamed(context, '/BusinessSignup_BasicInfo');
                    },
                    text: 'Signup As Business',
                    leftIcon: Icons.business_rounded,
                    rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                  GuideButton(
                    onpressed: () {
                      Navigator.pushNamed(
                          context, '/FreelancerSignup_BasicInfo');
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
                                setState(() {
                                  MyColors.switchTheme();
                                });
                                setState(() {
                                  MyColors.switchTheme();
                                });
                                Navigator.pop(context);
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
                      Navigator.pushNamed(context, '/AccountInfoEdit');
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
    );
  }
}
