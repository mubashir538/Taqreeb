import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/utils/color.dart';

class QuestionGroup extends StatelessWidget {
  final List<Widget> questions;
  final String heading;
  const QuestionGroup(
      {super.key, required this.questions, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Screen.max(context) * 0.02,
              vertical: Screen.max(context) * 0.02),
          child: Text(
            heading,
            style: GoogleFonts.roboto(
                color: MyColors.yellow,
                fontWeight: FontWeight.w500,
                fontSize: Screen.max(context) * 0.02),
          ),
        ),
        for (var question in questions) question,
        SizedBox(
          height: Screen.height(context) * 0.04,
          child: Center(child: MyDivider()),
        ),
      ],
    );
  }
}
