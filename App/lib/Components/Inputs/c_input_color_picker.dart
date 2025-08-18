import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Color selectedColor = Color(0xffF13F5A);
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  void dispose() {
    widget.focusNode?.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showColorPicker() {
    if (_overlayEntry != null) return;

    double pickerWidth = Screen.width(context) * 0.9;
    double pickerHeight = Screen.height(context) * 0.7;
    final colors = AppColors(context);

    Color tempColor = selectedColor;
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {}, // Prevent taps from closing the overlay
        child: Stack(
          children: [
            // Semi-transparent background
            Positioned.fill(
              child: GestureDetector(
                  onTap: _removeOverlay,
                  child: Container(color: Colors.black.withAlpha(128))),
            ),
            // Color picker content
            Center(
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: pickerWidth,
                    height: pickerHeight,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.lightDark,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(51),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: WillPopScope(
                      onWillPop: () async {
                        _removeOverlay();
                        return false;
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ColorPicker(
                            pickerColor: tempColor,
                            onColorChanged: (Color color) {
                              tempColor = color;
                            },
                            pickerAreaHeightPercent: 0.7,
                            portraitOnly: true, // Force portrait mode
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedColor = tempColor;
                                widget.valueController.text =
                                    _colorToHex(selectedColor);
                              });
                              _removeOverlay();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.red,
                              foregroundColor: colors.white,
                            ),
                            child: const Text("Confirm"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
    final colors = AppColors(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
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
            color: colors.darkLighter,
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
                    style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.018,
                      fontWeight: FontWeight.w400,
                      color: colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: GoogleFonts.roboto(
                        color: colors.white.withAlpha(153),
                        fontSize: Screen.max(context) * 0.015,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(
                  FontAwesomeIcons.palette,
                  color: selectedColor,
                  size: Screen.max(context) * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
