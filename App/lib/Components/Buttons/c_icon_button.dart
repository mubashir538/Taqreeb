import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class IconedButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? onPressed;

  const IconedButton(
      {required this.text,
      required this.onPressed,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Center(
        child: Container(
          height: Screen.height(context) * 0.06,
          width: Screen.width(context) * 0.9,
          margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
          padding:
              EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
          decoration: BoxDecoration(
            color: MyColors.DarkLighter,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(icon, height: Screen.max(context) * 0.03),
            SizedBox(
              width: Screen.max(context) * 0.02,
            ),
            Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.015,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
