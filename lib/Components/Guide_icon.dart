import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class GuideIcon extends StatelessWidget {
  final String iconPath;
  final String text;

  const GuideIcon({
    Key? key,
    required this.iconPath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 240,
        width: 200, 
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: MyColors.DarkLighter),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, 
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  iconPath,
                  color: MyColors.white,
                  height: 50,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: MyColors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
