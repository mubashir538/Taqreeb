import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class QuestionGroup extends StatelessWidget {
  final List<Widget> questions;
  final String Heading;
  const QuestionGroup(
      {super.key, required this.questions, required this.Heading});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MaximumThing * 0.02, vertical: MaximumThing * 0.02),
          child: Text(
            Heading,
            style: GoogleFonts.montserrat(
                color: MyColors.Yellow,
                fontWeight: FontWeight.w500,
                fontSize: MaximumThing * 0.02),
          ),
        ),
        for (var question in questions) question,
        SizedBox(
          height: screenHeight * 0.04,
          child: Center(child: MyDivider()),
        ),
      ],
    );
  }
}
