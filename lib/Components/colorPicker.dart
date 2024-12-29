import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

// ignore: must_be_immutable
class ColorPickerTextBox extends StatefulWidget {
  final String hint;
  final TextEditingController valueController;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const ColorPickerTextBox({
    super.key,
    required this.hint,
    this.onFieldSubmitted,
    this.focusNode,
    required this.valueController,
  });

  @override
  State<ColorPickerTextBox> createState() => _ColorPickerTextBoxState();
}

class _ColorPickerTextBoxState extends State<ColorPickerTextBox> {
  Color selectedColor = MyColors.red;
  OverlayEntry? _overlayEntry;

  // Convert color to hex
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Show the color picker widget using an Overlay
  void _showColorPicker() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    Color tempColor = selectedColor; // Temporary color for confirmation

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy - 300, // Position above the text box
        width: renderBox.size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.DarkLighter, // Custom background color
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Color Picker
                ColorPicker(
                  pickerColor: tempColor,
                  onColorChanged: (Color color) {
                    tempColor = color; // Update temporary color
                  },
                  showLabel: false,
                  pickerAreaHeightPercent: 0.8,
                ),
                const SizedBox(height: 10),
                // Confirm Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedColor = tempColor; // Update selected color
                      widget.valueController.text = _colorToHex(selectedColor);
                    });
                    _removeOverlay(); // Close the overlay
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.red, // Confirm button color
                    foregroundColor: MyColors.white, // Text color
                  ),
                  child: const Text("Confirm"),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return GestureDetector(
      onTap: () {
        if (_overlayEntry == null) {
          _showColorPicker();
        } else {
          _removeOverlay();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: maxDimension * 0.01),
        height: screenHeight * 0.06,
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: widget.focusNode,
                  onSubmitted: widget.onFieldSubmitted,
                  controller: widget.valueController,
                  readOnly: true,
                  style: GoogleFonts.montserrat(
                    fontSize: maxDimension * 0.018,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.montserrat(
                      color: MyColors.white.withOpacity(0.6),
                      fontSize: maxDimension * 0.015,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // Icon Button for Color Picker
              Icon(
                Icons.color_lens,
                color: selectedColor,
                size: maxDimension * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
