import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class ChecklistItemsAdder extends StatelessWidget {
  final String text;
  final bool add;
  const ChecklistItemsAdder({super.key, required this.text, this.add = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: EdgeInsets.all(Screen.max(context) * 0.01),
          padding: EdgeInsets.symmetric(
              horizontal: Screen.width(context) * 0.08,
              vertical: Screen.height(context) * 0.01),
          height: Screen.height(context) * 0.05,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: MyColors.whiteDarker,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text,
                  style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w500,
                      color: MyColors.whiteDarker)),
              add
                  ? Icon(
                      Icons.add,
                      color: MyColors.whiteDarker,
                    )
                  : Container(),
            ],
          )),
    );
  }
}
