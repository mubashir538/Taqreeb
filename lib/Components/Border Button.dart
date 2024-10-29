import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BorderButton extends StatelessWidget {
  final String venue;
  BorderButton({required String this.venue});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    print(width);

    return Center(
      child: Container(
          height: 60,
          width: 400,
          decoration: BoxDecoration(
              color: Color(0xff18191A),
              border: Border.all(color: Color(0xffEF233c,), 
                        ),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(venue,
                  style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(
                        0xffEF233c,
                      ))))),
    );
  }
}
