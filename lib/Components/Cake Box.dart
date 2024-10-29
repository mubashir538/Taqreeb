import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';

class CakeBox extends StatelessWidget {
  const CakeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 312,
            width: 150,
            decoration: BoxDecoration(
               color:Color(0xffEF233c),
               
            
            ),
      child: Column(
        children: [
          // Image(image: 
          // ),
          // Text(

          // ),
          // Text(

          // ),
          ColoredButton(
            text: "Rs, 2000"
            ),
            ColoredButton(
              text: "Add to Cart"
              ),
        ],
      ),
    );
  }
}