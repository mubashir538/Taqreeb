import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class AddcategoryAddaddons extends StatefulWidget {
  AddcategoryAddaddons({super.key});

  @override
  State<AddcategoryAddaddons> createState() => _AddcategoryAddaddonsState();
}

class _AddcategoryAddaddonsState extends State<AddcategoryAddaddons> {
  TextEditingController nameController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController perheadController = TextEditingController();

  TextEditingController headtypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Add AddOns',
            ),
            SizedBox(height: screenHeight * 0.03),
            MyTextBox(
              hint: 'Name',
              valueController: nameController,
            ),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(
              hint: 'Price',
              valueController: priceController,
            ),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(hint: 'Per Head', valueController: perheadController),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(hint: 'Head Type', valueController: headtypeController),
          ],
        ),
      ),
    );
  }
}
