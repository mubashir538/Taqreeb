import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class DescriptionCategory extends StatefulWidget {
  final Map listing;
  final bool type; 

  const DescriptionCategory({super.key, required this.listing, this.type = true});

  @override
  State<DescriptionCategory> createState() => _DescriptionCategoryState();
}

class _DescriptionCategoryState extends State<DescriptionCategory> {
  bool isToggled = true;
  bool isEditing = false;
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.listing['Listing']['description'] ?? '';
  }

  Future<void> saveDescription() async {
    String newDescription = descriptionController.text;

    try {
      final response = await MyApi.postRequest(
        endpoint: '/update-description', 
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'id': widget.listing['Listing']['id'], 
          'description': newDescription,
        },
      );

      if (response['success']) {
        setState(() {
          isEditing = false;
          widget.listing['Listing']['description'] = newDescription;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Description updated successfully!')),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to update description.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
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
            Container(
              margin: EdgeInsets.only(bottom: maximumDimension * 0.015),
              child: Text(
                "Description",
                style: GoogleFonts.montserrat(
                  fontSize: maximumDimension * 0.025,
                  fontWeight: FontWeight.w600,
                  color: MyColors.Yellow,
                ),
              ),
            ),
            if (isEditing)
              Column(
                children: [
                  TextField(
                    controller: descriptionController,
                    maxLines: null,
                    style: GoogleFonts.montserrat(
                      fontSize: maximumDimension * 0.015,
                      fontWeight: FontWeight.w300,
                      color: MyColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Edit description...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ColoredButton(
                    text: 'Save',
                    onPressed: saveDescription,
                  ),
                ],
              )
            else
              InkWell(
                onTap: () => setState(() => isToggled = !isToggled),
                child: Padding(
                  padding: EdgeInsets.only(bottom: maximumDimension * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.listing['Listing']['description'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: isToggled ? 6 : 200,
                        style: GoogleFonts.montserrat(
                          fontSize: maximumDimension * 0.015,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Icon(isToggled
                          ? Icons.arrow_downward_outlined
                          : Icons.arrow_upward_outlined),
                    ],
                  ),
                ),
              ),
            SizedBox(height: screenHeight * 0.02),
            if (!isEditing)
              ColoredButton(
                text: 'Edit',
                onPressed: () => setState(() => isEditing = true),
              ),
          ],
        ),
      );
    } else {
      // Static layout (no edit option)
      return Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: maximumDimension * 0.015),
              child: Text(
                "Description",
                style: GoogleFonts.montserrat(
                  fontSize: maximumDimension * 0.025,
                  fontWeight: FontWeight.w600,
                  color: MyColors.Yellow,
                ),
              ),
            ),
            InkWell(
              onTap: () => setState(() => isToggled = !isToggled),
              child: Padding(
                padding: EdgeInsets.only(bottom: maximumDimension * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.listing['Listing']['description'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: isToggled ? 6 : 200,
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.015,
                        fontWeight: FontWeight.w300,
                        color: MyColors.white,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Icon(isToggled
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
