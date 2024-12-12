import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class ResponsiveDropdown extends StatefulWidget {
  final List<String> items;
  final String labelText;
  final Function(String) onChanged;

  const ResponsiveDropdown({
    Key? key,
    required this.items,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ResponsiveDropdownState createState() => _ResponsiveDropdownState();
}

class _ResponsiveDropdownState extends State<ResponsiveDropdown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9, // Make the dropdown responsive
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: screenWidth * 0.03, // Responsive font size
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: MyColors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: MyColors.red),
          ),
          filled: true,
          fillColor: MyColors.DarkLighter, // Background color
        ),
        dropdownColor: MyColors.DarkLighter, // Dropdown background color
        style: GoogleFonts.montserrat(
          color: MyColors.white,
          fontSize: screenWidth * 0.035, // Responsive font size
        ),
        value: selectedItem,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: MyColors.white),
        items: widget.items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: item == selectedItem ? MyColors.red : MyColors.whiteDarker,
                  size: screenWidth * 0.03, // Responsive icon size
                ),
                SizedBox(width: screenWidth * 0.02),
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
