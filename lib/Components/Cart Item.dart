import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CartItems extends StatelessWidget {
  const CartItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: 140,
      width: 405,
      decoration: BoxDecoration(
        color: Color(0xff242526),
       border: Border.all(color: Color(0xffEDF2F4,), 
                        ),
              borderRadius: BorderRadius.circular(16)
            
      ),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
                    "Cakes",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      color: Color(0xffFFBE0B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
          
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              ClipRRect(
                 borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://mrbrownbakery.com/image/images/GJ7uCwGiteTF24HTWBclkziVTdhpQeZWH23MvQfq.jpeg?p=full",
                  height: 70,
                  width: 70,
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

              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    "Choco Nutela:",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Rs, 2000",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),

              //  Row(
              //   children: [
              SizedBox(
                width: 55,
              ),
              Container(
                height: 25,
                width: 115,
                decoration: BoxDecoration(
                    color: Color(0xff18191A),
                    border: Border.all(
                      color: Color(
                        0xffEDF2F4,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                   child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.star, color: Colors.white, size: 16), 
          Text(
            "2",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Icon(Icons.favorite, color: Colors.white, size: 16), 
        ],
      ),

              ),
            ],
          ),
        ],
      ),
    ));
  }
}
