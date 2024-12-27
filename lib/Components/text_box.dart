import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:taqreeb/theme/color.dart';

// ignore: must_be_immutable
class MyTextBox extends StatefulWidget {
  final String hint;
  final String Value;
  final bool isPassword;

  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool isNum;
  final bool isPrice;
  final TextEditingController valueController;

  MyTextBox({
    super.key,
    this.isPrice = false,
    this.isNum = false,
    this.isPassword = false,
    required this.hint,
    this.onFieldSubmitted,
    this.focusNode,
    this.Value = '',
    required this.valueController,
  });

  @override
  State<MyTextBox> createState() => _MyTextBoxState();
}

class _MyTextBoxState extends State<MyTextBox> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword; // Initialize based on isPassword
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
      height: screenHeight * 0.06,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(2, 2)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.valueController,
                focusNode: widget.focusNode,
                onSubmitted: widget.onFieldSubmitted,
                obscureText: widget.isPassword ? _isObscured : false,
                keyboardType: widget.isNum
                    ? TextInputType.number
                    : widget.isPrice
                        ? TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                inputFormatters: widget.isNum
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : widget.isPrice
                        ? [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ]
                        : null,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.018,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.montserrat(
                    color: MyColors.white.withOpacity(0.6),
                    fontSize: MaximumThing * 0.015,
                  ),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.red),
                  ),
                ),
              ),
            ),
            if (widget.isPassword)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                child: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: MyColors.white.withOpacity(0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
