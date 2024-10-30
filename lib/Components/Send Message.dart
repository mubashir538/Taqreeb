import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendMessage extends StatelessWidget {
  final String text;
  SendMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    print(width);

    return Center(
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: Color(0xffEF233c),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), // Left side more oval-like
            bottomLeft: Radius.circular(30), // Left side more oval-like
            topRight: Radius.circular(15), // Right side slightly curved
            bottomRight: Radius.circular(0), // Right side slightly curved
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w200,
              color: Color(0xffEDF2F4),
            ),
          ),
        ),
      ),
    );
  }
}
