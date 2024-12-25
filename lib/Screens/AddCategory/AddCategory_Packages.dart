import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AddcategoryPackages extends StatefulWidget {
  const AddcategoryPackages({super.key});

  @override
  State<AddcategoryPackages> createState() => _AddcategoryPackagesState();
}

class _AddcategoryPackagesState extends State<AddcategoryPackages> {
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
                SizedBox(height:( screenHeight * 0.03)+ _headerHeight),
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
          Positioned(
            child: Header(
              key: _headerKey,
              heading: 'Packages',
            ),
          ),
        ],
      ),
    );
  }
}
