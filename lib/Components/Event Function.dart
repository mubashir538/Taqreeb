import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';

class EventFuntion extends StatelessWidget {
  const EventFuntion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      child: Column(
         
        children: [
         
          Container(
            height: 76,
            width: 373,
            decoration: BoxDecoration(
               color:Color(0xffEF233c),
               borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
            
            ),
            child:Center(
              child: Text("Baraat",
                style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  backgroundColor: Color(0xffEF233c),
                ),
                ),
            ),
          ),
          Container(
            height: 290,
            width: 373,
            decoration: BoxDecoration(
               color:Color(0xff242526),
               borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),

            ),
            child: Column(
              children: [
                Row(
                  children: [
                     SizedBox(
                      height: 80,
                      width: 35,
        ),
                    Text("Budget:",
                  style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  
                ),
                ),
                    
                     SizedBox(
                      height: 80,
                      width: 100,
        ),
                    Text("200000",
                  style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  
                ),
                ),
                  ],
                
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 35,
        ),
                    Text(" Date",
                  style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  
                ),
                ),
                    
                     SizedBox(
                      height: 80,
                      width: 160,
        ),
                    Text("15-Dec-24",
                  style: GoogleFonts.montserrat(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  
                ),
                ),
                  ],
                ),
                Row(
                  children: [
                  
                   
                  ],
                ),
                Row(
                  children: [
                    
                    ColoredButton(
                    text: ("Edit Funtion"
                    ),
            
            ),
            SizedBox(
                      height: 80,
                      width: 20,
        ),
        
            ColoredButton(
              text: "See Details"
              ),
                  ],
                )
              ],
            ),
            

          ),
        ],
      ),
    );
  }
}