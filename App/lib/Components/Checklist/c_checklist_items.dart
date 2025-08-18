import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

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
    this.leftIcon = FontAwesomeIcons.arrowLeft,
    this.rightIcon = FontAwesomeIcons.arrowRight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    final containerHeight = Screen.max(context) * 0.08;
    final iconSize = Screen.max(context) * 0.03;
    final fontSize = Screen.max(context) * 0.015;

    final isLeftSvg = leftIconPath.isNotEmpty && leftIconPath.endsWith('svg');
    final isRightSvg =
        rightIconPath.isNotEmpty && rightIconPath.endsWith('svg');

    return InkWell(
      onTap: () => onpressed(),
      child: Center(
        child: Container(
          height: containerHeight.clamp(60, 80.0),
          width: Screen.width(context) * 0.9,
          decoration: BoxDecoration(
            color: colors.lightDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: leftIconPath.isNotEmpty
                    ? (isLeftSvg
                        ? SvgPicture.asset(
                            leftIconPath,
                            width: iconSize.clamp(20.0, 40.0),
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
                        color: colors.white,
                      ),
              ),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: fontSize.clamp(14.0, 22.0),
                    fontWeight: FontWeight.w500,
                    color: colors.white,
                  ),
                ),
              ),
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
                        color: colors.white,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
