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
                heading: 'Customer Support',
                para: '',
                image: '',
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchBox(controller: searchController),
              ),
              SizedBox(height: 20),
              Image.asset(
                MyImages.CustomerSupport,
                height: screenWidth * 0.5,
              ),
              SizedBox(height: 20),
              Text(
                'Hello, How can we Help you?',
                style: TextStyle(
                  color: MyColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GuideButton(
                onpressed: (){},
                text: 'Contact Live Chat',
                leftIconPath: MyIcons.communicate,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                onpressed: (){},
                text: 'Send Us an Email',
                leftIconPath: MyIcons.email,
                rightIconPath: MyIcons.sortArrow,
              ),
              SizedBox(height: 10),
              GuideButton(
                onpressed: (){},
                text: 'FAQs',
                leftIconPath: MyIcons.faq,
                rightIconPath: MyIcons.sortArrow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
