import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class DescriptionBox extends StatefulWidget {
  const DescriptionBox({
    super.key,
    this.value = '',
    this.focusNode,
    this.onFieldSubmitted,
    required this.valueController,
    this.onChanged,
  });

  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final String value;
  final TextEditingController valueController;
  final Function(String)? onChanged;

  @override
  State<DescriptionBox> createState() => _DescriptionStateBox();
}

class _DescriptionStateBox extends State<DescriptionBox> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      height: Screen.height(context) * 0.3,
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(
          horizontal: Screen.max(context) * 0.03,
          vertical: Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        border: Border.all(
          color: _isFocused ? MyColors.red : Colors.transparent,
          width: 2,
        ),
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
        focusNode: _focusNode,
        onSubmitted: widget.onFieldSubmitted,
        controller: widget.valueController,
        onChanged: (value) => widget.onChanged!(value),
        maxLines: 50,
        style: GoogleFonts.montserrat(
          color: MyColors.white,
          fontSize: Screen.max(context) * 0.015,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: GoogleFonts.montserrat(
            color: MyColors.white.withOpacity(0.6),
            fontSize: Screen.max(context) * 0.015,
            fontWeight: FontWeight.w300,
          ),
          hintText: "Enter Description",
        ),
      ),
    );
  }
}
