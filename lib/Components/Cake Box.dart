import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class CakeBox extends StatelessWidget {
  const CakeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 322,
        width: 150,
        decoration: BoxDecoration(
          color: Color(0xff242526),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
             decoration: BoxDecoration(
              
             ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(29.35),topRight: Radius.circular(29.35)),
                child: Image.network(
                  "https://mrbrownbakery.com/image/images/GJ7uCwGiteTF24HTWBclkziVTdhpQeZWH23MvQfq.jpeg?p=full",
                  
                  height: 150,
                  width: 150,
                 
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                
                            
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Text('Failed to load image');
                  },
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                   SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Choco - Nutela ",
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffEDF2F4)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "A Luscious dessert, perfect for chocolate lovers. Densely chocolatey lava,along with a..... ",
                     textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 8,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffEDF2F4)),
                  ),
                ],
              ),
            ),
             SizedBox(
                    height: 15,
                  ),
            ColoredButton(text: "Rs, 2000",),

            // ColoredButton(text: "Add to Cart"),
          ],
        ),
      ),
    );
  }
}
