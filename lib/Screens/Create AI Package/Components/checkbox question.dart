import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class CheckBoxQuestion extends StatefulWidget {
  CheckBoxQuestion(
      {super.key,
      required this.question,
      required this.options,
      required this.selections});
  final String question;
  final List<String> options;
  List<String> selections;

  @override
  State<CheckBoxQuestion> createState() => _CheckBoxQuestionState();
}

class _CheckBoxQuestionState extends State<CheckBoxQuestion> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MaximumThing * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
            child: Text(widget.question,
                style: GoogleFonts.montserrat(
                    color: MyColors.white, fontSize: MaximumThing * 0.018)),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var option in widget.options)
              CheckboxListTile(
                title: Text(option,
                    style: GoogleFonts.montserrat(
                      color: MyColors.whiteDarker,
                      fontWeight: FontWeight.w300,
                      fontSize: MaximumThing * 0.015,
                    )),
                value: widget.selections.contains(option),
                onChanged: (bool? value) {
                  setState(() {
                    if (value ?? false) {
                      widget.selections.add(option);
                    } else {
                      widget.selections.remove(option);
                    }
                  });
                },
                activeColor: MyColors.Yellow,
                checkColor: Colors.black,
              )
          ])
        ],
      ),
    );
  }
}
