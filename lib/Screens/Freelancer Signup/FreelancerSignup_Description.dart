import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class FreelancerSignup_Description extends StatefulWidget {
  const FreelancerSignup_Description({super.key});

  @override
  State<FreelancerSignup_Description> createState() => _FreelancerSignup_DescriptionState();
}

class _FreelancerSignup_DescriptionState extends State<FreelancerSignup_Description> {
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

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MaximumThing * 0.05,
                ),
                Container(
                  margin: EdgeInsets.all(MaximumThing * 0.01),
                  height: screenHeight * 0.4,
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
                SizedBox(
                  height: screenHeight * 0.05,
                  child: MyDivider(),
                ),
                ColoredButton(
                  text: "Continue",
                  onPressed: () {
                    Navigator.pushNamed(context, '/ProfilePictureUpload',
                                  arguments: {'type': 'freelancer'});
                  },
                )
              ],
            ),
          ),
        Positioned(
          child: Header(
            key: _headerKey,
                    heading: "Create A Description",
                    para:
                        "Your Description Creates a Great Impact on the customers and can help your get more clients ",
                  ),
        ),
                
        ],
      ),
    );
  }
}
