import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

// ignore: must_be_immutable
class NormalQuestion extends StatelessWidget {
  NormalQuestion(
      {super.key, required this.MaximumThing, required this.question});

  final String question;
  final double MaximumThing;
  
  final TextEditingController answerController = TextEditingController();
  FocusNode answerFocus = FocusNode();


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
          MyTextBox(
            hint: "Type your answer here",
            valueController: answerController,
          ),
        ],
      ),
    );
  }
}
