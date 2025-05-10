import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

// ignore: must_be_immutable
class RadioButtonQuestion extends StatefulWidget {
  RadioButtonQuestion({
    super.key,
    required this.options,
    required this.question,
    required this.myValue,
    required this.onChanged,
  });

  final String question;
  final List<String> options;
  String? myValue;
  final Function(String?) onChanged;

  @override
  State<RadioButtonQuestion> createState() => _RadioButtonQuestionState();
}

class _RadioButtonQuestionState extends State<RadioButtonQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.question == ''
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Screen.max(context) * 0.01),
                  child: Text(widget.question,
                      style: GoogleFonts.montserrat(
                          color: MyColors.white,
                          fontSize: Screen.max(context) * 0.018)),
                ),
          widget.options.length > 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var option in widget.options)
                      RadioListTile<String>(
                        title: Text(option,
                            style: GoogleFonts.montserrat(
                              color: MyColors.whiteDarker,
                              fontWeight: FontWeight.w300,
                              fontSize: Screen.max(context) * 0.015,
                            )),
                        value: option,
                        groupValue: widget.myValue,
                        onChanged: (String? value) {
                          setState(() {
                            widget.myValue = value;
                          });
                          widget.onChanged(value);
                        },
                        activeColor: MyColors.yellow,
                      ),
                  ],
                )
              : Row(
                  children: [
                    for (var option in widget.options)
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(option,
                              style: GoogleFonts.montserrat(
                                color: MyColors.whiteDarker,
                                fontWeight: FontWeight.w300,
                                fontSize: Screen.max(context) * 0.015,
                              )),
                          value: option,
                          groupValue: widget.myValue,
                          onChanged: (String? value) {
                            setState(() {
                              widget.myValue = value;
                            });
                            widget.onChanged(value);
                          },
                          activeColor: MyColors.yellow,
                        ),
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
