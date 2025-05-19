import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/core/utils/color.dart';

class IconedButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onPressed;

  const IconedButton({
    required this.onPressed,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(
          Screen.width(context) * 0.05), // Half of width for perfect circle
      child: Center(
        child: Container(
          width: Screen.width(context) * 0.15, // 20% of screen width
          height:
              Screen.width(context) * 0.15, // Same as width for perfect circle
          decoration: BoxDecoration(
            color: MyColors.ligthDark,
            shape: BoxShape.circle, // Makes it a perfect circle
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(102),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(2, 2),
              )
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              height: Screen.width(context) * 0.1, // Half of container size
            ),
          ),
        ),
      ),
    );
  }
}
