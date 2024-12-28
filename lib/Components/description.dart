import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class DescriptionBox extends StatefulWidget {
  const DescriptionBox({
    super.key,
    this.value = '',
    this.focusNode,
    this.onFieldSubmitted,
    required this.valueController,
    this.onChanged, // Added onChanged callback
  });

  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final String value;
  final TextEditingController valueController;
  final Function(String)? onChanged; // Callback for text changes

  @override
  State<DescriptionBox> createState() => _DescriptionStateBox();
}

class _DescriptionStateBox extends State<DescriptionBox> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      margin: EdgeInsets.all(maximumDimension * 0.01),
      height: screenHeight * 0.3,
      width: screenWidth * 0.9,
      padding: EdgeInsets.symmetric(
          horizontal: maximumDimension * 0.03,
          vertical: maximumDimension * 0.02),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: TextField(
        focusNode: widget.focusNode,
        onSubmitted: widget.onFieldSubmitted,
        controller: widget.valueController, // Bind controller
        onChanged: (value) => widget.onChanged!(value),
        maxLines: 50,
        style: GoogleFonts.montserrat(
          color: MyColors.white,
          fontSize: maximumDimension * 0.015,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: GoogleFonts.montserrat(
            color: MyColors.white.withOpacity(0.6),
            fontSize: maximumDimension * 0.015,
            fontWeight: FontWeight.w300,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.red),
          ),
          hintText: "Enter Description",
        ),
      ),
    );
  }
}
