import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/color.dart';

class HelpCenterScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: 'Help Center',
            ),
            const SizedBox(height: 10.0),

            Text(
              "or browse through our options to get the help you need.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16.0),

            // Image
            SvgPicture.asset(
              'assets/images/helpcenter.svg',
              height: 150,
            ),
            const SizedBox(height: 32.0),

            GuideButton(
              text: 'Guide',
              leftIconPath: 'assets/icons/guide.svg',
              rightIconPath: 'assets/icons/sortarrow.svg',
            ),
            const SizedBox(height: 16.0),

            GuideButton(
              text: 'FAQ',
              leftIconPath: 'assets/icons/faq.svg',
              rightIconPath: 'assets/icons/sortarrow.svg',
            ),
            const SizedBox(height: 16.0),

            GuideButton(
              text: 'Customer Support',
              leftIconPath: 'assets/icons/people.svg',
              rightIconPath: 'assets/icons/sortarrow.svg',
            ),
          ],
        ),
      ),
    );
  }
}
