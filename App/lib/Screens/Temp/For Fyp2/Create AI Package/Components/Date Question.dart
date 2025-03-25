import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class DateQuestion extends StatefulWidget {
  final TextEditingController valuecontroller;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final String question;
  const DateQuestion({
    super.key,
    required this.question,
    required this.valuecontroller,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  State<DateQuestion> createState() => _DateQuestionState();
}

class _DateQuestionState extends State<DateQuestion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.question != '' ? Screen.max(context) * 0.02 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.question != ''
              ? Text(widget.question,
                  style: GoogleFonts.montserrat(
                      color: MyColors.white,
                      fontSize: Screen.max(context) * 0.018))
              : Container(),
          Container(
            margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
            height: Screen.height(context) * 0.06,
            width: Screen.width(context) * 0.9,
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(2, 2))
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) * 0.02),
              child: TextField(
                readOnly: true,
                focusNode: widget.focusNode,
                onSubmitted: widget.onFieldSubmitted,
                textAlignVertical: TextAlignVertical.center,
                controller: widget.valuecontroller,
                style: GoogleFonts.montserrat(
                  fontSize: Screen.max(context) * 0.018,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.date_range_rounded),
                  hintText: 'Select Date',
                  hintStyle: GoogleFonts.montserrat(
                    color: MyColors.white.withOpacity(0.6),
                    fontSize: Screen.max(context) * 0.015,
                  ),
                  border: InputBorder.none,
                ),
                onTap: () => _selectDate(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      setState(() {
        widget.valuecontroller.text = pickedDate.toString().split(" ")[0];
      });
    }
  }
}
