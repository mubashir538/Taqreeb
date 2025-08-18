import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class ResponsiveDropdown extends StatefulWidget {
  final List<String> items;
  final String labelText;
  final Function(String) onChanged;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final String? selectedOption; // Add this parameter

  const ResponsiveDropdown({
    super.key,
    this.onFieldSubmitted,
    this.focusNode,
    required this.items,
    required this.labelText,
    required this.onChanged,
    this.selectedOption = '', // Initialize it here
  });

  @override
  ResponsiveDropdownState createState() => ResponsiveDropdownState();
}

class ResponsiveDropdownState extends State<ResponsiveDropdown> {
  String? selectedItem;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Set the initial selectedItem if selectedOption is provided and exists in items
    if (widget.selectedOption != '' &&
        widget.items.contains(widget.selectedOption)) {
      selectedItem = widget.selectedOption;
    }
    _focusNode.addListener(_handleFocusChange);
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    if (widget.focusNode != null) {
      widget.focusNode!.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus || (widget.focusNode?.hasFocus ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.01),
      child: DropdownButtonFormField<String>(
        focusNode: widget.focusNode ?? _focusNode,
        onSaved: (value) => widget.onFieldSubmitted,
        decoration: InputDecoration(
          labelText: widget.labelText,
          contentPadding: EdgeInsets.all(Screen.max(context) * 0.02),
          labelStyle: GoogleFonts.roboto(
            color: _isFocused ? colors.red : colors.white.withAlpha(102),
            fontSize: Screen.width(context) * 0.03,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colors.red),
          ),
          filled: true,
          fillColor: colors.lightDark,
        ),
        dropdownColor: colors.darkLighter,
        style: GoogleFonts.roboto(
          color: colors.white,
          fontSize: Screen.width(context) * 0.035,
        ),
        value: selectedItem,
        isExpanded: true,
        icon: Icon(
          FontAwesomeIcons.caretDown,
          color: _isFocused ? colors.red : colors.white,
        ),
        items: widget.items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: item == selectedItem ? colors.red : colors.whiteDarker,
                  size: Screen.width(context) * 0.03,
                ),
                SizedBox(width: Screen.width(context) * 0.02),
                Text(item),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedItem = value!;
          });
          widget.onChanged(value!);
        },
      ),
    );
  }
}
