import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class AddcategoryMoredetails extends StatelessWidget {
  const AddcategoryMoredetails({super.key});

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
              heading: 'More Details',
            ),
            SizedBox(height: screenHeight * 0.04),
            PackageBox(
                packagedetails: 'Venue Type',
                packageprice: '',
                packagename: ''),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Category Type',
                packageprice: '',
                packagename: ''),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Guest Size',
                packageprice: '',
                packagename: ''),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Staff', packageprice: '', packagename: '')
          ],
        ),
      ),
    );
  }
}
