import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/guide_icon.dart';
import 'package:taqreeb/theme/icons.dart';

class GuideScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Header(
                  heading: 'Guide',
                ),
                SizedBox(height: 10),
                SearchBox(
                  onChanged: (value) {},
                  controller: searchController,
                  hint: 'Search Typing to Search',
                ),
                SizedBox(height: 20),
                Text(
                  'or browse through our options to get the help you need.',
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.Arena, text: 'Venue Selection'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.restaurantMenu,
                          text: 'Menu Planning'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.accounts,
                          text: 'Guest List & Invitations'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.foryou, text: 'Budgeting'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.management,
                          text: 'Vendor Management'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.confetti, text: 'Decor & Themes'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.Camera,
                          text: 'Photography & Videography'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.lovePath,
                          text: 'Honeymoon Planning'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GuideIcon(
                          iconPath: MyIcons.weddingCake,
                          text: 'Cakes & Desserts'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
