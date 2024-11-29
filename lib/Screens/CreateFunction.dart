import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class CreateFunction extends StatefulWidget {
  const CreateFunction({super.key});

  @override
  State<CreateFunction> createState() => _CreateFunctionState();
}

class _CreateFunctionState extends State<CreateFunction> {
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Header(
                    heading: 'Create Funtion',
                    image: MyImages.Function,
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  MyTextBox(hint: 'Funtion Name'),
                  MyTextBox(hint: 'Budget'),
                  MyTextBox(hint: "Event Type"),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
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
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: TextField(
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        controller: _dateController,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.018,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range_rounded),
                          hintText: 'Select Date',
                          hintStyle: GoogleFonts.montserrat(
                            color: MyColors.white.withOpacity(0.6),
                            fontSize: MaximumThing * 0.015,
                          ),
                          border: InputBorder.none,
                        ),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  )
                ],
              ),
              ColoredButton(
                text: 'Add Funtion',
                onPressed: () {
                  Navigator.pushNamed(context, '/FunctionDetail');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      setState(() {
        _dateController.text = pickedDate.toString().split(" ")[0];
      });
    }
  }
}
