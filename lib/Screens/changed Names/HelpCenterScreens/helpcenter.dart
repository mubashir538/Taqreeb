import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class SupportScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                heading: 'Help Center',
                para: '',
                image: '',
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchBox(controller: searchController),
              ),
              SizedBox(height: 20),
              Text(
                'Or Browse through our options to get the help you need',
                style: TextStyle(
                  color: MyColors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset(
                MyImages.HelpCenter,
                height: screenWidth * 0.5,
              ),
              SizedBox(height: 20),
              GuideButton(
                text: 'Guide',
                leftIconPath: MyIcons.guide,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                text: 'FAQ',
                leftIconPath: MyIcons.faq,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                text: 'Customer Support',
                leftIconPath: MyIcons.people,
                rightIconPath: MyIcons.sortArrow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
