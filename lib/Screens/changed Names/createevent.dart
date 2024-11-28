import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20AI%20Package/Components/question%20group.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  double _currentBudgetValue = 100000;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: "Create Event",
              para: "Plan your event effortlessly!",
              image: MyImages.SingupPng,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  QuestionGroup(questions: [
                    MyTextBox(hint: "Event Name"),
                    MyTextBox(hint: "Event Type"),
                    MyTextBox(hint: "Set Date"),
                    MyTextBox(hint: "Location"),
                  ], Heading: "Basic Info"),
                  QuestionGroup(questions: [
                    SizedBox(
                      height: screenHeight * 0.2,
                      child: MyTextBox(
                        hint: "Enter Description",
                      ),
                    ),
                  ], Heading: "Describe Your Event"),
                  QuestionGroup(questions: [
                    MyTextBox(hint: "Name"),
                    MyTextBox(hint: "Contact"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.add,
                          color: MyColors.white,
                          size: MaximumThing * 0.03,
                        ),
                      ],
                    )
                  ], Heading: "Guest List"),
                  QuestionGroup(questions: [
                    MyTextBox(
                      hint: "Enter Budget",
                    ),
                  ], Heading: "Budget")
                ],
              ),
            ),
            ColoredButton(
              text: "Create Event",
            ),
          ],
        ),
      ),
    );
  }
}
