import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPBoxes extends StatelessWidget {
  const OTPBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          SizedBox(
          width: 200,
        ),
          Container(
            height: 63,
            width: 63.99,
            decoration: BoxDecoration(
            color:Color(0xff242526),
            borderRadius: BorderRadius.circular(10),
            
      ),
      
      child: Center(
        child: Text("4",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),
                ),
      ),
          ),
        SizedBox(
          width: 20,
        ),
            Container(
        height: 63,
        width: 63.99,
        decoration: BoxDecoration(
          color:Color(0xff242526),
          borderRadius: BorderRadius.circular(10),
      

        ),
        child: Center(
          child: Text("4",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),
                ),
        ),
            ),
            SizedBox(
          width: 20,
        ),
            Container(
              height: 63,
              width: 63.99,
              decoration: BoxDecoration(
                color:Color(0xff242526),
                borderRadius: BorderRadius.circular(10),
                

              ),
              child: Center(
                child: Text("4",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),
                ),
              ),
            ),
            SizedBox(
          width: 20,
        ),
           Container(
              height: 63,
              width: 63.99,
              decoration: BoxDecoration(
                color:Color(0xff242526),
                borderRadius: BorderRadius.circular(10),
            

              ),
              child: Center(
                child: Text("4",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),
                ),
              ),
            ),
          ],
        ),
        );
  }
}
