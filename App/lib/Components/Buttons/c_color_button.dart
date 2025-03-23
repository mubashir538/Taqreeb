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

  const ColoredButton({
    required this.text,
    super.key,
    this.textSize = 0,
    this.height = 0,
    this.width = 0,
    this.onPressed,
  });

  @override
  _ColoredButtonState createState() => _ColoredButtonState();
}

class _ColoredButtonState extends State<ColoredButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
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
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        height: (widget.height != 0 ? widget.height : Screen.height(context) * 0.06) *
            (_isPressed ? 0.95 : 1.0),
        width: (widget.width != 0 ? widget.width : Screen.width(context) * 0.9) *
            (_isPressed ? 0.95 : 1.0),
        decoration: BoxDecoration(
          color: _isPressed ? MyColors.red.withOpacity(0.8) : MyColors.red,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: GoogleFonts.montserrat(
              fontSize: widget.textSize == 0
                  ? Screen.max(context) * 0.018
                  : widget.textSize,
              fontWeight: FontWeight.w500,
              color: MyColors.redonWhite,
            ),
          ),
        ),
      ),
    );
  }
}
