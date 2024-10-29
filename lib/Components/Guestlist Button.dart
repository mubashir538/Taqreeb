import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuestListButton extends StatelessWidget {
  final String name;
  final String phoneNumber;
  GuestListButton({required this.name, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    print(width);

    return Center(
      child: Container(
        height: 80, 
        width: 400,
        decoration: BoxDecoration(
          color: Color(0xFF303030), 
          borderRadius: BorderRadius.circular(10), 
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10), // name aur number se phle ki jagaj
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              const SizedBox(height: 10), 
              Text(
                name, 
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white, 
                ),
              ),
              const SizedBox(height: 5), 
              Text(
                phoneNumber,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
