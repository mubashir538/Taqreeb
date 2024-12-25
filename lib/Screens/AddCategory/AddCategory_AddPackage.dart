import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class AddcategoryAddpackage extends StatefulWidget {
  const AddcategoryAddpackage({super.key});

  @override
  State<AddcategoryAddpackage> createState() => _AddcategoryAddpackageState();
}

class _AddcategoryAddpackageState extends State<AddcategoryAddpackage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController detailsController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: (screenHeight * 0.03) + _headerHeight),
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
          Positioned(
            child: Header(
              key: _headerKey,
              heading: 'Add Packages',
            ),
          ),
        ],
      ),
    );
  }
}
