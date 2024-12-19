import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/icons.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextEditingController controller = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Settings',
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child:
                  SearchBox(controller: controller, width: screenWidth * 0.9),
            ),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            Container(
              constraints: BoxConstraints(minHeight: screenHeight * 0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GuideButton(
                    text: 'Signup As Business',
                    leftIcon: Icons.business_rounded,
                    rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                  GuideButton(
                    text: 'Signup As Freelancer',
                  leftIcon: Icons.work_outline_rounded,
                  rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                  GuideButton(
                    text: 'Apperence',
                    leftIcon: Icons.palette_rounded,
                  rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                  GuideButton(
                    text: 'Privacy & Security',
                    leftIcon: Icons.privacy_tip_rounded,
                  rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                  GuideButton(
                    text: 'Help & Support',
                    leftIcon: Icons.help_rounded,
                  rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                  GuideButton(
                    text: 'About',
                    leftIcon: Icons.info_rounded,
                  rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                  GuideButton(
                    text: 'Terms and Conditions',
                    leftIcon: Icons.privacy_tip_rounded,
                  rightIcon: Icons.arrow_forward_ios_rounded,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
