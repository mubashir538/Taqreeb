import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumThing = screenWidth > screenHeight ? screenWidth : screenHeight;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(vertical: maximumThing * 0.01),
        height: (widget.height != 0 ? widget.height : screenHeight * 0.06) *
            (_isPressed ? 0.95 : 1.0),
        width: (widget.width != 0 ? widget.width : screenWidth * 0.9) *
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
                  ? maximumThing * 0.018
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
