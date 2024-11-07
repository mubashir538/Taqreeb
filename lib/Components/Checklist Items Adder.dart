import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChecklistItemsAdder extends StatelessWidget {
  final String text;
  const ChecklistItemsAdder({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    print(width);

    return Center(
      child: Container(
          height: 26,
          width: 156,
          decoration: BoxDecoration(
              color: Color(0xff18191A),
              border: Border.all(color: Color(0xffEDF2F4,), 
                        ),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
              child: Text(text,
                  style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(
                        0xffEDF2F4,
                      ))))),
    );
  }
}