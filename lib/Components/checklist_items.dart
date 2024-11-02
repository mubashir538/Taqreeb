import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class GuideButton extends StatelessWidget {
  final String text;
  final String leftIconPath;
  final String rightIconPath;
  const GuideButton(
      {required this.text,
      required this.leftIconPath,
      required this.rightIconPath});

  @override
  Widget build(BuildContext context) {
    bool isleftSvg = false;
    bool isrightSvg = false;
    if (leftIconPath.substring(leftIconPath.length - 3) == 'svg') {
      isleftSvg = true;
    }
    if (rightIconPath.substring(rightIconPath.length - 3) == 'svg') {
      isrightSvg = true;
    }

    return Center(
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isleftSvg
                  ? SvgPicture.asset(
                      leftIconPath,
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      leftIconPath,
                      width: 24,
                      height: 24,
                    ),
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: MyColors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isrightSvg
                  ? SvgPicture.asset(
                      rightIconPath,
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      rightIconPath,
                      width: 24,
                      height: 24,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
