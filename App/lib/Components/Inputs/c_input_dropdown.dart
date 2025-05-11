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

  const ResponsiveDropdown({
    super.key,
    this.onFieldSubmitted,
    this.focusNode,
    required this.items,
    required this.labelText,
    required this.onChanged,
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
    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.02),
      child: DropdownButtonFormField<String>(
        focusNode: widget.focusNode ?? _focusNode,
        onSaved: (value) => widget.onFieldSubmitted,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: GoogleFonts.roboto(
            color: _isFocused ? MyColors.red : Colors.white.withAlpha(102),
            fontSize: Screen.width(context) * 0.03,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColors.red),
          ),
          filled: true,
          fillColor: MyColors.darkLighter,
        ),
        dropdownColor: MyColors.darkLighter,
        style: GoogleFonts.roboto(
          color: MyColors.white,
          fontSize: Screen.width(context) * 0.035,
        ),
        value: selectedItem,
        isExpanded: true,
        icon: Icon(
          FontAwesomeIcons.caretDown,
          color: _isFocused ? MyColors.red : MyColors.white,
        ),
        items: widget.items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: item == selectedItem
                      ? MyColors.red
                      : MyColors.whiteDarker,
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
