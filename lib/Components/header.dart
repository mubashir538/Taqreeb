import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class Header extends StatelessWidget {
  final String heading;
  final String para;
  final String image;
  const Header({this.heading = '', this.para = '', this.image = '', super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool hasSomething =
        heading.isNotEmpty || para.isNotEmpty || image.isNotEmpty;
    double MaximumThing;
    if (screenWidth > screenHeight) {
      MaximumThing = screenWidth;
    } else {
      MaximumThing = screenHeight;
    }
    return Container(
      height: hasSomething ? null : screenHeight * 0.009,
      width: screenWidth,
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 3),
      decoration: BoxDecoration(
        color: MyColors.red,
        borderRadius: hasSomething
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))
            : BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left_outlined,
                  color: MyColors.white, size: 50),
              Text(
                'Taqreeb',
                style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white),
              ),
              Icon(Icons.settings, color: MyColors.white, size: 40),
            ],
          ),
          // for png image
          // Image.asset(MyImages.Logo),
<<<<<<< Updated upstream
          // Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwG60sgdJ0mekPNNLzmpn3hrp6rwHt99pYBA&s')
=======
          Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwG60sgdJ0mekPNNLzmpn3hrp6rwHt99pYBA&s'),
>>>>>>> Stashed changes
          // for svg image
          // SvgPicture.asset(MyImages.FreelancerSignup),
          heading.isNotEmpty
              ? Column(children: [
                  SizedBox(height: 10),
                  Text(
                    heading,
                    style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.02,
                        fontWeight: FontWeight.w700,
                        color: MyColors.Yellow),
                  ),
                  SizedBox(
                      height: para.isNotEmpty || image.isNotEmpty ? 5 : 15),
                ])
              : Container(),
          para.isNotEmpty
              ? Column(children: [
                  SizedBox(height: 5),
                  Text(
                    para,
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white),
                  ),
                  SizedBox(height: image.isNotEmpty ? 5 : 15),
                ])
              : Container(),
          image.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: 10),
                    SvgPicture.asset(image,height: 15,width: 20,),
                    SizedBox(height: 15),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
