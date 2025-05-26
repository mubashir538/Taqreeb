import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class ColoredButton extends StatefulWidget {
  final String text;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final double textSize;
  final IconData? icon; // New parameter for icon
  final double? iconSize;
  final Color? iconColor;
  final double gapBetweenIconAndText; // Space between icon and text
  final Gradient? gradient; // Gradient background
  final Color? buttonColor; // Solid color (overrides gradient if both provided)
  final BoxBorder? border;
  final BorderRadius? borderRadius;

  const ColoredButton({
    required this.text,
    super.key,
    this.textSize = 0,
    this.height = 0,
    this.width = 0,
    this.onPressed,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.gapBetweenIconAndText = 8.0,
    this.gradient,
    this.buttonColor,
    this.border,
    this.borderRadius,
  });

  @override
  ColoredButtonState createState() => ColoredButtonState();
}

class ColoredButtonState extends State<ColoredButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (mounted) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    final effectiveColor = widget.buttonColor ?? colors.red;
    final pressedColor = effectiveColor.withAlpha(204);
    final defaultBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(10);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        height: (widget.height != 0
                ? widget.height
                : Screen.height(context) * 0.06) *
            (_isPressed ? 0.95 : 1.0),
        width:
            (widget.width != 0 ? widget.width : Screen.width(context) * 0.9) *
                (_isPressed ? 0.95 : 1.0),
        decoration: BoxDecoration(
          color: widget.gradient == null
              ? (_isPressed ? pressedColor : effectiveColor)
              : null,
          gradient: widget.gradient != null
              ? (_isPressed
                  ? LinearGradient(
                      colors: [
                        pressedColor.withOpacity(0.8),
                        pressedColor.withOpacity(0.9),
                      ],
                    )
                  : widget.gradient)
              : null,
          borderRadius: defaultBorderRadius,
          border: widget.border,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: widget.iconSize ?? Screen.max(context) * 0.022,
                  color: widget.iconColor ?? colors.redonWhite,
                ),
                SizedBox(width: widget.gapBetweenIconAndText),
              ],
              Text(
                widget.text,
                style: GoogleFonts.roboto(
                  fontSize: widget.textSize == 0
                      ? Screen.max(context) * 0.018
                      : widget.textSize,
                  fontWeight: FontWeight.w500,
                  color: colors.redonWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
