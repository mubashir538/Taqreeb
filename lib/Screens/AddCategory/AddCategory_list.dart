import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class AddcategoryList extends StatefulWidget {
  const AddcategoryList({super.key});

  @override
  State<AddcategoryList> createState() => _AddcategoryListState();
}

class _AddcategoryListState extends State<AddcategoryList> {
  TextEditingController nameController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Basic Details',
            ),
            SizedBox(height: screenHeight * 0.03),
            MyTextBox(
              hint: 'Name',
              valueController: nameController,
            ),
            SizedBox(height: screenHeight * 0.01),
            Container(
              margin: EdgeInsets.all(MaximumThing * 0.01),
              height: screenHeight * 0.3,
              width: screenWidth * 0.9,
              padding: EdgeInsets.symmetric(
                  horizontal: MaximumThing * 0.03,
                  vertical: MaximumThing * 0.02),
              decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(2, 2))
                ],
              ),
              child: TextField(
                maxLines: 10,
                style: GoogleFonts.montserrat(
                    color: MyColors.white,
                    fontSize: MaximumThing * 0.018,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.montserrat(
                    color: MyColors.white,
                    fontSize: MaximumThing * 0.018,
                    fontWeight: FontWeight.w300,
                  ),
                  hintText: "Enter Description",
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "1100 characters left",
                    style: GoogleFonts.montserrat(
                      color: MyColors.white,
                      fontSize: MaximumThing * 0.018,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(
              hint: 'Location',
              valueController: locationController,
            ),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(
              hint: 'Category Type',
              valueController: typeController,
            ),
          ],
        ),
      ),
    );
  }
}
