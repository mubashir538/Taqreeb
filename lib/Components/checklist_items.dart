import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class GuideButton extends StatelessWidget {
  final String text;
  final String leftIconPath; 
  final String rightIconPath; 

  const GuideButton({
    Key? key,
    required this.text,
    required this.leftIconPath,
    required this.rightIconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width *
            0.9, 
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(12), 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SvgPicture.asset(
                leftIconPath,
                width: 24,
                height: 24,
                color: const Color(0xffEDF2F4), 
              ),
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffEDF2F4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SvgPicture.asset(
                rightIconPath,
                width: 24,
                height: 24,
                color: const Color(0xffEDF2F4), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
