import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class BorderButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double height;
  final double width;
  final double textSize;
  const BorderButton({
    super.key,
    required this.text,
    this.textSize = 0,
    this.onPressed,
    this.height = 0,
    this.width = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        height: height != 0 ? height : Screen.height(context) * 0.06,
        width: width != 0 ? width : Screen.width(context) * 0.9,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.red, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
                fontSize:
                    textSize != 0 ? textSize : Screen.max(context) * 0.018,
                fontWeight: FontWeight.w600,
                color: colors.red),
          ),
        ),
      ),
    );
  }
}
