import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Checklist%20Items%20Adder.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

// ignore: must_be_immutable
class CreateChecklistItems extends StatefulWidget {
  CreateChecklistItems({super.key});
  List<String> categories = [
    "Venue",
    "Catering",
    "Decoration",
    "Entertainment",
    "Photography",
    "Catering",
    "Decoration",
    "Entertainment",
    "Photography",
  ];
  @override
  State<CreateChecklistItems> createState() => _CreateChecklistItems();
}

class _CreateChecklistItems extends State<CreateChecklistItems> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // double MaximumThing =
    //     screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
        backgroundColor: MyColors.Dark,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(
                    heading: "Create CheckList",
                    para: "From to-do to done one check at a time!",
                    image: MyImages.CheckList,
                  ),

                  ListView.builder(
                    itemBuilder: (context, index) => ChecklistItemsAdder(
                        text: widget.categories[index], add: true),
                  ),

                  SizedBox(
                    height: screenHeight * 0.1,
                    child: Center(child: MyDivider()),
                  ),

                  //Checklist Items
                  Column(
                    children: [
                      GuideButton(
                        onpressed: () {},
                        text: 'Venu Selection',
                        leftIconPath: MyIcons.guide,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(height: 10),
                      GuideButton(
                        onpressed: () {},
                        text: 'Menu Planning',
                        leftIconPath: MyIcons.faq,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(height: 10),
                      GuideButton(
                        onpressed: () {},
                        text: 'GuestList and Invitations',
                        leftIconPath: MyIcons.people,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GuideButton(
                        onpressed: () {},
                        text: 'Budgeting',
                        leftIconPath: MyIcons.guide,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(height: 10),
                      GuideButton(
                        onpressed: () {},
                        text: 'Vendor Management',
                        leftIconPath: MyIcons.people,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(height: 10),
                      GuideButton(
                        onpressed: () {},
                        text: 'Decor and Themes',
                        leftIconPath: MyIcons.faq,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Icon(Icons.arrow_back),
                  SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        ));
  }
}
