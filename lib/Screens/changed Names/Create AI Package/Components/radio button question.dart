import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class RadioButtonQuestion extends StatefulWidget {
  RadioButtonQuestion(
      {super.key,
      required this.options,
      required this.question,
      required this.myValue});
  final String question;
  final List<String> options;
  String? myValue;

  @override
  State<RadioButtonQuestion> createState() => _RadioButtonQuestionState();
}

class _RadioButtonQuestionState extends State<RadioButtonQuestion> {
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
          widget.options.length > 2
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (var option in widget.options)
                    RadioListTile<String>(
                      title: Text(option,
                          style: GoogleFonts.montserrat(
                            color: MyColors.whiteDarker,
                            fontWeight: FontWeight.w300,
                            fontSize: MaximumThing * 0.015,
                          )),
                      value: option,
                      groupValue: widget.myValue,
                      onChanged: (String? value) {
                        setState(() {
                          widget.myValue = value;
                        });
                      },
                      activeColor: MyColors.Yellow,
                    ),
                ])
              : Row(
                  children: [
                    for (var option in widget.options)
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(option,
                              style: GoogleFonts.montserrat(
                                color: MyColors.whiteDarker,
                                fontWeight: FontWeight.w300,
                                fontSize: MaximumThing * 0.015,
                              )),
                          value: option,
                          groupValue: widget.myValue,
                          onChanged: (String? value) {
                            setState(() {
                              widget.myValue = value;
                            });
                          },
                          activeColor: MyColors.Yellow,
                        ),
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
