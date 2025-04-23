import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

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

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  void dispose() {
    widget.focusNode?.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    double pickerWidth = Screen.width(context) * 0.9;
    double pickerHeight = Screen.height(context) * 0.7;

    Color tempColor = selectedColor;
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: pickerWidth,
            height: pickerHeight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: tempColor,
                  onColorChanged: (Color color) {
                    tempColor = color;
                  },
                  // showLabel: false,
                  pickerAreaHeightPercent: 0.7,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedColor = tempColor;
                      widget.valueController.text = _colorToHex(selectedColor);
                    });
                    _removeOverlay();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.red,
                    foregroundColor: MyColors.white,
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
    return GestureDetector(
      onTap: () {
        if (_overlayEntry == null) {
          _showColorPicker();
        } else {
          _removeOverlay();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        height: Screen.height(context) * 0.06,
        width: Screen.width(context) * 0.9,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(102),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onTap: _showColorPicker,
                  focusNode: widget.focusNode,
                  onSubmitted: widget.onFieldSubmitted,
                  controller: widget.valueController,
                  readOnly: true,
                  style: GoogleFonts.montserrat(
                    fontSize: Screen.max(context) * 0.018,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.montserrat(
                      color: MyColors.white.withAlpha(153),
                      fontSize: Screen.max(context) * 0.015,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Icon(
                Icons.color_lens,
                color: selectedColor,
                size: Screen.max(context) * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
