import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20AI%20Package/Components/Normal%20Question.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20AI%20Package/Components/Slider%20Question.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20AI%20Package/Components/checkbox%20question.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20AI%20Package/Components/question%20group.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20AI%20Package/Components/radio%20button%20question.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';

class AIPackageScreen extends StatefulWidget {
  @override
  _AIPackageScreenState createState() => _AIPackageScreenState();
}

class _AIPackageScreenState extends State<AIPackageScreen> {
  double _currentBudgetValue = 100000;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MaximumThing * 0.05, bottom: MaximumThing * 0.03),
                child: Text(
                  "Create your AI Package",
                  style: GoogleFonts.montserrat(
                      color: MyColors.Yellow,
                      fontWeight: FontWeight.w600,
                      fontSize: MaximumThing * 0.03),
                ),
              ),
            ),
            QuestionGroup(questions: [
              NormalQuestion(
                  MaximumThing: MaximumThing,
                  question: "What type of eveny you are planning"),
              SliderQuestion(
                  question: "How many guests are you expecting?",
                  start: 50,
                  end: 1000,
                  div: 19,
                  currentCount: 100),
              DateQuestion(question: "What is the date of the event?"),
            ], Heading: "Event Details"),
            QuestionGroup(questions: [
              SliderQuestion(
                  question: "What is your overall budget for this event?",
                  start: 100000,
                  end: 500000,
                  div: 9,
                  currentCount: _currentBudgetValue),
              RadioButtonQuestion(
                  options: ["Yes", "No"],
                  question: "Are you open to flexible pricing options?",
                  myValue: "Yes")
            ], Heading: "Budget"),
            QuestionGroup(questions: [
              NormalQuestion(
                  MaximumThing: MaximumThing,
                  question:
                      "In which city or area would you like to hold the event?"),
              RadioButtonQuestion(
                  options: ["Indoor", "Outdoor", "Mixed"],
                  question: "What type of venue do you prefer?",
                  myValue: "Indoor"),
              RadioButtonQuestion(
                  options: ["Casual", "Formal", "Themed"],
                  question: "What kind of ambiance are you looking for?",
                  myValue: "Casual")
            ], Heading: "Location Preferences"),
            QuestionGroup(questions: [
              CheckBoxQuestion(
                  question: "Do you need any additional services?",
                  options: ["Photography", "Decoration", "Music"],
                  selections: []),
              NormalQuestion(
                  MaximumThing: MaximumThing,
                  question: "Describe the Theme of your event")
            ], Heading: "Entertainment & Extras"),
            SizedBox(height: screenHeight * 0.04),
            Center(
              child: ColoredButton(
                text: "Generate Packages",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
