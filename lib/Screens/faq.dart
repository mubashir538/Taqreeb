import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class FaqScreen extends StatelessWidget {
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
                heading: 'FAQ',
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
                'Find quick answers to common questions about wedding planning using our app.',
                style: TextStyle(
                  color: MyColors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GuideButton(
                text: 'Venue Selection',
                leftIconPath: MyIcons.guide,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                text: 'Menu Planning',
                leftIconPath: MyIcons.restaurantMenu,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                text: 'Guest List & Invitations',
                leftIconPath: MyIcons.people,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                text: 'Budgeting',
                leftIconPath: MyIcons.management,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                text: 'Vendor Management',
                leftIconPath: MyIcons.people,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                text: 'Decor & Themes',
                leftIconPath: MyIcons.confetti,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
