import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';

class AddcategoryAddpackage extends StatefulWidget {
  const AddcategoryAddpackage({super.key});

  @override
  State<AddcategoryAddpackage> createState() => _AddcategoryAddpackageState();
}

class _AddcategoryAddpackageState extends State<AddcategoryAddpackage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController detailsController = TextEditingController();

  TextEditingController priceController = TextEditingController();

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
              heading: 'Add Packages',
            ),
            SizedBox(height: screenHeight * 0.03),
            MyTextBox(
              hint: 'Name',
              valueController: nameController,
            ),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(
              hint: 'Details',
              valueController: detailsController,
            ),
            SizedBox(height: screenHeight * 0.01),
            MyTextBox(
              hint: 'Price',
              valueController: priceController,
            ),
          ],
        ),
      ),
    );
  }
}
