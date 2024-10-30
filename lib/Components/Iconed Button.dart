import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconedButton extends StatelessWidget {
  final String text;
  IconedButton({required this.text});

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
          borderRadius: BorderRadius.circular(10), 
        ),
        child: Center(
          child: Text(
            text, 
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w200,
              color: Colors.white, 
            ),
          ),
        ),
      ),
    );
  }
}
