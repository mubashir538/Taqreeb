import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class SelectionDialog extends StatelessWidget {


  const SelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 172,
        width: 285,
        decoration: BoxDecoration(
            color: Color(0xff242526),
            border: Border.all(
              color: Color(
                0xffEDF2F4,
              ),
            ),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
 
            
            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                Text(
                  "Baraat",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  width: 135,
                ),
               SvgPicture.asset(MyIcons.radioButton,
               height: 20,
               width: 20,
               color: MyColors.red),
              ],
            ),
            // Icon(

            // ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 209,
              child: Divider(
                color: Color(0xffEDF2F4),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rukhsati",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  width: 120,
                ),
                SvgPicture.asset(MyIcons.radioButton,
               height: 20,
               width: 20,
               color: MyColors.red),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 209,
              child: Divider(
                color: Color(0xffEDF2F4),
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Valima",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  width: 135,
                ),
                SvgPicture.asset(MyIcons.radioButton,
               height: 20,
               width: 20,
               color: MyColors.red),
              
              ],
            ),
            // Icon(

            // ),
          ],
        ),
      ),
    );
  }
}
