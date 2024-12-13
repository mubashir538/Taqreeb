import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AddcategoryPackages extends StatelessWidget {
  const AddcategoryPackages({super.key});

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
              heading: 'Packages',
            ),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Flower Decoration',
                packageprice: '300000',
                packagename: 'Basic package'),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Flower Decoration',
                packageprice: '300000',
                packagename: 'Basic package'),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Flower Decoration',
                packageprice: '300000',
                packagename: 'Basic package'),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Flower Decoration',
                packageprice: '300000',
                packagename: 'Basic package'),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Flower Decoration',
                packageprice: '300000',
                packagename: 'Basic package'),
            SizedBox(height: screenHeight * 0.03),
            PackageBox(
                packagedetails: 'Flower Decoration',
                packageprice: '300000',
                packagename: 'Basic package'),
            SizedBox(height: screenHeight * 0.03),
            Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: MyColors.white,
                      child: Image.asset(
                        MyIcons.add,
                        color: MyColors.DarkLighter,
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
