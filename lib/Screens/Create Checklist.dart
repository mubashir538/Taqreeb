import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Checklist%20Items%20Adder.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Iconed%20Button.dart';
import 'package:taqreeb/Components/checklist_items.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class CreateChecklist extends StatelessWidget {
  const CreateChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
        backgroundColor: MyColors.Dark,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(
                    heading: "Create CheckList",
                    para: "From to-do to done –\n" "one check at a time!",
                    image: MyImages.CheckList,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //Checklist Adders
                  Row(
                    children: [
                      ChecklistItemsAdder(text: 'Venue +'),
                      SizedBox(
                        width: 10,
                      ),
                      ChecklistItemsAdder(text: 'Catering +'),
                      SizedBox(
                        width: 10,
                      ),
                      ChecklistItemsAdder(text: 'Photography +'),
                      SizedBox(
                        width: 10,
                      ),
                      ChecklistItemsAdder(text: 'Decorator +'),
                      SizedBox(
                        width: 10,
                      ),
                      ChecklistItemsAdder(text: 'Graphic Designer +'),
                      SizedBox(
                        width: 10,
                      ),
                      ChecklistItemsAdder(text: 'Salon and Spa +'),
                      SizedBox(
                        width: 10,
                      ),
                      ChecklistItemsAdder(text: 'Makeup +'),
                      SizedBox(
                        width: 10,
                      ),
                      ChecklistItemsAdder(text: 'Video Editors'),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //Divider
                  MyDivider(width: screenWidth * 0.3),
                  const SizedBox(height: 20),

                  //Checklist Items
                  Column(
                    children: [
                      GuideButton(
                        text: 'Venu Selection',
                        leftIconPath: MyIcons.guide,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(height: 10),
                      GuideButton(
                        text: 'Menu Planning',
                        leftIconPath: MyIcons.faq,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(height: 10),
                      GuideButton(
                        text: 'GuestList and Invitations',
                        leftIconPath: MyIcons.people,
                        rightIconPath: MyIcons.sortArrow,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GuideButton(
                        text: 'Budgeting',
                        leftIconPath: MyIcons.guide,
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
                  SizedBox(height: 20,),
                ]),
          ),
        ));
  }
}
