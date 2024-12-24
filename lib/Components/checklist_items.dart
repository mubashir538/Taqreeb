import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class GuideButton extends StatelessWidget {
  final String text;
  final String leftIconPath;
  final String rightIconPath;
  final IconData leftIcon;
  final IconData rightIcon;
  final Function onpressed;

  const GuideButton({
    super.key,
    required this.onpressed,
    required this.text,
    this.leftIconPath = '',
    this.rightIconPath = '',
    this.leftIcon = Icons.arrow_back,
    this.rightIcon = Icons.arrow_back,
  });

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDimension = MediaQuery.of(context).size.shortestSide;

    // Dynamic sizes
    final containerHeight = maxDimension * 0.08; // 8% of the shortest side
    final iconSize = maxDimension * 0.05; // 5% of the shortest side
    final fontSize = maxDimension * 0.015; // 4.5% of the shortest side

    // Determine if the icon is SVG
    final isLeftSvg = leftIconPath.isNotEmpty && leftIconPath.endsWith('svg');
    final isRightSvg =
        rightIconPath.isNotEmpty && rightIconPath.endsWith('svg');

    return InkWell(
      onTap: () => onpressed(),
      child: Center(
        child: Container(
          height: containerHeight.clamp(60, 80.0), // Min: 50, Max: 80
          width: screenWidth * 0.9, // 90% of screen width
          decoration: BoxDecoration(
            color: MyColors.DarkLighter,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: leftIconPath.isNotEmpty
                    ? (isLeftSvg
                        ? SvgPicture.asset(
                            leftIconPath,
                            width:
                                iconSize.clamp(20.0, 40.0), // Min: 20, Max: 40
                            height: iconSize.clamp(20.0, 40.0),
                          )
                        : Image.asset(
                            leftIconPath,
                            width: iconSize.clamp(20.0, 40.0),
                            height: iconSize.clamp(20.0, 40.0),
                          ))
                    : Icon(
                        leftIcon,
                        size: iconSize.clamp(20.0, 40.0),
                        color: MyColors.white,
                      ),
              ),

              // Text
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: fontSize.clamp(14.0, 22.0), // Min: 14, Max: 22
                    fontWeight: FontWeight.w500,
                    color: MyColors.white,
                  ),
                ),
              ),

              // Right Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: rightIconPath.isNotEmpty
                    ? (isRightSvg
                        ? SvgPicture.asset(
                            rightIconPath,
                            width: iconSize.clamp(20.0, 40.0),
                            height: iconSize.clamp(20.0, 40.0),
                          )
                        : Image.asset(
                            rightIconPath,
                            width: iconSize.clamp(20.0, 40.0),
                            height: iconSize.clamp(20.0, 40.0),
                          ))
                    : Icon(
                        rightIcon,
                        size: iconSize.clamp(20.0, 40.0),
                        color: MyColors.white,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
