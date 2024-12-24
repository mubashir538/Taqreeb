import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

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
    // Fetch screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDimension = MediaQuery.of(context).size.shortestSide;

    // Dynamically calculate sizes based on screen dimensions
    final containerHeight = screenHeight * 0.3; // 30% of screen height
    final containerWidth = screenWidth * 0.4; // 40% of screen width
    final iconHeight = maxDimension * 0.1; // 10% of the shortest dimension
    final fontSize = maxDimension * 0.04; // 4% of the shortest dimension

    return Center(
      child: Container(
        height: containerHeight.clamp(200.0, 300.0), // Min: 200, Max: 300
        width: containerWidth.clamp(150.0, 250.0), // Min: 150, Max: 250
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
                  height: iconHeight.clamp(40.0, 80.0), // Min: 40, Max: 80
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
                  fontSize: fontSize.clamp(14.0, 20.0), // Min: 14, Max: 20
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
