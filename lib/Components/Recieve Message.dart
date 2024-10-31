import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecieveMessage extends StatelessWidget {
  final String text;
  RecieveMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    print(width);

    return Center(
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: Color(0xFF303030),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0), // Left side more oval-like
            bottomLeft: Radius.circular(15), // Left side more oval-like
            topRight: Radius.circular(30), // Right side slightly curved
            bottomRight: Radius.circular(30), // Right side slightly curved
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: Color(0xffEDF2F4),
            ),
          ),
        ),
      ),
    );
  }
}
