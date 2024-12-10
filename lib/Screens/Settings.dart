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
            GuideButton(
              text: 'Account',
              leftIconPath: MyIcons.guide,
              rightIconPath: MyIcons.sortArrow,
            ),
            SizedBox(
              height: screenHeight * 0.025,
              child: MyDivider(),
            ),
            GuideButton(
              text: 'Notifications',
              leftIconPath: MyIcons.guide,
              rightIconPath: MyIcons.sortArrow,
            ),
            SizedBox(
              height: screenHeight * 0.025,
              child: MyDivider(),
            ),
            GuideButton(
              text: 'Apperence',
              leftIconPath: MyIcons.guide,
              rightIconPath: MyIcons.sortArrow,
            ),
            SizedBox(
              height: screenHeight * 0.025,
              child: MyDivider(),
            ),
            GuideButton(
              text: 'Privacy & Security',
              leftIconPath: MyIcons.guide,
              rightIconPath: MyIcons.sortArrow,
            ),
            SizedBox(
              height: screenHeight * 0.025,
              child: MyDivider(),
            ),
            GuideButton(
              text: 'Help & Support',
              leftIconPath: MyIcons.guide,
              rightIconPath: MyIcons.sortArrow,
            ),
            SizedBox(
              height: screenHeight * 0.025,
              child: MyDivider(),
            ),
            GuideButton(
              text: 'About',
              leftIconPath: MyIcons.guide,
              rightIconPath: MyIcons.sortArrow,
            ),
          ],
        ),
      ),
    );
  }
}
