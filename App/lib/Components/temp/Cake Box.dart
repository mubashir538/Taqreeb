import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
              decoration: BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://mrbrownbakery.com/image/images/GJ7uCwGiteTF24HTWBclkziVTdhpQeZWH23MvQfq.jpeg?p=full",
                  height: 150,
                  width: 150,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.red, BlendMode.colorBurn)),
                    ),
                  ),
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
                    style: GoogleFonts.roboto(
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
                    style: GoogleFonts.roboto(
                        fontSize: 8,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffEDF2F4)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 17,
            ),
            ColoredButton(
              text: "Rs, 200",
              height: 16,
              width: 70,
            ),
            ColoredButton(
              text: "Add to Cart",
              height: 21,
              width: 120,
            ),
          ],
        ),
      ),
    );
  }
}
