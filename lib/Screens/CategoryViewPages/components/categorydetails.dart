import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryDetails extends StatefulWidget {
  final List<String> headings;
  final List<String> values;
  final bool type; // Toggle between editable and static layout

  const CategoryDetails({
    super.key,
    required this.headings,
    required this.values,
    this.type = false,
  });

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  List<TextEditingController> controllers = [];
  List<bool> isEditing = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers and editing state for each value
    controllers = widget.values
        .map((value) => TextEditingController(text: value))
        .toList();
    isEditing = List<bool>.generate(widget.values.length, (_) => false);
  }

  Future<void> saveValue(int index) async {
    setState(() {
      widget.values[index] = controllers[index].text;
      isEditing[index] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${widget.headings[index]} updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    if (widget.type) {
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          children: [
            for (int i = 0; i < widget.headings.length; i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: maximumDimension * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.headings[i],
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.015,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      ),
                    ),
                    if (isEditing[i])
                      TextField(
                        controller: controllers[i],
                        style: GoogleFonts.montserrat(
                          fontSize: maximumDimension * 0.015,
                          color: MyColors.white,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter ${widget.headings[i]}...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      Text(
                        widget.values[i],
                        style: GoogleFonts.montserrat(
                          fontSize: maximumDimension * 0.015,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ColoredButton(
                        text: isEditing[i] ? "Save" : "Edit",
                        onPressed: isEditing[i]
                            ? () => saveValue(i)
                            : () => setState(() => isEditing[i] = true),
                      ),
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
          children: [
            for (int i = 0; i < widget.headings.length; i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: maximumDimension * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.headings[i],
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.015,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      ),
                    ),
                    Container(
                      width: maximumDimension * 0.5,
                      child: Text(
                        widget.values[i],
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: maximumDimension * 0.015,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
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
