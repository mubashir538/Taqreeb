import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class GuideIcon extends StatelessWidget {
  final String iconPath;
  final String text;

  const GuideIcon({
    super.key,
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    final containerHeight = Screen.height(context) * 0.3;
    final containerWidth = Screen.width(context) * 0.4;
    final iconHeight = Screen.max(context) * 0.1;
    final fontSize = Screen.max(context) * 0.04;

    return Center(
      child: Container(
        height: containerHeight.clamp(200.0, 300.0),
        width: containerWidth.clamp(150.0, 250.0),
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: MyColors.DarkLighter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  iconPath,
                  color: MyColors.white,
                  height: iconHeight.clamp(40.0, 80.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: fontSize.clamp(14.0, 20.0),
                  fontWeight: FontWeight.w500,
                  color: MyColors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
