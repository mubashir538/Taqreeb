import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final VoidCallback? onclick;
  final bool isHome;
  final String hint;
  final FocusNode focusNode;
  final Function(String) onChanged;
  const SearchBox(
      {super.key,
      this.isHome = false,
      required this.onChanged,
      required this.hint,
      required this.controller,
      required this.focusNode,
      this.width = 0,
      this.onclick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
        height: Screen.height(context) * 0.07,
        width: width == 0 ? Screen.width(context) * 0.8 : width,
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.02),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.search, color: MyColors.white),
              Container(
                margin: EdgeInsets.only(left: Screen.max(context) * 0.02),
                width: Screen.width(context) * 0.5,
                child: GestureDetector(
                  onTap: onclick,
                  child: TextField(
                    readOnly: isHome ? true : false,
                    focusNode: focusNode,
                    onTap: onclick,
                    controller: controller,
                    onChanged: onChanged,
                    style: GoogleFonts.montserrat(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.015,
                        color: MyColors.whiteDarker,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
