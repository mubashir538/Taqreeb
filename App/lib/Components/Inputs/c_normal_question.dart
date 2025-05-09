import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/utils/color.dart';

// ignore: must_be_immutable
class NormalQuestion extends StatelessWidget {
  NormalQuestion({super.key, required this.question});

  final String question;

  final TextEditingController answerController = TextEditingController();
  FocusNode answerFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
            child: Text(
              question,
              style: GoogleFonts.montserrat(
                  color: MyColors.white, fontSize: Screen.max(context) * 0.018),
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
