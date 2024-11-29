import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class NormalQuestion extends StatelessWidget {
  const NormalQuestion(
      {super.key, required this.MaximumThing, required this.question});

  final String question;
  final double MaximumThing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MaximumThing * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
            child: Text(
              question,
              style: GoogleFonts.montserrat(
                  color: MyColors.white, fontSize: MaximumThing * 0.018),
            ),
          ),
          MyTextBox(hint: "Type your answer here"),
        ],
      ),
    );
  }
}
