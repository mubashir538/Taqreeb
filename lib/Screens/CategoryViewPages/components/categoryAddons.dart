import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryAddons extends StatefulWidget {
  final List<String> addonsheadings;
  final List<String> addonsvalues;
  final bool type; // Toggle between editable and static layout

  const CategoryAddons({
    super.key,
    required this.addonsheadings,
    required this.addonsvalues,
    this.type = true,
  });

  @override
  State<CategoryAddons> createState() => _CategoryAddonsState();
}

class _CategoryAddonsState extends State<CategoryAddons> {
  late List<TextEditingController> headingControllers;
  late List<TextEditingController> valueControllers;
  late List<bool> isEditingHeading;
  late List<bool> isEditingValue;

  @override
  void initState() {
    super.initState();
    headingControllers = widget.addonsheadings
        .map((heading) => TextEditingController(text: heading))
        .toList();
    valueControllers = widget.addonsvalues
        .map((value) => TextEditingController(text: value))
        .toList();
    isEditingHeading = List<bool>.generate(widget.addonsheadings.length, (_) => false);
    isEditingValue = List<bool>.generate(widget.addonsvalues.length, (_) => false);
  }

  // Method to save the edited heading and value
  void saveAddon(int index) {
    setState(() {
      widget.addonsheadings[index] = headingControllers[index].text;
      widget.addonsvalues[index] = valueControllers[index].text;
      isEditingHeading[index] = false;
      isEditingValue[index] = false;
    });
  }

  // Method to add a new add-on
  void addAddon() {
    setState(() {
      widget.addonsheadings.add('New Addon');
      widget.addonsvalues.add('0');
      headingControllers.add(TextEditingController(text: 'New Addon'));
      valueControllers.add(TextEditingController(text: '0'));
      isEditingHeading.add(false);
      isEditingValue.add(false);
    });
  }

  // Method to delete an add-on
  void deleteAddon(int index) {
    setState(() {
      widget.addonsheadings.removeAt(index);
      widget.addonsvalues.removeAt(index);
      headingControllers.removeAt(index);
      valueControllers.removeAt(index);
      isEditingHeading.removeAt(index);
      isEditingValue.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    if (widget.type) {
      // Editable layout
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add-Ons',
              style: GoogleFonts.montserrat(
                fontSize: maximumDimension * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                children: [
                  for (int i = 0; i < widget.addonsheadings.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: maximumDimension * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add-On ${i + 1}',
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              fontWeight: FontWeight.w500,
                              color: MyColors.Yellow,
                            ),
                          ),
                          // Heading Field
                          if (isEditingHeading[i])
                            TextField(
                              controller: headingControllers[i],
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                color: MyColors.white,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Addon Name',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            Text(
                              widget.addonsheadings[i],
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                          // Value Field
                          if (isEditingValue[i])
                            TextField(
                              controller: valueControllers[i],
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                color: MyColors.white,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Addon Price',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            Text(
                              widget.addonsvalues[i],
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.015,
                                fontWeight: FontWeight.w400,
                                color: MyColors.white,
                              ),
                            ),
                          // Edit and Save Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ColoredButton(
                                text: isEditingHeading[i] ? 'Save' : 'Edit Name',
                                width: screenWidth * 0.25,
                                textSize: maximumDimension * 0.015,
                                onPressed: isEditingHeading[i]
                                    ? () => saveAddon(i)
                                    : () => setState(() => isEditingHeading[i] = true),
                              ),
                              SizedBox(width: maximumDimension * 0.02),
                              ColoredButton(
                                textSize: maximumDimension * 0.015,
                                width: screenWidth * 0.25,
                                text: isEditingValue[i] ? 'Save' : 'Edit Price',
                                onPressed: isEditingValue[i]
                                    ? () => saveAddon(i)
                                    : () => setState(() => isEditingValue[i] = true),
                              ),
                              SizedBox(width: maximumDimension * 0.02),
                              ColoredButton(
                                textSize: maximumDimension * 0.015,
                                width: screenWidth * 0.25,
                                text: 'Delete',
                                onPressed: () => deleteAddon(i),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  // Button to add new add-on
                  ColoredButton(
                    text: 'Add New Add-On',
                    onPressed: addAddon,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Static layout
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add-Ons',
              style: GoogleFonts.montserrat(
                fontSize: maximumDimension * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                children: [
                  for (int i = 0; i < widget.addonsheadings.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: maximumDimension * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.addonsheadings[i],
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              fontWeight: FontWeight.w500,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Text(
                            widget.addonsvalues[i],
                            style: GoogleFonts.montserrat(
                              fontSize: maximumDimension * 0.015,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
